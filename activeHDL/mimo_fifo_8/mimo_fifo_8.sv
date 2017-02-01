// mimo_fifo_8.sv
//
// Multi-input fifo for buffering simultaneous computations
// that need to go to the same memory. Note, he memory part
// is assumed to always be able to accept data, that is why
// there is no ready signal for the outputs (it is assumed
// active high all the time).

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
    output      logic             o_data_0,
    output      logic             o_valid_0,
    output      logic             o_data_1,
    output      logic             o_valid_1,
    output      logic             o_data_2,
    output      logic             o_valid_2,
    output      logic             o_data_3,
    output      logic             o_valid_3,
    output      logic             o_data_4,
    output      logic             o_valid_4,
    output      logic             o_data_5,
    output      logic             o_valid_5,
    output      logic             o_data_6,
    output      logic             o_valid_6,
    output      logic             o_data_7,
    output      logic             o_valid_7,
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

localparam NUM_INPUTS = 8;
localparam NUM_OUTPUTS = 8;

logic ready_0, ready_1, ready_2, ready_3;
logic ready_4, ready_5, ready_6, ready_7;

logic [WIDTH+3-1:0] stream_data_7
logic               stream_valid_7
logic               stream_ready_7

// May need to figure out a better way to handle this
// eventually, each ready is a combinatorial output of
// 2 signals, so this is a 16-input LUT which is going
// to limit timing... Could use skid buffering here to
// break things up.
assign o_ready = ready_0 & ready_1
    & ready_2 & ready_3 & ready_4
    & ready_5 & ready_6 & ready_7;

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

// FSM to control the prioritized round robin output ordering

enum {
    ST_INIT, ST_PRIORITY0, ST_PRIORITY1,
    ST_PRIORITY2, ST_PRIORITY3, ST_PRIORITY4,
    ST_PRIORITY5, ST_PRIORITY6, ST_PRIORITY7
} curr_state, next_state;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        curr_state <= ST_INIT;
    end else begin
        curr_state <= next_state;
    end
end

logic [WIDTH-1:0] out_data;
logic [2:0]       out_branch;
logic             out_valid_0;
logic             out_valid_1;
logic             out_valid_2;
logic             out_valid_3;
logic             out_valid_4;
logic             out_valid_5;
logic             out_valid_6;
logic             out_valid_7;

// NOTE: May need to pipeline the data routing to improve timing
// I'm holding off on that until I synthesize and do optimization.

