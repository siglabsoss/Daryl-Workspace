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

module ldpc_concatenator #(
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

logic [WIDTH1-1:0] first_data;
logic              first_valid;
logic              first_ready;

ldpc_concatenator_ebr_fifo #(
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

logic [WIDTH2-1:0] second_data;
logic              second_valid;
logic              second_ready;

ldpc_concatenator_ebr_fifo #(
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

logic [WIDTH3-1:0] third_data;
logic              third_valid;
logic              third_ready;

ldpc_concatenator_ebr_fifo #(
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
    ST_FIRST,
    ST_SECOND,
    ST_SECOND_FOLLOWUP,
    ST_THIRD,
    ST_THIRD_FOLLOWUP
} curr_state, next_state;

logic [WIDTH1-1:0] word_data;
logic              word_valid;
logic              word_ready;

localparam integer SWIDTH = (WIDTH2 > WIDTH3) ? WIDTH2 : WIDTH3;
logic [SWIDTH-1:0] word_data_storage;
logic [SWIDTH-1:0] next_word_data_storage;

always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        curr_state        <= ST_INIT;
        word_count        <= 0;
        word_data_storage <= 0;
        count2            <= 0;
        count3            <= 0;
    end else begin
        curr_state        <= next_state;
        word_count        <= next_word_count;
        word_data_storage <= next_word_data_storage;
        count2            <= next_count2;
        count3            <= next_count3;
    end
end

logic inc_count2, inc_count3, dec_word_count;
logic dec_word_count1, dec_word_count2, dec_word_count3;
logic word_count_is_zero, count2_is_max2, count3_is_max3;

assign inc_count2 = (count2 == MAX2-1) ? 0 : count2 + 1;
assign inc_count3 = (count3 == MAX3-1) ? 0 : count3 + 1;
assign dec_word_count = word_count - 1;
assign dec_word_count1 = (dec_word_count == 0) ? LENGTH2-1 : dec_word_count;
assign dec_word_count2 = (dec_word_count == 0) ? LENGTH3-1 : dec_word_count;
assign dec_word_count3 = (dec_word_count == 0) ? LENGTH1-1 : dec_word_count;
assign word_count_is_zero = (word_count == 0);
assign count2_is_max2 = count2 == MAX2-1;
assign count3_is_max3 = count3 == MAX3-1;

always_comb begin
    case (curr_state)
    ST_FIRST: begin
        // Reset counters/state regs for stages 2 and 3
        next_count2 = 0;
        next_count3 = 0;
        next_word_data_storage = 0;
        // Count down until correct number of words transferred
        next_word_count = (first_valid & word_ready) ? dec_word_count1 : word_count;
        // Handshaking with downstream blocks
        word_valid = first_valid;
        word_data = first_data;
        // Handshaking with upstream blocks
        first_ready = word_ready;
        second_ready = 1'b0;
        third_ready = 1'b0;
        // State transition
        next_state = (word_count_is_zero & first_valid & word_ready) ? ST_SECOND : ST_FIRST;
    end
    ST_SECOND: begin
        // Reset counters/state regs for stages 2 and 3
        next_count2 = (second_valid & word_ready) ? inc_count2 : count2;
        next_count3 = 0;
        next_word_data_storage = {
            {SWIDTH-(WIDTH2-WIDTH1){1'b0}},
            second_data[WIDTH2-1:WIDTH1]
        };
        // Count down until correct number of words transferred
        next_word_count = (second_valid & word_ready) ? dec_word_count2 : word_count;
        // Handshaking with downstream blocks
        word_valid = second_valid;
        word_data = second_data[WIDTH1-1:0];
        // Handshaking with upstream blocks
        first_ready = 1'b0;
        second_ready = word_ready;
        third_ready = 1'b0;
        // State transition
        next_state = (second_valid & word_ready) ? ST_SECOND_FOLLOWUP : ST_SECOND;
    end
    ST_SECOND_FOLLOWUP: begin
        // Reset counters/state regs for stages 2 and 3
        next_count2 = word_ready ? inc_count2 : count2;
        next_count3 = 0;
        next_word_data_storage = {
            {WIDTH1{1'b0}},
            word_data_storage[SWIDTH-1:WIDTH1]
        };
        // Count down until correct number of words transferred
        next_word_count = word_ready ? dec_word_count2 : word_count;
        // Handshaking with downstream blocks
        word_valid = 1'b1;
        word_data = word_data_storage[WIDTH1-1:0];
        // Handshaking with upstream blocks
        first_ready = 1'b0;
        second_ready = 1'b0;
        third_ready = 1'b0;
        // State transition
        case ({word_count_is_zero, count2_is_max2, word_ready})
        3'b111: next_state = ST_THIRD;
        3'b011: next_state = ST_SECOND;
        default: next_state = ST_SECOND_FOLLOWUP;
        endcase
    end
    ST_THIRD: begin
        // Reset counters/state regs for stages 2 and 3
        next_count2 = 0;
        next_count3 = (third_valid & word_ready) ? inc_count3 : next_count3;
        next_word_data_storage = {
            {SWIDTH-(WIDTH3-WIDTH1){1'b0}},
            third_data[WIDTH3-1:WIDTH1]
        };
        // Count down until correct number of words transferred
        next_word_count = (third_valid & word_ready) ? dec_word_count3 : word_count;
        // Handshaking with downstream blocks
        word_valid = third_valid;
        word_data = third_data[WIDTH1-1:0];
        // Handshaking with upstream blocks
        first_ready = 1'b0;
        second_ready = 1'b0;
        third_ready = word_ready;
        // State transition
        next_state = (third_valid & word_ready) ? ST_THIRD_FOLLOWUP : ST_THIRD;
    end
    ST_THIRD_FOLLOWUP: begin
        // Reset counters/state regs for stages 2 and 3
        next_count2 = 0;
        next_count3 = word_ready ? inc_count3 : count3;
        next_word_data_storage = {
            {WIDTH1{1'b0}},
            word_data_storage[SWIDTH-1:WIDTH1]
        };
        // Count down until correct number of words transferred
        next_word_count = word_ready ? dec_word_count3 : word_count;
        // Handshaking with downstream blocks
        word_valid = 1'b1;
        word_data = word_data_storage[WIDTH1-1:0];
        // Handshaking with upstream blocks
        first_ready = 1'b0;
        second_ready = 1'b0;
        third_ready = 1'b0;
        // State transition
        case ({word_count_is_zero, count3_is_max3, word_ready})
        3'b111: next_state = ST_FIRST;
        3'b011: next_state = ST_THIRD;
        default: next_state = ST_THIRD_FOLLOWUP;
        endcase
    end
    default: begin // ST_INIT
        next_state = ST_INIT;
        next_count2 = 0;
        next_count3 = 0;
        word_valid = 1'b0;
        word_data = 0;
        next_word_count = LENGTH1-1;
        next_state = ST_FIRST;
        first_ready = 1'b0;
        second_ready = 1'b0;
        third_ready = 1'b0;
    end
    endcase
end

ldpc_concatenator_ebr_fifo #(
    .WIDTH(WIDTH1  ),
    .DEPTH(2*DEPTH1))
concatenator_ebr_fifo_4_inst (
    .i_in_data  (word_data  ),
    .i_in_valid (word_valid ),
    .o_in_ready (word_ready ),
    .o_out_data (o_out_data ),
    .o_out_valid(o_out_valid),
    .i_out_ready(i_out_ready),
    .i_clock    (i_clock    ),
    .i_reset    (i_reset    ));

endmodule: ldpc_concatenator

`default_nettype wire
