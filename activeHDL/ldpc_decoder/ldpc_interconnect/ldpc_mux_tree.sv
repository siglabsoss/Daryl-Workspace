// ldpc_mux_tree.sv
//

`timescale 10ps / 10ps

`default_nettype none

module ldpc_mux_tree #(
    parameter integer WIDTH = 8,
    parameter integer NUM_RAMS = 24,
    parameter integer EXPANSION_FACTOR = 96,
    parameter integer TO_BRANCH = 0,
    parameter integer TO_RAM = 0
) (
    input  logic [8*WIDTH-1:0]            i_data,
    input  logic [8*EXPANSION_FACTOR-1:0] i_offset,
    input  logic [8*$clog2(NUM_RAMS)-1:0] i_ram_addr,
    input  logic [8*$clog2(8)-1:0]        i_to_branch,
    input  logic                          i_valid,
    output logic [WIDTH-1:0]              o_data,
    output logic [EXPANSION_FACTOR-1:0]   o_addr,
    output logic                          o_valid,
    input  logic                          i_clock,
    input  logic                          i_reset
);

localparam integer OUT_BRANCHES = 8;
localparam integer IN_BRANCHES = 8;

logic [IN_BRANCHES*WIDTH-1:0]            data_reg0;
logic [IN_BRANCHES*EXPANSION_FACTOR-1:0] addr_reg0;
logic [IN_BRANCHES-1:0]                  branch_valids_reg0;
logic [IN_BRANCHES-1:0]                  ram_valids_reg0;
logic                                    valid_reg0;

always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        valid_reg0 <= 1'b0;
    end else begin
        valid_reg0 <= i_valid;
    end

    if (i_valid == 1'b1) begin
        for (integer branch = 0; branch < IN_BRANCHES; branch++) begin
            branch_valids_reg0[branch] <= i_to_branch == TO_BRANCH;
            ram_valids_reg0[branch] <= i_ram_addr == TO_RAM;
        end
    end
    data_reg0 <= i_data;
    addr_reg0 <= i_offset;
end

logic [IN_BRANCHES/2*WIDTH-1:0]            data_reg1;
logic [IN_BRANCHES/2*EXPANSION_FACTOR-1:0] addr_reg1;
logic [IN_BRANCHES/2-1:0]                  branch_valids_reg1;
logic [IN_BRANCHES/2-1:0]                  ram_valids_reg1;
logic                                      valid_reg1;

always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        valid_reg1 <= 1'b0;
    end else begin
        valid_reg1 <= valid_reg0;
    end

    if (valid_reg0 == 1'b1) begin
        for (integer branch = 0; branch < IN_BRANCHES/2; branch++) begin
            branch_valids_reg1[branch] <= |(branch_valids_reg0[2*branch:2*branch+1]);
            ram_valids_reg1[branch] <= |(ram_valids_reg0[2*branch:2*branch+1]);
        end
    end else begin
        for (integer branch = 0; branch < IN_BRANCHES/4; branch++) begin
            branch_valids_reg1[branch] <= 1'b0;
            ram_valids_reg1[branch] <= 1'b0;
        end
    end

    for (integer branch = 0; branch < IN_BRANCHES/2; branch++) begin
        if (branch_valids_reg0[2*branch] == 1'b1) begin
            data_reg1[branch*WIDTH-1:0] <= data_reg0[2*branch*WIDTH-1:0];
            addr_reg1[branch*WIDTH-1:0] <= data_reg0[2*branch*WIDTH-1:0];
        end else begin
            data_reg1[branch*WIDTH-1:0] <= data_reg0[(2*branch + 1)*WIDTH-1:WIDTH];
            addr_reg1[branch*WIDTH-1:0] <= data_reg0[(2*branch + 1)*WIDTH-1:WIDTH];
        end
    end
end

logic [IN_BRANCHES/4*WIDTH-1:0]            data_reg2;
logic [IN_BRANCHES/4*EXPANSION_FACTOR-1:0] addr_reg2;
logic [IN_BRANCHES/4-1:0]                  branch_valids_reg2;
logic [IN_BRANCHES/4-1:0]                  ram_valids_reg2;
logic                                      valid_reg2;

always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        valid_reg2 <= 1'b0;
    end else begin
        valid_reg2 <= valid_reg1;
    end

    if (valid_reg1 == 1'b1) begin
        for (integer branch = 0; branch < IN_BRANCHES/4; branch++) begin
            branch_valids_reg2[branch] <= |(branch_valids_reg1[2*branch:2*branch+1]);
            ram_valids_reg2[branch] <= |(ram_valids_reg1[2*branch:2*branch+1]);
        end
    end else begin
        for (integer branch = 0; branch < IN_BRANCHES/4; branch++) begin
            branch_valids_reg2[branch] <= 1'b0;
            ram_valids_reg2[branch] <= 1'b0;
        end
    end

    for (integer branch = 0; branch < IN_BRANCHES/4; branch++) begin
        if (branch_valids_reg1[2*branch] == 1'b1) begin
            data_reg2[branch*WIDTH-1:0] <= data_reg1[2*branch*WIDTH-1:0];
            addr_reg2[branch*WIDTH-1:0] <= data_reg1[2*branch*WIDTH-1:0];
        end else begin
            data_reg2[branch*WIDTH-1:0] <= data_reg1[(2*branch + 1)*WIDTH-1:WIDTH];
            addr_reg2[branch*WIDTH-1:0] <= data_reg1[(2*branch + 1)*WIDTH-1:WIDTH];
        end
    end
end

logic [WIDTH-1:0]            data_reg3;
logic [EXPANSION_FACTOR-1:0] addr_reg3;
logic                        branch_valid_reg3;
logic                        ram_valid_reg3;
logic                        valid_reg3;

always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        valid_reg3 <= 1'b0;
    end else begin
        valid_reg3 <= valid_reg2;
    end

    if (valid_reg2 == 1'b1) begin
        branch_valid_reg3 <= |(branch_valids_reg2[2*branch:2*branch+1]);
        ram_valid_reg3 <= |(ram_valids_reg2[2*branch:2*branch+1]);
    end else begin
        branch_valid_reg3 <= 1'b0;
        ram_valid_reg3 <= 1'b0;
    end

    for (integer branch = 0; branch < IN_BRANCHES/2; branch++) begin
        if (branch_valids_reg2[2*branch] == 1'b1) begin
            data_reg3[branch*WIDTH-1:0] <= data_reg2[2*branch*WIDTH-1:0];
            addr_reg3[branch*WIDTH-1:0] <= data_reg2[2*branch*WIDTH-1:0];
        end else begin
            data_reg3[branch*WIDTH-1:0] <= data_reg2[(2*branch + 1)*WIDTH-1:WIDTH];
            addr_reg3[branch*WIDTH-1:0] <= data_reg2[(2*branch + 1)*WIDTH-1:WIDTH];
        end
    end
end

always_ff @(posedge i_clock) begin
    o_data <= data_reg3;
    o_addr <= addr_reg3;
    o_valid <= valid_reg3 & branch_valid_reg3 & ram_valid_reg3;
end

endmodule: ldpc_mux_tree

`default_nettype wire