always_comb begin
    // Default Output Value
    out_data = 0;
    out_branch = 0;
    out_valid_0 = 1'b0;
    out_valid_1 = 1'b0;
    out_valid_2 = 1'b0;
    out_valid_3 = 1'b0;
    out_valid_4 = 1'b0;
    out_valid_5 = 1'b0;
    out_valid_6 = 1'b0;
    out_valid_7 = 1'b0;
    stream_ready_0 = 1'b0;
    stream_ready_1 = 1'b0;
    stream_ready_2 = 1'b0;
    stream_ready_3 = 1'b0;
    stream_ready_4 = 1'b0;
    stream_ready_5 = 1'b0;
    stream_ready_6 = 1'b0;
    stream_ready_7 = 1'b0;
    // Case Decoding
    case (curr_state) begin
    ST_PRIORITY7: begin
        if (stream_valid_7) begin
            out_data = stream_data_7(WIDTH-1:0);
            out_branch = stream_data_7(WIDTH+3-1:WIDTH);
            out_valid_7 = 1'b1;
            stream_ready_7 = 1'b1;
        end else if (stream_valid_0) begin
            out_data = stream_data_0(WIDTH-1:0);
            out_branch = stream_data_0(WIDTH+3-1:WIDTH);
            out_valid_0 = 1'b1;
            stream_ready_0 = 1'b1;
        end else if (stream_valid_1) begin
            out_data = stream_data_1(WIDTH-1:0);
            out_branch = stream_data_1(WIDTH+3-1:WIDTH);
            out_valid_1 = 1'b1;
            stream_ready_1 = 1'b1;
        end else if (stream_valid_2) begin
            out_data = stream_data_2(WIDTH-1:0);
            out_branch = stream_data_2(WIDTH+3-1:WIDTH);
            out_valid_2 = 1'b1;
            stream_ready_2 = 1'b1;
        end else if (stream_valid_3) begin
            out_data = stream_data_3(WIDTH-1:0);
            out_branch = stream_data_3(WIDTH+3-1:WIDTH);
            out_valid_3 = 1'b1;
            stream_ready_3 = 1'b1;
        end else if (stream_valid_4) begin
            out_data = stream_data_4(WIDTH-1:0);
            out_branch = stream_data_4(WIDTH+3-1:WIDTH);
            out_valid_4 = 1'b1;
            stream_ready_4 = 1'b1;
        end else if (stream_valid_5) begin
            out_data = stream_data_5(WIDTH-1:0);
            out_branch = stream_data_5(WIDTH+3-1:WIDTH);
            out_valid_5 = 1'b1;
            stream_ready_5 = 1'b1;
        end else if (stream_valid_6) begin
            out_data = stream_data_6(WIDTH-1:0);
            out_branch = stream_data_6(WIDTH+3-1:WIDTH);
            out_valid_6 = 1'b1;
            stream_ready_6 = 1'b1;
        end
    end
    ST_PRIORITY6: begin
        if (stream_valid_6) begin
            out_data = stream_data_6(WIDTH-1:0);
            out_branch = stream_data_6(WIDTH+3-1:WIDTH);
            out_valid_6 = 1'b1;
            stream_ready_6 = 1'b1;
        end else if (stream_valid_7) begin
            out_data = stream_data_7(WIDTH-1:0);
            out_branch = stream_data_7(WIDTH+3-1:WIDTH);
            out_valid_7 = 1'b1;
            stream_ready_7 = 1'b1;
        end else if (stream_valid_0) begin
            out_data = stream_data_0(WIDTH-1:0);
            out_branch = stream_data_0(WIDTH+3-1:WIDTH);
            out_valid_0 = 1'b1;
            stream_ready_0 = 1'b1;
        end else if (stream_valid_1) begin
            out_data = stream_data_1(WIDTH-1:0);
            out_branch = stream_data_1(WIDTH+3-1:WIDTH);
            out_valid_1 = 1'b1;
            stream_ready_1 = 1'b1;
        end else if (stream_valid_2) begin
            out_data = stream_data_2(WIDTH-1:0);
            out_branch = stream_data_2(WIDTH+3-1:WIDTH);
            out_valid_2 = 1'b1;
            stream_ready_2 = 1'b1;
        end else if (stream_valid_3) begin
            out_data = stream_data_3(WIDTH-1:0);
            out_branch = stream_data_3(WIDTH+3-1:WIDTH);
            out_valid_3 = 1'b1;
            stream_ready_3 = 1'b1;
        end else if (stream_valid_4) begin
            out_data = stream_data_4(WIDTH-1:0);
            out_branch = stream_data_4(WIDTH+3-1:WIDTH);
            out_valid_4 = 1'b1;
            stream_ready_4 = 1'b1;
        end else if (stream_valid_5) begin
            out_data = stream_data_5(WIDTH-1:0);
            out_branch = stream_data_5(WIDTH+3-1:WIDTH);
            out_valid_5 = 1'b1;
            stream_ready_5 = 1'b1;
        end
    end
    ST_PRIORITY5: begin
        if (stream_valid_5) begin
            out_data = stream_data_5(WIDTH-1:0);
            out_branch = stream_data_5(WIDTH+3-1:WIDTH);
            out_valid_5 = 1'b1;
            stream_ready_5 = 1'b1;
        end else if (stream_valid_6) begin
            out_data = stream_data_6(WIDTH-1:0);
            out_branch = stream_data_6(WIDTH+3-1:WIDTH);
            out_valid_6 = 1'b1;
            stream_ready_6 = 1'b1;
        end else if (stream_valid_7) begin
            out_data = stream_data_7(WIDTH-1:0);
            out_branch = stream_data_7(WIDTH+3-1:WIDTH);
            out_valid_7 = 1'b1;
            stream_ready_7 = 1'b1;
        end else if (stream_valid_0) begin
            out_data = stream_data_0(WIDTH-1:0);
            out_branch = stream_data_0(WIDTH+3-1:WIDTH);
            out_valid_0 = 1'b1;
            stream_ready_0 = 1'b1;
        end else if (stream_valid_1) begin
            out_data = stream_data_1(WIDTH-1:0);
            out_branch = stream_data_1(WIDTH+3-1:WIDTH);
            out_valid_1 = 1'b1;
            stream_ready_1 = 1'b1;
        end else if (stream_valid_2) begin
            out_data = stream_data_2(WIDTH-1:0);
            out_branch = stream_data_2(WIDTH+3-1:WIDTH);
            out_valid_2 = 1'b1;
            stream_ready_2 = 1'b1;
        end else if (stream_valid_3) begin
            out_data = stream_data_3(WIDTH-1:0);
            out_branch = stream_data_3(WIDTH+3-1:WIDTH);
            out_valid_3 = 1'b1;
            stream_ready_3 = 1'b1;
        end else if (stream_valid_4) begin
            out_data = stream_data_4(WIDTH-1:0);
            out_branch = stream_data_4(WIDTH+3-1:WIDTH);
            out_valid_4 = 1'b1;
            stream_ready_4 = 1'b1;
        end
    end
    ST_PRIORITY4: begin
        if (stream_valid_4) begin
            out_data = stream_data_4(WIDTH-1:0);
            out_branch = stream_data_4(WIDTH+3-1:WIDTH);
            out_valid_4 = 1'b1;
            stream_ready_4 = 1'b1;
        end else if (stream_valid_5) begin
            out_data = stream_data_5(WIDTH-1:0);
            out_branch = stream_data_5(WIDTH+3-1:WIDTH);
            out_valid_5 = 1'b1;
            stream_ready_5 = 1'b1;
        end else if (stream_valid_6) begin
            out_data = stream_data_6(WIDTH-1:0);
            out_branch = stream_data_6(WIDTH+3-1:WIDTH);
            out_valid_6 = 1'b1;
            stream_ready_6 = 1'b1;
        end else if (stream_valid_7) begin
            out_data = stream_data_7(WIDTH-1:0);
            out_branch = stream_data_7(WIDTH+3-1:WIDTH);
            out_valid_7 = 1'b1;
            stream_ready_7 = 1'b1;
        end else if (stream_valid_0) begin
            out_data = stream_data_0(WIDTH-1:0);
            out_branch = stream_data_0(WIDTH+3-1:WIDTH);
            out_valid_0 = 1'b1;
            stream_ready_0 = 1'b1;
        end else if (stream_valid_1) begin
            out_data = stream_data_1(WIDTH-1:0);
            out_branch = stream_data_1(WIDTH+3-1:WIDTH);
            out_valid_1 = 1'b1;
            stream_ready_1 = 1'b1;
        end else if (stream_valid_2) begin
            out_data = stream_data_2(WIDTH-1:0);
            out_branch = stream_data_2(WIDTH+3-1:WIDTH);
            out_valid_2 = 1'b1;
            stream_ready_2 = 1'b1;
        end else if (stream_valid_3) begin
            out_data = stream_data_3(WIDTH-1:0);
            out_branch = stream_data_3(WIDTH+3-1:WIDTH);
            out_valid_3 = 1'b1;
            stream_ready_3 = 1'b1;
        end
    end
    ST_PRIORITY3: begin
        if (stream_valid_3) begin
            out_data = stream_data_3(WIDTH-1:0);
            out_branch = stream_data_3(WIDTH+3-1:WIDTH);
            out_valid_3 = 1'b1;
            stream_ready_3 = 1'b1;
        end else if (stream_valid_4) begin
            out_data = stream_data_4(WIDTH-1:0);
            out_branch = stream_data_4(WIDTH+3-1:WIDTH);
            out_valid_4 = 1'b1;
            stream_ready_4 = 1'b1;
        end else if (stream_valid_5) begin
            out_data = stream_data_5(WIDTH-1:0);
            out_branch = stream_data_5(WIDTH+3-1:WIDTH);
            out_valid_5 = 1'b1;
            stream_ready_5 = 1'b1;
        end else if (stream_valid_6) begin
            out_data = stream_data_6(WIDTH-1:0);
            out_branch = stream_data_6(WIDTH+3-1:WIDTH);
            out_valid_6 = 1'b1;
            stream_ready_6 = 1'b1;
        end else if (stream_valid_7) begin
            out_data = stream_data_7(WIDTH-1:0);
            out_branch = stream_data_7(WIDTH+3-1:WIDTH);
            out_valid_7 = 1'b1;
            stream_ready_7 = 1'b1;
        end else if (stream_valid_0) begin
            out_data = stream_data_0(WIDTH-1:0);
            out_branch = stream_data_0(WIDTH+3-1:WIDTH);
            out_valid_0 = 1'b1;
            stream_ready_0 = 1'b1;
        end else if (stream_valid_1) begin
            out_data = stream_data_1(WIDTH-1:0);
            out_branch = stream_data_1(WIDTH+3-1:WIDTH);
            out_valid_1 = 1'b1;
            stream_ready_1 = 1'b1;
        end else if (stream_valid_2) begin
            out_data = stream_data_2(WIDTH-1:0);
            out_branch = stream_data_2(WIDTH+3-1:WIDTH);
            out_valid_2 = 1'b1;
            stream_ready_2 = 1'b1;
        end
    end
    ST_PRIORITY2: begin
        if (stream_valid_2) begin
            out_data = stream_data_2(WIDTH-1:0);
            out_branch = stream_data_2(WIDTH+3-1:WIDTH);
            out_valid_2 = 1'b1;
            stream_ready_2 = 1'b1;
        end else if (stream_valid_3) begin
            out_data = stream_data_3(WIDTH-1:0);
            out_branch = stream_data_3(WIDTH+3-1:WIDTH);
            out_valid_3 = 1'b1;
            stream_ready_3 = 1'b1;
        end else if (stream_valid_4) begin
            out_data = stream_data_4(WIDTH-1:0);
            out_branch = stream_data_4(WIDTH+3-1:WIDTH);
            out_valid_4 = 1'b1;
            stream_ready_4 = 1'b1;
        end else if (stream_valid_5) begin
            out_data = stream_data_5(WIDTH-1:0);
            out_branch = stream_data_5(WIDTH+3-1:WIDTH);
            out_valid_5 = 1'b1;
            stream_ready_5 = 1'b1;
        end else if (stream_valid_6) begin
            out_data = stream_data_6(WIDTH-1:0);
            out_branch = stream_data_6(WIDTH+3-1:WIDTH);
            out_valid_6 = 1'b1;
            stream_ready_6 = 1'b1;
        end else if (stream_valid_7) begin
            out_data = stream_data_7(WIDTH-1:0);
            out_branch = stream_data_7(WIDTH+3-1:WIDTH);
            out_valid_7 = 1'b1;
            stream_ready_7 = 1'b1;
        end else if (stream_valid_0) begin
            out_data = stream_data_0(WIDTH-1:0);
            out_branch = stream_data_0(WIDTH+3-1:WIDTH);
            out_valid_0 = 1'b1;
            stream_ready_0 = 1'b1;
        end else if (stream_valid_1) begin
            out_data = stream_data_1(WIDTH-1:0);
            out_branch = stream_data_1(WIDTH+3-1:WIDTH);
            out_valid_1 = 1'b1;
            stream_ready_1 = 1'b1;
        end
    end
    ST_PRIORITY1: begin
        if (stream_valid_1) begin
            out_data = stream_data_1(WIDTH-1:0);
            out_branch = stream_data_1(WIDTH+3-1:WIDTH);
            out_valid_1 = 1'b1;
            stream_ready_1 = 1'b1;
        end else if (stream_valid_2) begin
            out_data = stream_data_2(WIDTH-1:0);
            out_branch = stream_data_2(WIDTH+3-1:WIDTH);
            out_valid_2 = 1'b1;
            stream_ready_2 = 1'b1;
        end else if (stream_valid_3) begin
            out_data = stream_data_3(WIDTH-1:0);
            out_branch = stream_data_3(WIDTH+3-1:WIDTH);
            out_valid_3 = 1'b1;
            stream_ready_3 = 1'b1;
        end else if (stream_valid_4) begin
            out_data = stream_data_4(WIDTH-1:0);
            out_branch = stream_data_4(WIDTH+3-1:WIDTH);
            out_valid_4 = 1'b1;
            stream_ready_4 = 1'b1;
        end else if (stream_valid_5) begin
            out_data = stream_data_5(WIDTH-1:0);
            out_branch = stream_data_5(WIDTH+3-1:WIDTH);
            out_valid_5 = 1'b1;
            stream_ready_5 = 1'b1;
        end else if (stream_valid_6) begin
            out_data = stream_data_6(WIDTH-1:0);
            out_branch = stream_data_6(WIDTH+3-1:WIDTH);
            out_valid_6 = 1'b1;
            stream_ready_6 = 1'b1;
        end else if (stream_valid_7) begin
            out_data = stream_data_7(WIDTH-1:0);
            out_branch = stream_data_7(WIDTH+3-1:WIDTH);
            out_valid_7 = 1'b1;
            stream_ready_7 = 1'b1;
        end else if (stream_valid_0) begin
            out_data = stream_data_0(WIDTH-1:0);
            out_branch = stream_data_0(WIDTH+3-1:WIDTH);
            out_valid_0 = 1'b1;
            stream_ready_0 = 1'b1;
        end
    end
    ST_PRIORITY0: begin
        if (stream_valid_0) begin
            out_data = stream_data_0(WIDTH-1:0);
            out_branch = stream_data_0(WIDTH+3-1:WIDTH);
            out_valid_0 = 1'b1;
            stream_ready_0 = 1'b1;
        end else if (stream_valid_1) begin
            out_data = stream_data_1(WIDTH-1:0);
            out_branch = stream_data_1(WIDTH+3-1:WIDTH);
            out_valid_1 = 1'b1;
            stream_ready_1 = 1'b1;
        end else if (stream_valid_2) begin
            out_data = stream_data_2(WIDTH-1:0);
            out_branch = stream_data_2(WIDTH+3-1:WIDTH);
            out_valid_2 = 1'b1;
            stream_ready_2 = 1'b1;
        end else if (stream_valid_3) begin
            out_data = stream_data_3(WIDTH-1:0);
            out_branch = stream_data_3(WIDTH+3-1:WIDTH);
            out_valid_3 = 1'b1;
            stream_ready_3 = 1'b1;
        end else if (stream_valid_4) begin
            out_data = stream_data_4(WIDTH-1:0);
            out_branch = stream_data_4(WIDTH+3-1:WIDTH);
            out_valid_4 = 1'b1;
            stream_ready_4 = 1'b1;
        end else if (stream_valid_5) begin
            out_data = stream_data_5(WIDTH-1:0);
            out_branch = stream_data_5(WIDTH+3-1:WIDTH);
            out_valid_5 = 1'b1;
            stream_ready_5 = 1'b1;
        end else if (stream_valid_6) begin
            out_data = stream_data_6(WIDTH-1:0);
            out_branch = stream_data_6(WIDTH+3-1:WIDTH);
            out_valid_6 = 1'b1;
            stream_ready_6 = 1'b1;
        end else if (stream_valid_7) begin
            out_data = stream_data_7(WIDTH-1:0);
            out_branch = stream_data_7(WIDTH+3-1:WIDTH);
            out_valid_7 = 1'b1;
            stream_ready_7 = 1'b1;
        end
    end
    default: begin
        // Use default values
    end
end

endmodule: miso_fifo_8