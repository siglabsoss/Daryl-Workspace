`timescale 10ps / 10ps

`default_nettype none

module ldpc_super_ram #(
    parameter integer WIDTH = 8,
    parameter integer NUM_RAMS = 12,
    parameter integer EXPANSION_FACTOR = 96,
    parameter string resource = "distributed"
    // Options: "block_ram", "distributed", "registers", "trust"
) (
    // Address + Data interface for input stream
    input  wire logic [8*NUM_RAMS*WIDTH-1:0]                    i_in_data,
    input  wire logic [8*NUM_RAMS*$clog2(EXPANSION_FACTOR)-1:0] i_in_addr,
    input  wire logic [8*NUM_RAMS-1:0]                          i_in_valid,
    // Address interface for output stream
    input  wire logic [$clog2(DEPTH)-1:0]                       i_out_addr,
    input  wire logic                                           i_out_addr_valid,
    output      logic                                           o_out_addr_ready,
    // Data interface for output stream
    output      logic [WIDTH-1:0]                               o_out_data,
    output      logic                                           o_out_valid,
    input  wire logic                                           i_out_ready,
    input  wire logic                                           i_clock,
    input  wire logic                                           i_reset
);

genvar ram_num;
genvar branch_num;

generate

if (NUM_RAMS == 24) begin
    integer number_of_branches [NUM_RAMS-1:0] = '{
        3, 3, 6, 3, 3, 6, 3, 6, 3, 6, 3, 6,
        3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
    };
end else if (NUM_RAMS == 12) begin
    integer number_of_branches [NUM_RAMS-1:0] = '{
        6, 7, 7, 6, 6, 7, 6, 6, 7, 6, 6, 6
    };
end



for (ram_num = 0; ram_num < NUM_RAMS; ram_num++) begin
    for (branch_num = 0; branch_num < number_of_branches[ram_num]; branch_num++) begin
        ldpc_ram #(
            .WIDTH(WIDTH),
            .DEPTH(EXPANSION_FACTOR),
            .resource(resource))
        ldpc_ram_inst (
            .i_in_data       (i_in_data[(branch_num*NUM_RAMS + ram_num + 1)*WIDTH-1:(branch_num*NUM_RAMS + ram_num)*WIDTH]                                      ),
            .i_in_addr       (i_in_addr[(branch_num*NUM_RAMS + ram_num + 1)*$clog2(EXPANSION_FACTOR)-1:(branch_num*NUM_RAMS + ram_num)*$clog2(EXPANSION_FACTOR)]),
            .i_in_valid      (i_in_valid[branch_num*NUM_RAMS + ram_num]                                                                                         ),
            .i_out_addr      (address_count                                                                                                                     ),
            .i_out_addr_valid(address_count_valid[branch_num*NUM_RAMS + ram_num]                                                                                ),
            .o_out_addr_ready(address_count_ready[branch_num*NUM_RAMS + ram_num]                                                                                ),
            .o_out_data      (                                                                                                                                  ),
            .o_out_valid     (                                                                                                                                  ),
            .i_out_ready     (                                                                                                                                  ),
            .i_clock         (i_clock                                                                                                                           ),
            .i_reset         (i_reset                                                                                                                           ));
    end
end

endgenerate

endmodule: ldpc_super_ram

`default_nettype wire
