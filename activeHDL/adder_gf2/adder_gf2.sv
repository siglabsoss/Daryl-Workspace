`timescale 1ps/1ps

`default_nettype none

module adder_gf2 #(
    parameter integer WIDTH = 8
) (
    input  wire logic [WIDTH-1:0] i_lhs_data,
    input  wire logic             i_lhs_valid,
    output      logic             o_lhs_ready,
    input  wire logic [WIDTH-1:0] i_rhs_data,
    input  wire logic             i_rhs_valid,
    output      logic             o_rhs_ready,
    output      logic [WIDTH-1:0] o_sum_data,
    output      logic             o_sum_valid,
    input  wire logic             i_sum_ready,
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

adder_gf2_skid #(
    .WIDTH(WIDTH))
adder_gf2_skid_lhs_inst (
    .i_clock    (i_clock    ),
    .i_reset    (i_reset    ),
    .i_in_data  (i_lhs_data ),
    .i_in_valid (i_lhs_valid),
    .o_in_ready (o_lhs_ready),
    .o_out_data (lhs_data   ),
    .o_out_valid(lhs_valid  ),
    .i_out_ready(lhs_ready  ));

adder_gf2_skid #(
    .WIDTH(WIDTH))
adder_gf2_skid_rhs_inst (
    .i_clock    (i_clock    ),
    .i_reset    (i_reset    ),
    .i_in_data  (i_rhs_data ),
    .i_in_valid (i_rhs_valid),
    .o_in_ready (o_rhs_ready),
    .o_out_data (rhs_data   ),
    .o_out_valid(rhs_valid  ),
    .i_out_ready(rhs_ready  ));

logic [WIDTH-1:0] sum_data;
logic             sum_valid;
logic             sum_ready;

assign sum_data = lhs_data ^ rhs_data;
assign sum_valid = lhs_valid & rhs_valid;
assign rhs_ready = lhs_valid & sum_ready;
assign lhs_ready = rhs_valid & sum_ready;

adder_gf2_skid #(
    .WIDTH(WIDTH))
adder_gf2_skid_sum_inst (
    .i_clock    (i_clock    ),
    .i_reset    (i_reset    ),
    .i_in_data  (sum_data   ),
    .i_in_valid (sum_valid  ),
    .o_in_ready (sum_ready  ),
    .o_out_data (o_sum_data ),
    .o_out_valid(o_sum_valid),
    .i_out_ready(i_sum_ready));

endmodule: adder_gf2

`default_nettype wire
