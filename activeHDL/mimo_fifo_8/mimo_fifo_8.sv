// mimo_fifo_8.sv
//
// Multi-input fifo for buffering simultaneous computations
// that need to go to the same memory. Note, he memory part
// is assumed to always be able to accept data, that is why
// there is no ready signal for the outputs (it is assumed
// active high all the time).

`timescale 10ps / 10ps

`default_nettype none

module mimo_fifo_8 #(
    parameter integer WIDTH = 32,
    parameter integer DEPTH = 1024
) (
    input  wire logic [WIDTH-1:0] i_data_0,
    input  wire logic [WIDTH-1:0] i_data_1,
    input  wire logic [WIDTH-1:0] i_data_2,
    input  wire logic [WIDTH-1:0] i_data_3,
    input  wire logic [WIDTH-1:0] i_data_4,
    input  wire logic [WIDTH-1:0] i_data_5,
    input  wire logic [WIDTH-1:0] i_data_6,
    input  wire logic [WIDTH-1:0] i_data_7,
    input  wire logic [2:0]       i_to_branch_0,
    input  wire logic [2:0]       i_to_branch_1,
    input  wire logic [2:0]       i_to_branch_2,
    input  wire logic [2:0]       i_to_branch_3,
    input  wire logic [2:0]       i_to_branch_4,
    input  wire logic [2:0]       i_to_branch_5,
    input  wire logic [2:0]       i_to_branch_6,
    input  wire logic [2:0]       i_to_branch_7,
    input  wire logic             i_valid,
    output wire logic             o_ready,
    output      logic [WIDTH-1:0] o_data_0,
    output      logic             o_valid_0,
    output      logic [WIDTH-1:0] o_data_1,
    output      logic             o_valid_1,
    output      logic [WIDTH-1:0] o_data_2,
    output      logic             o_valid_2,
    output      logic [WIDTH-1:0] o_data_3,
    output      logic             o_valid_3,
    output      logic [WIDTH-1:0] o_data_4,
    output      logic             o_valid_4,
    output      logic [WIDTH-1:0] o_data_5,
    output      logic             o_valid_5,
    output      logic [WIDTH-1:0] o_data_6,
    output      logic             o_valid_6,
    output      logic [WIDTH-1:0] o_data_7,
    output      logic             o_valid_7,
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

localparam integer NUM_INPUTS = 8;
localparam integer NUM_OUTPUTS = 8;

logic ready_0, ready_1, ready_2, ready_3;
logic ready_4, ready_5, ready_6, ready_7;

// May need to figure out a better way to handle this
// eventually, each ready is a combinatorial output of
// 2 signals, so this is a 16-input LUT which is going
// to limit timing... Could use skid buffering here to
// break things up. In reality this is a function of
// 16 input bits (each ready is a function of 2 bits).
assign o_ready = ready_0 & ready_1
    & ready_2 & ready_3 & ready_4
    & ready_5 & ready_6 & ready_7;

logic [WIDTH+3-1:0] stream_data_0;
logic               stream_valid_0;
logic               stream_ready_0;

logic [WIDTH+3-1:0] stream_data_1;
logic               stream_valid_1;
logic               stream_ready_1;

logic [WIDTH+3-1:0] stream_data_2;
logic               stream_valid_2;
logic               stream_ready_2;

logic [WIDTH+3-1:0] stream_data_3;
logic               stream_valid_3;
logic               stream_ready_3;

logic [WIDTH+3-1:0] stream_data_4;
logic               stream_valid_4;
logic               stream_ready_4;

logic [WIDTH+3-1:0] stream_data_5;
logic               stream_valid_5;
logic               stream_ready_5;

logic [WIDTH+3-1:0] stream_data_6;
logic               stream_valid_6;
logic               stream_ready_6;

logic [WIDTH+3-1:0] stream_data_7;
logic               stream_valid_7;
logic               stream_ready_7;

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
siso_fifo_0_inst (
    .i_in_data  ({i_to_branch_0, i_data_0}),
    .i_in_valid (i_valid                  ),
    .o_in_ready (ready_0                  ),
    .o_out_data (stream_data_0            ),
    .o_out_valid(stream_valid_0           ),
    .i_out_ready(stream_ready_0           ),
    .i_clock    (i_clock                  ),
    .i_reset    (i_reset                  ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
siso_fifo_1_inst (
    .i_in_data  ({i_to_branch_1, i_data_1}),
    .i_in_valid (i_valid                  ),
    .o_in_ready (ready_1                  ),
    .o_out_data (stream_data_1            ),
    .o_out_valid(stream_valid_1           ),
    .i_out_ready(stream_ready_1           ),
    .i_clock    (i_clock                  ),
    .i_reset    (i_reset                  ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
siso_fifo_2_inst (
    .i_in_data  ({i_to_branch_2, i_data_2}),
    .i_in_valid (i_valid                  ),
    .o_in_ready (ready_2                  ),
    .o_out_data (stream_data_2            ),
    .o_out_valid(stream_valid_2           ),
    .i_out_ready(stream_ready_2           ),
    .i_clock    (i_clock                  ),
    .i_reset    (i_reset                  ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
siso_fifo_3_inst (
    .i_in_data  ({i_to_branch_3, i_data_3}),
    .i_in_valid (i_valid                  ),
    .o_in_ready (ready_3                  ),
    .o_out_data (stream_data_3            ),
    .o_out_valid(stream_valid_3           ),
    .i_out_ready(stream_ready_3           ),
    .i_clock    (i_clock                  ),
    .i_reset    (i_reset                  ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
siso_fifo_4_inst (
    .i_in_data  ({i_to_branch_4, i_data_4}),
    .i_in_valid (i_valid                  ),
    .o_in_ready (ready_4                  ),
    .o_out_data (stream_data_4            ),
    .o_out_valid(stream_valid_4           ),
    .i_out_ready(stream_ready_4           ),
    .i_clock    (i_clock                  ),
    .i_reset    (i_reset                  ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
siso_fifo_5_inst (
    .i_in_data  ({i_to_branch_5, i_data_5}),
    .i_in_valid (i_valid                  ),
    .o_in_ready (ready_5                  ),
    .o_out_data (stream_data_5            ),
    .o_out_valid(stream_valid_5           ),
    .i_out_ready(stream_ready_5           ),
    .i_clock    (i_clock                  ),
    .i_reset    (i_reset                  ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
siso_fifo_6_inst (
    .i_in_data  ({i_to_branch_6, i_data_6}),
    .i_in_valid (i_valid                  ),
    .o_in_ready (ready_6                  ),
    .o_out_data (stream_data_6            ),
    .o_out_valid(stream_valid_6           ),
    .i_out_ready(stream_ready_6           ),
    .i_clock    (i_clock                  ),
    .i_reset    (i_reset                  ));

distributed_fifo #(
    .WIDTH(WIDTH+3),
    .DEPTH(DEPTH))
siso_fifo_7_inst (
    .i_in_data  ({i_to_branch_7, i_data_7}),
    .i_in_valid (i_valid                  ),
    .o_in_ready (ready_7                  ),
    .o_out_data (stream_data_7            ),
    .o_out_valid(stream_valid_7           ),
    .i_out_ready(stream_ready_7           ),
    .i_clock    (i_clock                  ),
    .i_reset    (i_reset                  ));

logic [WIDTH-1:0] out_data;
logic [2:0]       out_branch;
logic             out_valid;

// NOTE: May need to pipeline the data routing to improve timing
//       I'm holding off on that until I synthesize and do
//       optimization.

// Note: To decrease processing time, it may be best to have a
//       separate decoder for each output port (not a single one
//       as we now have).

always_comb begin
    // Default Output Values
    out_data = 0;
    out_branch = 0;
    out_valid = 1'b0;
    stream_ready_0 = 1'b0;
    stream_ready_1 = 1'b0;
    stream_ready_2 = 1'b0;
    stream_ready_3 = 1'b0;
    stream_ready_4 = 1'b0;
    stream_ready_5 = 1'b0;
    stream_ready_6 = 1'b0;
    stream_ready_7 = 1'b0;
    // Priority Read Values
    if (stream_valid_0) begin
        out_data = stream_data_0[WIDTH-1:0];
        out_branch = stream_data_0[WIDTH+3-1:WIDTH];
        out_valid = 1'b1;
        stream_ready_0 = 1'b1;
    end else if (stream_valid_1) begin
        out_data = stream_data_1[WIDTH-1:0];
        out_branch = stream_data_1[WIDTH+3-1:WIDTH];
        out_valid = 1'b1;
        stream_ready_1 = 1'b1;
    end else if (stream_valid_2) begin
        out_data = stream_data_2[WIDTH-1:0];
        out_branch = stream_data_2[WIDTH+3-1:WIDTH];
        out_valid = 1'b1;
        stream_ready_2 = 1'b1;
    end else if (stream_valid_3) begin
        out_data = stream_data_3[WIDTH-1:0];
        out_branch = stream_data_3[WIDTH+3-1:WIDTH];
        out_valid = 1'b1;
        stream_ready_3 = 1'b1;
    end else if (stream_valid_4) begin
        out_data = stream_data_4[WIDTH-1:0];
        out_branch = stream_data_4[WIDTH+3-1:WIDTH];
        out_valid = 1'b1;
        stream_ready_4 = 1'b1;
    end else if (stream_valid_5) begin
        out_data = stream_data_5[WIDTH-1:0];
        out_branch = stream_data_5[WIDTH+3-1:WIDTH];
        out_valid = 1'b1;
        stream_ready_5 = 1'b1;
    end else if (stream_valid_6) begin
        out_data = stream_data_6[WIDTH-1:0];
        out_branch = stream_data_6[WIDTH+3-1:WIDTH];
        out_valid = 1'b1;
        stream_ready_6 = 1'b1;
    end else if (stream_valid_7) begin
        out_data = stream_data_7[WIDTH-1:0];
        out_branch = stream_data_7[WIDTH+3-1:WIDTH];
        out_valid = 1'b1;
        stream_ready_7 = 1'b1;
    end
end

always_ff @ (posedge i_clock) begin
    // Send data always everywhere indiscriminately
    o_data_0 <= out_data;
    o_data_1 <= out_data;
    o_data_2 <= out_data;
    o_data_3 <= out_data;
    o_data_4 <= out_data;
    o_data_5 <= out_data;
    o_data_6 <= out_data;
    o_data_7 <= out_data;

    // Selectively send the write valid signal
    o_valid_0 <= out_valid & (out_branch == 0);
    o_valid_1 <= out_valid & (out_branch == 1);
    o_valid_2 <= out_valid & (out_branch == 2);
    o_valid_3 <= out_valid & (out_branch == 3);
    o_valid_4 <= out_valid & (out_branch == 4);
    o_valid_5 <= out_valid & (out_branch == 5);
    o_valid_6 <= out_valid & (out_branch == 6);
    o_valid_7 <= out_valid & (out_branch == 7);
end

endmodule: mimo_fifo_8

`default_nettype wire
