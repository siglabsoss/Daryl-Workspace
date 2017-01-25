`timescale 10ps / 10ps

`default_nettype none

module swapper #(
    parameter integer WIDTH=16
) (
    input  wire logic [WIDTH-1:0] i_term_a,
    input  wire logic [WIDTH-1:0] i_term_b,
    output      logic [WIDTH-1:0] o_term_a,
    output      logic [WIDTH-1:0] o_term_b,
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

logic [WIDTH-1:0] term_a_r0;
logic [WIDTH-1:0] term_b_r0;

logic [WIDTH-1:0] term_a_r1;
logic [WIDTH-1:0] term_b_r1;

always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        term_a_r0 <= '0;
        term_b_r0 <= '0;
        term_a_r1 <= '0;
        term_b_r1 <= '0;
        o_term_a <= '0;
        o_term_b <= '0;
    end else begin
        // Stage 0
        term_a_r0 <= i_term_b; // swap!
        term_b_r0 <= i_term_a; // swap!
        // Stage 1
        term_a_r1 <= term_a_r0;
        term_b_r1 <= term_b_r0;
        // Stage 2
        o_term_a <= term_a_r1;
        o_term_b <= term_a_r1;
    end
end

endmodule: swapper

`default_nettype wire