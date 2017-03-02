`timescale 10ps / 10ps

`default_nettype none

module cic_decim #(
    parameter integer WIDTH = 16
) (
    input  wire logic [WIDTH-1:0] i_inph_data,
    input  wire logic [WIDTH-1:0] i_quad_data,
    input  wire logic             i_valid,
    output      logic [WIDTH-1:0] o_inph_data,
    output      logic [WIDTH-1:0] o_quad_data,
    output      logic             o_valid,
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

always @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        o_out_data <= 0;
        o_out_valid <= 1'b0;
    end else begin
        o_out_data <= i_in_data;
        o_out_valid <= i_in_valid;
    end
end

endmodule: cic_decim

`default_nettype wire
