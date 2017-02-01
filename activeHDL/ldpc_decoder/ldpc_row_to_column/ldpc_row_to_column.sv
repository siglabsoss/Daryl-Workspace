`timescale 10 ps / 10 ps

`default_nettype none

module ldpc_row_to_column (
	input  wire logic [7:0] i_data_0,
	input  wire logic [7:0] i_data_1,
	input  wire logic [7:0] i_data_2,
	input  wire logic [7:0] i_data_3,
	input  wire logic [7:0] i_data_4,
	input  wire logic [7:0] i_data_5,
	input  wire logic [7:0] i_data_6,
	input  wire logic       i_valid,
	output      logic [7:0] o_data_0,
	output      logic [7:0] o_data_1,
	output      logic [7:0] o_data_2,
	output      logic [7:0] o_data_3,
	output      logic [7:0] o_data_4,
	output      logic [7:0] o_data_5,
	output      logic       o_valid,
	input  wire logic       i_clock,
	input  wire logic       i_reset
);



endmodule: ldpc_row_to_column

`default_nettype wire
