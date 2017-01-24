`timescale 10ps / 10ps

`default_nettype none

module ebr_ram #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 1024
) (
    // Address + Data interface for input stream
    input  wire logic [WIDTH-1:0]         i_in_data,
    input  wire logic [$clog2(DEPTH)-1:0] i_in_addr,
    input  wire logic                     i_in_valid,
    // Address interface for output stream
    input  wire logic [$clog2(DEPTH)-1:0] i_out_addr,
    input  wire logic                     i_out_addr_valid,
    output      logic                     o_out_addr_ready,
    // Data interface for output stream
    output      logic [WIDTH-1:0]         o_out_data,
    output      logic                     o_out_valid,
    input  wire logic                     i_out_ready,
    input  wire logic                     i_clock,
    input  wire logic                     i_reset
);

logic [WIDTH-1:0] buffer [0:DEPTH-1] /* synthesis syn_ramstyle="block_ram" */;

// Read into buffer
always_ff @(posedge i_clock) begin
    if (i_in_valid == 1'b1) begin
        buffer[i_in_addr] <= i_in_data;
    end
end

// Unregistered read out from buffer
logic [WIDTH-1:0] out_data_reg;
logic [WIDTH-1:0] out_data_reg_valid;
always_ff @(posedge i_clock) begin
    if (i_out_addr_valid == 1'b1) begin
        out_data_reg <= buffer[i_out_addr];
    end
    out_data_reg_valid <= i_out_addr_valid & o_out_addr_ready;
end

localparam integer MAX_SKID = 4;
logic [$clog2(MAX_SKID)-1:0] skid_count;
logic [MAX_SKID*WIDTH-1:0]   skid_data;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        o_out_addr_ready = 1'b1;
        skid_count = 0;
    end else begin
        case ({ i_out_addr_valid, o_out_addr_ready, o_out_valid, i_out_ready })
        4'b1100: begin
            // If we are almost full
            if (skid_count == MAX_SKID - 2) begin
                o_out_addr_ready <= 1'b0;
            end else begin
                o_out_addr_ready <= 1'b1;
            end
            // Increment skid count
            skid_count <= skid_count + 1;
        end
        4'b0011: begin
            o_out_addr_ready <= 1'b1;
            // Decrement skid count
            skid_count <= skid_count - 1;
        end
        default: begin
            if (skid_count == MAX_SKID - 1) begin
                o_out_addr_ready <= 1'b0;
            end else begin
                o_out_addr_ready <= 1'b1;
            end
        end
        endcase
    end
end

ebr_ram_skid ebr_ram_skid_inst


endmodule: ebr_ram

`default_nettype wire
