// concatenator.sv
//
// WIDTHs and DEPTHs are optimized for 18 Kbit EBR

`timescale 10ps / 10ps

`default_nettype none

module concatenator #(
    parameter integer OUT_WIDTH = 8,
    parameter integer WIDTH1 = 8,
    parameter integer WIDTH2 = 96,
    parameter integer WIDTH3 = 96,
    parameter integer DEPTH1 = 2048,
    parameter integer DEPTH2 = 192,
    parameter integer DEPTH3 = 192
) (
    input  wire logic [WIDTH1-1:0]    i_first_data,
    input  wire logic                 i_first_valid,
    output      logic                 o_first_ready,
    input  wire logic [WIDTH2-1:0]    i_second_data,
    input  wire logic                 i_second_valid,
    output      logic                 o_second_ready,
    input  wire logic [WIDTH3-1:0]    i_third_data,
    input  wire logic                 i_third_valid,
    output      logic                 o_third_ready,
    output      logic [OUT_WIDTH-1:0] o_out_data,
    output      logic                 o_out_valid,
    input  wire logic                 i_out_ready,
    input  wire logic                 i_clock,
    input  wire logic                 i_reset
);

logic [WIDTH1:0] first_data;
logic            first_valid;
logic            first_ready;

concatenator_ebr_fifo #(
    .WIDTH(WIDTH1),
    .DEPTH(DEPTH1))
concatenator_ebr_fifo_1_inst (
    .i_in_data  (i_first_data ),
    .i_in_valid (i_first_valid),
    .o_in_ready (o_first_ready),
    .o_out_data (first_data   ),
    .o_out_valid(first_valid  ),
    .i_out_ready(first_ready  ),
    .i_clock    (i_clock      ),
    .i_reset    (i_reset      ));

logic [WIDTH1:0] second_data;
logic            second_valid;
logic            second_ready;

concatenator_ebr_fifo #(
    .WIDTH(WIDTH2),
    .DEPTH(DEPTH2))
concatenator_ebr_fifo_2_inst (
    .i_in_data  (i_second_data ),
    .i_in_valid (i_second_valid),
    .o_in_ready (o_second_ready),
    .o_out_data (second_data   ),
    .o_out_valid(second_valid  ),
    .i_out_ready(second_ready  ),
    .i_clock    (i_clock       ),
    .i_reset    (i_reset       ));

logic [WIDTH1:0] third_data;
logic            third_valid;
logic            third_ready;

concatenator_ebr_fifo #(
    .WIDTH(WIDTH3),
    .DEPTH(DEPTH3))
concatenator_ebr_fifo_3_inst (
    .i_in_data  (i_third_data  ),
    .i_in_valid (i_third_valid ),
    .o_in_ready (o_third_ready ),
    .o_out_data (third_data    ),
    .o_out_valid(third_valid   ),
    .i_out_ready(third_ready   ),
    .i_clock    (i_clock       ),
    .i_reset    (i_reset       ));

enum {
    ST_INIT,
    ST_FIRST,
    ST_SECOND,
    ST_THIRD,
} curr_state, next_state;

always_ff @(posedge i_clock) begin
    if(i_reset == 1'b1) begin
        curr_state <= ST_INIT;
    end else begin
        curr_state <= next_state;
    end
end



endmodule: concatenator

`default_nettype wire
