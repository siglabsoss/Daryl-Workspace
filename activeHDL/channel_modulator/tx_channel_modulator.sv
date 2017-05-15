`timescale 10ps / 10ps

`default_nettype none

module tx_channel_modulator #(
    parameter integer WIDTH = 16,
    parameter integer NUM_CHANNELS = 2048
) (
    // Input Sample Interface
    input  wire logic [WIDTH-1:0] i_inph,
    input  wire logic [WIDTH-1:0] i_quad,
    output      logic             o_ready,
    // Phase Accumulator Increment
    input  wire logic [12-1:0]    i_phase_inc,
    input  wire logic             i_phase_inc_valid,
    // Output Sample Interface
    output      logic [WIDTH-1:0] o_inph,
    output      logic [WIDTH-1:0] o_quad,
    input  wire logic             i_ready,
    // Clock and Reset
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

assign o_ready = i_reset ? 1'b0 : i_ready;

chmod_dds chmod_dds_inst (
    .i_phase_inc      (i_phase_inc      ),
    .i_phase_inc_valid(i_phase_inc_valid),
    .o_cosine_data    (dds_cosine_data  ),
    .o_sine_data      (dds_sine_data    ),
    .i_ready          (i_ready          ),
    .i_clock          (i_clock          ),
    .i_reset          (i_reset          ));

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
    if (i_ready == 1'b1) begin
        // Stage 0
        inph_reg0 <= i_inph;
        quad_reg0 <= i_quad;
        cos_reg0 <= dds_cosine_data;
        sin_reg0 <= dds_sine_data;
        // Stage 1
        inph_cos_reg1 <= $signed(inph_reg0) * $signed(cos_reg0);
        inph_sin_reg1 <= $signed(inph_reg0) * $signed(sin_reg0);
        quad_reg1 <= quad_reg0;
        cos_reg1 <= cos_reg0;
        sin_reg1 <= sin_reg0;
        // Stage 2
        inph_cos_reg2 <= inph_cos_reg1;
        inph_sin_reg2 <= inph_sin_reg1;
        quad_cos_reg2 <= $signed(quad_reg1) * $signed(cos_reg1);
        quad_sin_reg2 <= $signed(quad_reg1) * $signed(sin_reg1);
        // Stage 3 (Output)
        o_inph <= inph_cos_reg2 - quad_sin_reg2;
        o_quad <= inph_sin_reg2 + quad_cos_reg2;
    end
end

endmodule: tx_channel_modulator

`default_nettype wire
