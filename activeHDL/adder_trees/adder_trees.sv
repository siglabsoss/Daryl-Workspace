`timescale 10ps / 10ps

`default_nettype none

module adder_trees (
    input  wire logic [15:0] i_data_a0,
    input  wire logic [15:0] i_data_a1,
    input  wire logic [15:0] i_data_a2,
    input  wire logic [15:0] i_data_a3,
    input  wire logic [15:0] i_data_a4,
    input  wire logic [15:0] i_data_a5,
    output wire logic [15:0] o_data_a0,
    output wire logic [15:0] o_data_a1,
    output wire logic [15:0] o_data_a2,
    output wire logic [15:0] o_data_a3,
    output wire logic [15:0] o_data_a4,
    output wire logic [15:0] o_data_a5,
    input  wire logic        i_clock,
    input  wire logic        i_reset
);

logic i_enable;
assign i_enable = 1'b1;

adder_tree5 adder_tree5_0_inst(.i_data_a0(i_data_a5), .o_result(o_data_a0), .*);
adder_tree5 adder_tree5_1_inst(.i_data_a1(i_data_a5), .o_result(o_data_a1), .*);
adder_tree5 adder_tree5_2_inst(.i_data_a2(i_data_a5), .o_result(o_data_a2), .*);
adder_tree5 adder_tree5_3_inst(.i_data_a3(i_data_a5), .o_result(o_data_a3), .*);
adder_tree5 adder_tree5_4_inst(.i_data_a4(i_data_a5), .o_result(o_data_a4), .*);
adder_tree5 adder_tree5_5_inst(.o_result(o_data_a5), .*);

endmodule: adder_trees

`default_nettype wire
