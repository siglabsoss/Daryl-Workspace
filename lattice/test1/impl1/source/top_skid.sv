`timescale 10ps / 10ps

`default_nettype none

module top_skid #(
    parameter integer WIDTH = 16
) (
    input wire logic                i_clock,
    input wire logic                i_reset,
    // Upstream signaling
    input wire logic [WIDTH-1:0]    i_in_data,
    input wire logic                i_in_valid,
    output     logic                o_in_ready,
    // Downstream signaling
    output     logic [WIDTH-1:0]    o_out_data,
    output     logic                o_out_valid,
    input wire logic                i_out_ready);

logic [WIDTH-1:0] mid_data;
logic             mid_valid;
logic             mid_ready;

skid skid_0_inst (
	.i_clock    (i_clock   ),
	.i_reset    (i_reset   ),
	.i_in_data  (i_in_data ),
	.i_in_valid (i_in_valid),
    .o_in_ready (o_in_ready),
    .o_out_data (mid_data  ),
    .o_out_valid(mid_valid ),
    .i_out_ready(mid_ready ));

skid skid_1_inst (
    .i_clock    (i_clock    ),
    .i_reset    (i_reset    ),
    .i_in_data  (mid_data   ),
    .i_in_valid (mid_valid  ),
    .o_in_ready (mid_ready  ),
    .o_out_data (o_out_data ),
    .o_out_valid(o_out_valid),
    .i_out_ready(i_out_ready));

endmodule: top_skid

`default_nettype wire
