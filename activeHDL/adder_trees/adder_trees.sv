`timescale 10ps / 10ps

`default_nettype none

module adder_trees #(
    parameter integer WIDTH = 8,
    parameter integer NUM_WORDS = 1024
) (
    input  wire logic [15:0] i_data_a0,
    input  wire logic [15:0] i_data_a1,
    input  wire logic [15:0] i_data_a2,
    input  wire logic [15:0] i_data_a3,
    input  wire logic [15:0] i_data_a4,
    output wire logic [15:0] o_result3,
    output wire logic [15:0] o_result5,
    input  wire logic        i_clock,
    input  wire logic        i_reset
);

logic i_enable;
assign i_enable = 1'b1;

adder_tree3 adder_tree3_inst(.o_result(o_result3), .*);

adder_tree5 adder_tree5_inst(.o_result(o_result5),.*);

endmodule: adder_trees

`default_nettype wire
