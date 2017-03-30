`timescale 10ps / 10ps

`default_nettype none

module channel_modulator #(
    parameter integer WIDTH = 16,
    parameter integer NUM_CHANNELS = 2048
) (
    // Input Sample Interface
    input  wire logic [WIDTH-1:0] i_inph,
    input  wire logic [WIDTH-1:0] i_quad,
    input  wire logic             i_valid,
    output      logic             o_ready,
    // Phase Accumulator Increment
    input  wire logic [12-1:0]    i_phase_inc,
    input  wire logic             i_phase_inc_valid,
    // Output Sample Interface
    output      logic [WIDTH-1:0] o_inph,
    output      logic [WIDTH-1:0] o_quad,
    output      logic             o_valid,
    input  wire logic             i_ready,
    // Clock and Reset
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

logic stage0_proceed;
logic stage1_proceed;
logic stage2_proceed;
logic stage3_proceed;

logic stage0_valid;
logic stage1_valid;
logic stage2_valid;
logic stage3_valid;

logic [18-1:0] dds_cosine_data;
logic [18-1:0] dds_sine_data;

chmod_dds chmod_dds_inst (
    .i_phase_inc      (i_phase_inc      ),
    .i_phase_inc_valid(i_phase_inc_valid),
    .o_cosine_data    (dds_cosine_data  ),
    .o_sine_data      (dds_sine_data    ),
    .i_ready          (stage0_proceed   ),
    .i_clock          (i_clock          ),
    .i_reset          (i_reset          ));

enum {
    ST_INIT,
    ST_EMPTY,
    ST_NORMAL,
    ST_FULL
} curr_state, next_state;

logic signed [WIDTH-1:0]    inph_reg0;
logic signed [WIDTH-1:0]    quad_reg0;
logic signed [17:0]         cos_reg0;
logic signed [17:0]         sin_reg0;

logic signed [WIDTH+18-1:0] inph_cos_reg1;
logic signed [WIDTH+18-1:0] inph_sin_reg1;
logic signed [WIDTH-1:0]    quad_reg1;
logic signed [17:0]         cos_reg1;
logic signed [17:0]         sin_reg1;

logic signed [WIDTH+18-1:0] inph_cos_reg2;
logic signed [WIDTH+18-1:0] inph_sin_reg2;
logic signed [WIDTH+18-1:0] quad_cos_reg2;
logic signed [WIDTH+18-1:0] quad_sin_reg2;

always_ff @(posedge i_clock) begin
    // FSM state update
    if (i_reset == 1'b1) begin
        curr_state <= ST_INIT;
    end else begin
        curr_state <= next_state;
    end

    // FSM controlled Pipeline
    if (stage0_proceed == 1'b1) begin
        inph_reg0 <= i_inph;
        quad_reg0 <= i_quad;
        cos_reg0 <= dds_cosine_data;
        sin_reg0 <= dds_sine_data;
    end

    if (stage1_proceed == 1'b1) begin
        inph_cos_reg1 <= $signed(inph_reg0) * $signed(cos_reg0);
        inph_sin_reg1 <= $signed(inph_reg0) * $signed(sin_reg0);
        quad_reg1 <= quad_reg0;
        cos_reg1 <= cos_reg0;
        sin_reg1 <= sin_reg0;
    end

    if (stage2_proceed == 1'b1) begin
        inph_cos_reg2 <= inph_cos_reg1;
        inph_sin_reg2 <= inph_sin_reg1;
        quad_cos_reg2 <= $signed(quad_reg1) * $signed(cos_reg1);
        quad_sin_reg2 <= $signed(quad_reg1) * $signed(sin_reg1);
    end

    if (stage3_proceed == 1'b1) begin
        o_inph <= inph_cos_reg2 - quad_sin_reg2;
        o_quad <= inph_sin_reg2 + quad_cos_reg2;
    end

    // Keep track of which stages have valid data
    if (stage0_proceed == 1'b1) begin
        stage0_valid <= 1'b1;
    end else if (stage1_proceed == 1'b1) begin
        stage0_valid <= 1'b0;
    end

    if (stage1_proceed == 1'b1) begin
        stage1_valid <= 1'b1;
    end else if (stage2_proceed == 1'b1) begin
        stage1_valid <= 1'b0;
    end

    if (stage2_proceed == 1'b1) begin
        stage2_valid <= 1'b1;
    end else if (stage3_proceed == 1'b1) begin
        stage2_valid <= 1'b0;
    end

    if (stage3_proceed == 1'b1) begin
        stage3_valid <= 1'b1;
    end else if (i_ready == 1'b1) begin
        stage3_valid <= 1'b0;
    end
end

always_comb begin
    case (curr_state)
    ST_EMPTY: begin
        if (i_valid == 1'b1) begin
            next_state = ST_NORMAL;
        end else begin
            next_state = ST_EMPTY;
        end
        stage0_proceed = i_valid;
        stage1_proceed = 1'b0;
        stage2_proceed = 1'b0;
        stage3_proceed = 1'b0;
        o_valid = 1'b0;
        o_ready = 1'b1;
    end
    ST_NORMAL: begin
        if (i_valid & stage1_valid & stage2_valid & stage3_valid) begin
            next_state = ST_FULL;
        end else if (~i_valid & ~stage0_valid & ~stage1_valid & ~stage2_valid & (~stage3_valid | i_ready)) begin
            next_state = ST_EMPTY;
        end else begin
            next_state = ST_NORMAL;
        end
        stage0_proceed = i_valid;
        stage1_proceed = stage0_valid & (~stage1_valid | ~stage2_valid | ~stage3_valid);
        stage2_proceed = stage1_valid & (~stage2_valid | ~stage3_valid);
        stage3_proceed = stage2_valid & ~stage3_valid;
        o_valid = stage3_valid;
        o_ready = 1'b1;
    end
    ST_FULL: begin
        if (i_ready == 1'b1) begin
            next_state = ST_NORMAL;
        end else begin
            next_state = ST_FULL;
        end
        stage0_proceed = 1'b0; // Bubble, this pipeline operates at less than full rate
        stage1_proceed = i_ready;
        stage2_proceed = i_ready;
        stage3_proceed = i_ready;
        o_valid = 1'b1;
        o_ready = 1'b0;
    end
    default: begin // ST_INIT
        next_state = ST_EMPTY;
        stage0_proceed = 1'b0;
        stage1_proceed = 1'b0;
        stage2_proceed = 1'b0;
        stage3_proceed = 1'b0;
        o_valid = 1'b0;
        o_ready = 1'b0;
    end
    endcase
end

endmodule: channel_modulator

`default_nettype wire
