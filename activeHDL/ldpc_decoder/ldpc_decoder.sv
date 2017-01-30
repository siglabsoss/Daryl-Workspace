`timescale 10ps / 10ps

`default_nettype none

module ldpc_decoder #(
    parameter integer IN_WIDTH = 8,
    parameter integer OUT_WIDTH = 8,
    parameter integer NUM_WORDS = 1024
) (
    input  wire logic [7:0] i_in_data,
    input  wire logic       i_in_valid,
    output      logic       o_in_ready,
    output      logic [7:0] o_out_data,
    output      logic       o_out_valid,
    input  wire logic       i_out_ready,
    input  wire logic       i_clock,
    input  wire logic       i_reset
);

localparam integer CODEWORD_LENGTH = 2304;

logic [7:0]                         llr_input_data;
logic [$clog2(CODEWORD_LENGTH):0]   llr_input_addr;
logic [$clog2(CODEWORD_LENGTH)-1:0] llr_input_count;
logic [1:0]                         llr_input_head;
logic [1:0]                         llr_input_tail;
logic                               llr_input_valid;
always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        llr_input_count <= 0;
        llr_input_head <= 0;
    end else begin
        if (i_in_valid & o_in_ready) begin
            if (llr_input_count == CODEWORD_LENGTH-1) begin
                llr_input_head <= llr_input_head + 1;
                llr_input_count <= 0;
            end else begin
                llr_input_count <= llr_input_count + 1;
            end
        end
    end
end

// Data can come in if the buffer (LSBs) are not equal
logic eq_msb, neq_lsb;
assign eq_msb = llr_input_head[1] == llr_input_tail[1];
assign neq_lsb = llr_input_head[0] != llr_input_tail[0];
assign o_in_ready = eq_msb | neq_lsb;

always_comb begin
    llr_input_addr = { llr_input_head[0], llr_input_count };
    llr_input_valid = i_in_valid & (eq_msb | neq_lsb);
end

ldpc_ram #(
    .WIDTH(                8),
    .DEPTH(2*CODEWORD_LENGTH))
llr_ram_inst (
    .i_in_data       (llr_input_data  ),
    .i_in_addr       (llr_input_addr  ),
    .i_in_valid      (llr_input_valid ),
    .i_out_addr      (                ),
    .i_out_addr_valid(                ),
    .o_out_addr_ready(                ),
    .o_out_data      (                ),
    .o_out_valid     (                ),
    .i_out_ready     (                ),
    .i_clock         (i_clock         ),
    .i_reset         (i_reset         ));

endmodule: ldpc_decoder

`default_nettype wire
