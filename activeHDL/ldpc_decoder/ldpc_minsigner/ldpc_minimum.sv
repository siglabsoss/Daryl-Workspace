// ldpc_minimum.sv
// Finds the minimum of up to 8 inputs in 3 clock cycles
// Note: comparisons are unsigned

`timescale 10ps / 10ps

`default_nettype none

module ldpc_minimum #(
    parameter integer WIDTH = 16
) (
    input  wire logic [8*WIDTH-1:0] i_in_data,
    output      logic [WIDTH-1:0]   o_out_data,
    output      logic [7:0]         o_min_location,
    input  wire logic               i_clock,
    input  wire logic               i_reset
);

// Registered logic for stage 0
logic [WIDTH-1:0] minimum_ab_r0;
logic [WIDTH-1:0] minimum_cd_r0;
logic [WIDTH-1:0] minimum_ef_r0;
logic [WIDTH-1:0] minimum_gh_r0;
logic [1:0]       ismin_ab_r0;
logic [1:0]       ismin_cd_r0;
logic [1:0]       ismin_ef_r0;
logic [1:0]       ismin_gh_r0;

// Registered logic for stage 1
logic [WIDTH-1:0] minimum_abcd_r1;
logic [WIDTH-1:0] minimum_efgh_r1;
logic [3:0]       ismin_abcd_r1;
logic [3:0]       ismin_efgh_r1;

// Comb logic for stage 0
logic ab_test;
logic cd_test;
logic ef_test;
logic gh_test;

// Comb logic for stage 1
logic abcd_test;
logic efgh_test;

// Comb logic for stage 2 (output)
logic abcdefgh_test;

assign ab_test = { 1'b0,         i_in_data[WIDTH-1:0] } < { 1'b0, i_in_data[2*WIDTH-1:WIDTH]   };
assign cd_test = { 1'b0, i_in_data[3*WIDTH-1:2*WIDTH] } < { 1'b0, i_in_data[4*WIDTH-1:3*WIDTH] };
assign ef_test = { 1'b0, i_in_data[5*WIDTH-1:4*WIDTH] } < { 1'b0, i_in_data[6*WIDTH-1:5*WIDTH] };
assign gh_test = { 1'b0, i_in_data[7*WIDTH-1:6*WIDTH] } < { 1'b0, i_in_data[8*WIDTH-1:7*WIDTH] };

assign abcd_test = { 1'b0, minimum_ab_r0 } < { 1'b0, minimum_cd_r0 };
assign efgh_test = { 1'b0, minimum_ef_r0 } < { 1'b0, minimum_gh_r0 };

assign abcdefgh_test = {1'b0, minimum_abcd_r1} < {1'b0, minimum_efgh_r1};

always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        minimum_ab_r0 <= '0;
        minimum_cd_r0 <= '0;
        minimum_ef_r0 <= '0;
        minimum_gh_r0 <= '0;
        minimum_abcd_r1 <= '0;
        minimum_efgh_r1 <= '0;
        ismin_ab_r0 <= 2'b00;
        ismin_cd_r0 <= 2'b00;
        ismin_ef_r0 <= 2'b00;
        ismin_gh_r0 <= 2'b00;
        ismin_abcd_r1 <= 4'b0000;
        ismin_efgh_r1 <= 4'b0000;
        o_out_data <= '0;
        o_min_location <= '0;
    end else begin
        // Stage 0
        minimum_ab_r0 <= ab_test ? i_in_data[WIDTH-1:0]         : i_in_data[2*WIDTH-1:WIDTH];
        minimum_cd_r0 <= cd_test ? i_in_data[3*WIDTH-1:2*WIDTH] : i_in_data[4*WIDTH-1:3*WIDTH];
        minimum_ef_r0 <= ef_test ? i_in_data[5*WIDTH-1:4*WIDTH] : i_in_data[6*WIDTH-1:5*WIDTH];
        minimum_gh_r0 <= gh_test ? i_in_data[7*WIDTH-1:6*WIDTH] : i_in_data[8*WIDTH-1:7*WIDTH];
        ismin_ab_r0 <= ab_test ? 2'b01 : 2'b10;
        ismin_cd_r0 <= cd_test ? 2'b01 : 2'b10;
        ismin_ef_r0 <= ef_test ? 2'b01 : 2'b10;
        ismin_gh_r0 <= gh_test ? 2'b01 : 2'b10;

        // Stage 1
        minimum_abcd_r1 <= abcd_test ? minimum_ab_r0 : minimum_cd_r0;
        minimum_efgh_r1 <= efgh_test ? minimum_ef_r0 : minimum_gh_r0;
        ismin_abcd_r1 <= abcd_test ? { 2'b00, ismin_ab_r0 } : { ismin_cd_r0, 2'b00 };
        ismin_efgh_r1 <= efgh_test ? { 2'b00, ismin_ef_r0 } : { ismin_gh_r0, 2'b00 };

        // Stage 2
        o_out_data <= abcdefgh_test ? minimum_abcd_r1 : minimum_efgh_r1;
        o_min_location <= abcdefgh_test ? { 4'b0000, ismin_abcd_r1 } : { ismin_efgh_r1, 4'b0000 };
    end
end

endmodule: ldpc_minimum

`default_nettype wire
