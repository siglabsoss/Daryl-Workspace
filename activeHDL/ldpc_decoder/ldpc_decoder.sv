`timescale 10ps / 10ps

`default_nettype none

module ldpc_decoder #(
    parameter integer IN_WIDTH = 16,
    parameter integer OUT_WIDTH = 8,
    parameter integer NUM_WORDS = 1024
) (
    input  wire logic [IN_WIDTH-1:0]  i_in_data,
    input  wire logic                 i_in_valid,
    output      logic                 o_in_ready,
    output      logic [OUT_WIDTH-1:0] o_out_data,
    output      logic                 o_out_valid,
    input  wire logic                 i_out_ready,
    input  wire logic                 i_clock,
    input  wire logic                 i_reset
);

localparam integer CODEWORD_LENGTH = 2304;



endmodule: ldpc_decoder

`default_nettype wire
