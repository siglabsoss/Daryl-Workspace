// concatenator.sv
//
// WIDTHs and DEPTHs are optimized for 18 Kbit EBR
//
// Note: WIDTH1 is the input width for channel 1
// and the output width. WIDTH2 and WIDTH3 must be
// greater than WIDTH1 for correct functionality.
// Furthermore, WIDTH1 should evenly divide WIDTH2
// and WIDTH3.

`timescale 10ps / 10ps

`default_nettype none

module concatenator #(
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
    output      logic [WIDTH1-1:0]    o_out_data,
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

// The length of each sequence to be concatenated
localparam LENGTH1 = 144; // bytes
localparam LENGTH2 = 12;   // bytes
localparam LENGTH3 = 132;  // bytes

// Counter to track which byte in the sequence is active
logic [$clog2(LENGTH1)-1:0] word_count;
logic [$clog2(LENGTH1)] next_word_count;

// The number of sub words in each super word
localparam MAX2 = WIDTH2 / WIDTH1;
localparam MAX3 = WIDTH3 / WIDTH1;

// Counters to track which sub word is active
logic [$clog2(MAX2)-1:0] count2;
logic [$clog2(MAX3)-1:0] count3;
logic [$clog2(MAX2)-1:0] next_count2;
logic [$clog2(MAX3)-1:0] next_count3;

enum {
    ST_INIT,
    ST_WAIT_FOR_FIRST,
    ST_FIRST,
    ST_WAIT_FOR_SECOND,
    ST_SECOND,
    ST_WAIT_FOR_THIRD,
    ST_THIRD,
} curr_state, next_state;

logic [WIDTH1:0] word_data;
logic            word_valid;
logic            word_ready;

logic [WIDTH1:0] next_word_data;
logic            next_word_valid;

always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        curr_state <= ST_INIT;
        word_count <= 0;
        count2 <= 0;
        count3 <= 0;
        word_data  <= 0;
        word_valid <= 1'b0;
    end else begin
        curr_state <= next_state;
        word_count <= next_word_count;
        count2 <= next_count2;
        count3 <= next_count3;
        word_data  <= next_word_data;
        word_valid <= next_word_valid;
    end
end

always_comb begin
    case (curr_state)
    ST_WAIT_FOR_FIRST: begin
        next_count2 = 0;
        next_count3 = 0;
        word_valid = 1'b0;
        word_data = 0;
        next_word_count = LENGTH1-1;
        next_state = ;
    end
    ST_FIRST: begin
        next_count2 = 0;
        next_count3 = 0;
        //word_valid = 1'b0;
        //word_data = 0;
        //next_word_count = word_ready ? word_count - 1 : word_count;
        next_state = ;
    end
    ST_WAIT_FOR_SECOND: begin
        next_count2 = 0;
        next_count3 = 0;
        word_valid = 1'b0;
        word_data = 0;
        next_word_count = LENGTH2-1;
        next_state = ;
    end
    ST_SECOND: begin
        next_count2 = 0;
        next_count3 = 0;
        //word_valid = 1'b0;
        //word_data = 0;
        //next_word_count = word_ready ? word_count - 1 : word_count;
        next_state = ;
    end
    ST_WAIT_FOR_THIRD: begin
        next_count2 = 0;
        next_count3 = 0;
        word_valid = 1'b0;
        word_data = 0;
        next_word_count = LENGTH3-1;
        next_state = ;
    end
    ST_THIRD: begin
        next_count2 = 0;
        next_count3 = 0;
        //word_valid = 1'b0;
        //word_data = 0;
        //next_word_count = word_ready ? word_count - 1 : word_count;
        next_state = ;
    end
    default: begin // ST_INIT
        next_state = ST_INIT;
        next_count2 = 0;
        next_count3 = 0;
        word_valid = 1'b0;
        word_data = 0;
        next_word_count = 0;
        next_state = ST_WAIT_FOR_FIRST;
    end
    endcase
end

concatenator_skid #(
    .WIDTH(WIDTH1))
concatenator_skid_inst (
    .i_clock    (i_clock    ),
    .i_reset    (i_reset    ),
    .i_in_data  (word_data  ),
    .i_in_valid (word_valid ),
    .o_in_ready (word_ready ),
    .o_out_data (o_out_data ),
    .o_out_valid(o_out_valid),
    .i_out_ready(i_out_ready));

endmodule: concatenator

`default_nettype wire
