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
    // Output Sample Interface
    output      logic [WIDTH-1:0] o_inph,
    output      logic [WIDTH-1:0] o_quad,
    output      logic             o_valid,
    input  wire logic             i_ready,
    // Clock and Reset
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

chmod_dds #() chmod_dds_inst

always @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
    end else begin
    end
end

endmodule: channel_modulator

`default_nettype wire
