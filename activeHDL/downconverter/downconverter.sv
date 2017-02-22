`timescale 10ps / 10ps

`default_nettype none

module downconverter #(
    parameter integer WIDTH = 16
) (
    input  wire logic [WIDTH-1:0] i_inph_data,
    input  wire logic [WIDTH-1:0] i_quad_data,
    input  wire logic [WIDTH-1:0] i_inph_delay_data,
    input  wire logic [WIDTH-1:0] i_quad_delay_data,
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

// Pipeline Stage 1
logic signed [36-1:0] cosine_reg0;
logic signed [36-1:0] sine_reg0;
logic signed [36-1:0] cosine_delay_reg0;
logic signed [36-1:0] sine_delay_reg0;
logic                 valid_reg0;
always_ff @(posedge i_clock) begin

end

endmodule: downconverter

`default_nettype wire
