// ldpc_minimum.sv
// Finds the minimum of up to 8 inputs in 3 clock cycles

`timescale 10ps / 10ps

`default_nettype none

module ldpc_minimum #(
    parameter integer MINIMUMS = 8, // valid values are 2, 4, 8
    parameter integer WIDTH = 16,
    parameter integer NUM_WORDS = 1024
) (
    input  wire logic [MINIMUMS*WIDTH-1:0] i_in_data,
    output      logic [MINIMUMS*WIDTH-1:0] o_out_data,
    input  wire logic                      i_clock,
    input  wire logic                      i_reset
);

generate

if (MINIMUMS == 8) begin: min8
    logic [WIDTH-1:0] minimum_ab_r0;
    logic [WIDTH-1:0] minimum_cd_r0;
    logic [WIDTH-1:0] minimum_ef_r0;
    logic [WIDTH-1:0] minimum_gh_r0;

    logic [WIDTH-1:0] minimum_abcd_r1;
    logic [WIDTH-1:0] minimum_efgh_r1;

    always_ff @(posedge i_clock) begin
        if(i_reset) begin
            minimum_ab_r0 <= '0;
            minimum_cd_r0 <= '0;
            minimum_ef_r0 <= '0;
            minimum_gh_r0 <= '0;
            minimum_abcd_r1 <= '0;
            minimum_efgh_r1 <= '0;
            o_out_data <= '0;
        end else begin
            // Stage 0
            minimum_ab_r0 <= (i_in_data[WIDTH-1:0] < i_in_data[2*WIDTH-1:WIDTH]) ?
                i_in_data[WIDTH-1:0] : i_in_data[2*WIDTH-1:WIDTH];
            minimum_cd_r0 <= (i_in_data[3*WIDTH-1:2*WIDTH] < i_in_data[4*WIDTH-1:3*WIDTH]) ?
                i_in_data[3*WIDTH-1:2*WIDTH] : i_in_data[4*WIDTH-1:3*WIDTH];
            minimum_ef_r0 <= (i_in_data[5*WIDTH-1:4*WIDTH] < i_in_data[6*WIDTH-1:5*WIDTH]) ?
                i_in_data[5*WIDTH-1:4*WIDTH] : i_in_data[6*WIDTH-1:5*WIDTH];
            minimum_gh_r0 <= (i_in_data[7*WIDTH-1:6*WIDTH] < i_in_data[8*WIDTH-1:7*WIDTH]) ?
                i_in_data[7*WIDTH-1:6*WIDTH] : i_in_data[8*WIDTH-1:7*WIDTH];

            // Stage 1
            minimum_abcd_r1 <= (minimum_ab_r0 < minimum_cd_r0) ?
                minimum_ab_r0 : minimum_cd_r0;
            minimum_efgh_r1 <= (minimum_ef_r0 < minimum_gh_r0) ?
                minimum_ef_r0 : minimum_gh_r0;

            // Stage 2
            o_out_data <= (minimum_abcd_r1 < minimum_efgh_r1) ?
                minimum_abcd_r1 : minimum_efgh_r1;
        end
    end
end // min8

if (MINIMUMS == 4) begin: min4
    logic [WIDTH-1:0] minimum_ab_r0;
    logic [WIDTH-1:0] minimum_cd_r0;

    logic [WIDTH-1:0] minimum_abcd_r1;

    always_ff @(posedge i_clock) begin
        if(i_reset) begin
            minimum_ab_r0 <= '0;
            minimum_cd_r0 <= '0;
            minimum_abcd_r1 <= '0;
            o_out_data <= '0;
        end else begin
            // Stage 0
            minimum_ab_r0 <= i_in_data[WIDTH-1:0] < i_in_data[2*WIDTH-1:WIDTH] ?
                i_in_data[WIDTH-1:0] : i_in_data[2*WIDTH-1:WIDTH];
            minimum_cd_r0 <= i_in_data[3*WIDTH-1:2*WIDTH] < i_in_data[4*WIDTH-1:3*WIDTH] ?
                i_in_data[3*WIDTH-1:2*WIDTH] : i_in_data[4*WIDTH-1:3*WIDTH];

            // Stage 1
            minimum_abcd_r1 <= minimum_ab_r0 < minimum_cd_r0 ?
                minimum_ab_r0 : minimum_cd_r0;

            // Stage 2
            o_out_data <= minimum_abcd_r1;
        end
    end
end // min4

if (MINIMUMS == 2) begin: min2
    logic [WIDTH-1:0] minimum_ab_r0;
    logic [WIDTH-1:0] minimum_ab_r1;

    always_ff @(posedge i_clock) begin
        if(i_reset) begin
            minimum_ab_r0 <= '0;
            minimum_ab_r1 <= '0;
            o_out_data <= '0;
        end else begin
            // Stage 0
            minimum_ab_r0 <= i_in_data[WIDTH-1:0] < i_in_data[2*WIDTH-1:WIDTH] ?
                i_in_data[WIDTH-1:0] : i_in_data[2*WIDTH-1:WIDTH];

            // Stage 1
            minimum_ab_r1 <= minimum_ab_r0;

            // Stage 2
            o_out_data <= minimum_ab_r1;
        end
    end
end // min2

endgenerate

endmodule: ldpc_minimum

`default_nettype wire
