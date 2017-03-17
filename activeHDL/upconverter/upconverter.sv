`timescale 10ps / 10ps

`default_nettype none

module downconverter #(
    parameter integer WIDTH = 16
) (
    input  wire logic [WIDTH-1:0] i_inph_data,
    input  wire logic [WIDTH-1:0] i_inph_delay_data,
    input  wire logic             i_valid,
    input  wire logic [32-1:0]    i_phase_inc,
    input  wire logic             i_phase_inc_valid,
    output      logic [WIDTH-1:0] o_inph_data,
    output      logic [WIDTH-1:0] o_quad_data,
    output      logic             o_valid,
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

// Pipeline Stage 0
logic signed [36-1:0] cosine_reg_n1;
logic signed [36-1:0] sine_reg_n1;
logic signed [36-1:0] cosine_delay_reg_n1;
logic signed [36-1:0] sine_delay_reg_n1;

ddc_ddsx2 ddc_ddsx2_inst (
    .i_phase_inc        (i_phase_inc        ),
    .i_phase_inc_valid  (i_phase_inc_valid  ),
    .o_cosine_data      (cosine_reg_n1      ),
    .o_sine_data        (sine_reg_n1        ),
    .o_cosine_delay_data(cosine_delay_reg_n1),
    .o_sine_delay_data  (sine_delay_reg_n1  ),
    .i_ready            (i_valid            ),
    .i_clock            (i_clock            ),
    .i_reset            (i_reset            ));

// Pipeline Stage 0
logic signed [WIDTH-1:0] inph_data_reg0;
logic signed [WIDTH-1:0] inph_data_delay_reg0;
logic signed [36-1:0] cosine_reg0;
logic signed [36-1:0] sine_reg0;
logic signed [36-1:0] cosine_delay_reg0;
logic signed [36-1:0] sine_delay_reg0;
logic                 valid_reg0;
always_ff @(posedge i_clock) begin
    inph_data_reg0 <= i_inph_data;
    inph_data_delay_reg0 <= i_inph_delay_data;
    cosine_reg0 <= cosine_reg_n1;
    sine_reg0 <= sine_reg_n1;
    cosine_delay_reg0 <= cosine_delay_reg_n1;
    sine_delay_reg0 <= sine_delay_reg_n1;
    valid_reg0 <= i_valid;
end

// Pipeline Stages 1, 2, and 3
logic signed [36+WIDTH-1:0] inph_data_reg1;
logic signed [36+WIDTH-1:0] quad_data_reg1;
logic signed [36+WIDTH-1:0] inph_data_delay_reg1;
logic signed [36+WIDTH-1:0] quad_data_delay_reg1;
logic                       valid_reg1;

logic signed [WIDTH-1:0] inph_data_reg2;
logic signed [WIDTH-1:0] quad_data_reg2;
logic signed [WIDTH-1:0] inph_data_delay_reg2;
logic signed [WIDTH-1:0] quad_data_delay_reg2;
logic                    valid_reg2;

logic signed [WIDTH-1:0] inph_data_reg3;
logic signed [WIDTH-1:0] quad_data_reg3;
logic signed [WIDTH-1:0] inph_data_delay_reg3;
logic signed [WIDTH-1:0] quad_data_delay_reg3;
logic                    valid_reg3;

always_ff @(posedge i_clock) begin
    // Pipeline Stage 1
    inph_data_reg1 <= inph_data_reg0 * cosine_reg0;
    quad_data_reg1 <= inph_data_reg0 * sine_reg0;
    inph_data_delay_reg1 <= inph_data_delay_reg0 * cosine_delay_reg0;
    quad_data_delay_reg1 <= inph_data_delay_reg0 * sine_delay_reg0;
    valid_reg1 <= valid_reg0;

    // Pipeline Stage 2
    inph_data_reg2 <= (inph_data_reg1[36+WIDTH-1:35] + 1'b1) >>> 1;
    quad_data_reg2 <= (quad_data_reg1[36+WIDTH-1:35] + 1'b1) >>> 1;
    inph_data_delay_reg2 <= (inph_data_delay_reg1[36+WIDTH-1:35] + 1'b1) >>> 1;
    quad_data_delay_reg2 <= (quad_data_delay_reg1[36+WIDTH-1:35] + 1'b1) >>> 1;
    valid_reg2 <= valid_reg1;

    // Pipeline Stage 3
    inph_data_reg3 <= inph_data_reg2;
    quad_data_reg3 <= quad_data_reg2;
    inph_data_delay_reg3 <= inph_data_delay_reg2;
    quad_data_delay_reg3 <= quad_data_delay_reg2;
    valid_reg3 <= valid_reg2;
end

ddc_hb_cascade #(
    .WIDTH(WIDTH))
ddc_hb_cascade_inst (
    .i_inph_data      (inph_data_reg3      ),
    .i_quad_data      (quad_data_reg3      ),
    .i_inph_delay_data(inph_data_delay_reg3),
    .i_quad_delay_data(quad_data_delay_reg3),
    .i_valid          (valid_reg3          ),
    .o_inph_data      (o_inph_data         ),
    .o_quad_data      (o_quad_data         ),
    .o_valid          (o_valid             ),
    .i_clock          (i_clock             ),
    .i_reset          (i_reset             ));

endmodule: downconverter

`default_nettype wire
