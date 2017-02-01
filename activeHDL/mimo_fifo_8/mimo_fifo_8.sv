`timescale 10ps / 10ps

`default_nettype none

module miso_fifo_8 #(
    parameter integer WIDTH = 16,
    parameter integer DEPTH = 512
) (
    input  wire logic [WIDTH-1:0] i_data_0,
    input  wire logic [WIDTH-1:0] i_data_1,
    input  wire logic [WIDTH-1:0] i_data_2,
    input  wire logic [WIDTH-1:0] i_data_3,
    input  wire logic [WIDTH-1:0] i_data_4,
    input  wire logic [WIDTH-1:0] i_data_5,
    input  wire logic [WIDTH-1:0] i_data_6,
    input  wire logic [WIDTH-1:0] i_data_7,
    input  wire logic [2:0]       to_branch_0,
    input  wire logic [2:0]       to_branch_1,
    input  wire logic [2:0]       to_branch_2,
    input  wire logic [2:0]       to_branch_3,
    input  wire logic [2:0]       to_branch_4,
    input  wire logic [2:0]       to_branch_5,
    input  wire logic [2:0]       to_branch_6,
    input  wire logic [2:0]       to_branch_7,
    input  wire logic             i_valid,
    output wire logic             o_ready,
    output      logic             o_data_0,
    output      logic             o_data_1,
    output      logic             o_data_2,
    output      logic             o_data_3,
    output      logic             o_data_4,
    output      logic             o_data_5,
    output      logic             o_data_6,
    output      logic             o_data_7,
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

logic ready_0, ready_1, ready_2, ready_3;
logic ready_4, ready_5, ready_6, ready_7;

assign o_ready = ready_0 & ready_1 & ready_2 & ready_3 & ready_4 & ready_5 & ready_6 & ready_7;

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
fifo_0_inst (
    .i_in_data  (i_data_0      ),
    .i_in_valid (i_valid       ),
    .o_in_ready (ready_0       ),
    .o_out_data (stream_0      ),
    .o_out_valid(stream_valid_0),
    .i_out_ready(stream_ready_0),
    .i_clock    (i_clock       ),
    .i_reset    (i_reset       ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
fifo_0_inst (
    .i_in_data  (i_data_1      ),
    .i_in_valid (i_valid       ),
    .o_in_ready (ready_1       ),
    .o_out_data (stream_1      ),
    .o_out_valid(stream_valid_1),
    .i_out_ready(stream_ready_1),
    .i_clock    (i_clock       ),
    .i_reset    (i_reset       ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
fifo_0_inst (
    .i_in_data  (i_data_2      ),
    .i_in_valid (i_valid       ),
    .o_in_ready (ready_2       ),
    .o_out_data (stream_2      ),
    .o_out_valid(stream_valid_2),
    .i_out_ready(stream_ready_2),
    .i_clock    (i_clock       ),
    .i_reset    (i_reset       ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
fifo_0_inst (
    .i_in_data  (i_data_3      ),
    .i_in_valid (i_valid       ),
    .o_in_ready (ready_3       ),
    .o_out_data (stream_3      ),
    .o_out_valid(stream_valid_3),
    .i_out_ready(stream_ready_3),
    .i_clock    (i_clock       ),
    .i_reset    (i_reset       ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
fifo_0_inst (
    .i_in_data  (i_data_4      ),
    .i_in_valid (i_valid       ),
    .o_in_ready (ready_4       ),
    .o_out_data (stream_4      ),
    .o_out_valid(stream_valid_4),
    .i_out_ready(stream_ready_4),
    .i_clock    (i_clock       ),
    .i_reset    (i_reset       ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
fifo_0_inst (
    .i_in_data  (i_data_5      ),
    .i_in_valid (i_valid       ),
    .o_in_ready (ready_5       ),
    .o_out_data (stream_5      ),
    .o_out_valid(stream_valid_5),
    .i_out_ready(stream_ready_5),
    .i_clock    (i_clock       ),
    .i_reset    (i_reset       ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
fifo_0_inst (
    .i_in_data  (i_data_6      ),
    .i_in_valid (i_valid       ),
    .o_in_ready (ready_6       ),
    .o_out_data (stream_6      ),
    .o_out_valid(stream_valid_6),
    .i_out_ready(stream_ready_6),
    .i_clock    (i_clock       ),
    .i_reset    (i_reset       ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
fifo_0_inst (
    .i_in_data  (i_data_7      ),
    .i_in_valid (i_valid       ),
    .o_in_ready (ready_7       ),
    .o_out_data (stream_7      ),
    .o_out_valid(stream_valid_7),
    .i_out_ready(stream_ready_7),
    .i_clock    (i_clock       ),
    .i_reset    (i_reset       ));



endmodule: miso_fifo_8