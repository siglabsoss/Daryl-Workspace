`timescale 10 ps / 10 ps

`default_nettype none

module ldpc_column_to_row (
	input  wire logic [7:0] i_data_0,
	input  wire logic [7:0] i_data_1,
	input  wire logic [7:0] i_data_2,
	input  wire logic [7:0] i_data_3,
	input  wire logic [7:0] i_data_4,
	input  wire logic [7:0] i_data_5,
	input  wire logic       i_valid,
	output      logic [7:0] o_data_0,
	output      logic [7:0] o_data_1,
	output      logic [7:0] o_data_2,
	output      logic [7:0] o_data_3,
	output      logic [7:0] o_data_4,
	output      logic [7:0] o_data_5,
	output      logic [7:0] o_data_6,
	output      logic       o_valid,
	input  wire logic       i_clock,
	input  wire logic       i_reset
);



endmodule: ldpc_column_to_row

`default_nettype wire
