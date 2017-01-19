// ldpc_accumulator.sv
// Accumulates 1 from 2, or 2 from 3, or 5 from 6 inputs
// to produce all possible combinations of sums at the output
//
// Takes 4 clock cycles

`timescale 10ps / 10ps

`default_nettype none

module ldpc_accumulator #(
    parameter integer NUM_INPUTS = 2, // valid values are 2, 3, and 6
    parameter integer WIDTH = 16,
    parameter integer NUM_WORDS = 1024
) (
    input  wire logic [NUM_INPUTS*WIDTH-1:0] i_in_data,
    output      logic [NUM_INPUTS*WIDTH-1:0] o_out_data,
    input  wire logic                        i_clock,
    input  wire logic                        i_reset
);

`ifdef SIMULATION
initial begin
    assert (NUM_INPUTS == 2) || (NUM_INPUTS == 3) || (NUM_INPUTS == 6);
    $display("TEST");
end
`endif

generate

if (NUM_INPUTS == 6) begin: acc6
    logic [WIDTH:0] sum_ab_r0;
    logic [WIDTH:0] sum_cd_r0;
    logic [WIDTH:0] sum_ef_r0;
    logic [WIDTH-1:0] term_a_r0;
    logic [WIDTH-1:0] term_b_r0;
    logic [WIDTH-1:0] term_c_r0;
    logic [WIDTH-1:0] term_d_r0;
    logic [WIDTH-1:0] term_e_r0;
    logic [WIDTH-1:0] term_f_r0;

    logic [WIDTH:0] sum_abcd_r1;
    logic [WIDTH:0] sum_abef_r1;
    logic [WIDTH:0] sum_cdef_r1;
    logic [WIDTH-1:0] term_a_r1;
    logic [WIDTH-1:0] term_b_r1;
    logic [WIDTH-1:0] term_c_r1;
    logic [WIDTH-1:0] term_d_r1;
    logic [WIDTH-1:0] term_e_r1;
    logic [WIDTH-1:0] term_f_r1;

    logic [WIDTH:0] sum_abcde_r2;
    logic [WIDTH:0] sum_abcdf_r2;
    logic [WIDTH:0] sum_abcef_r2;
    logic [WIDTH:0] sum_abdef_r2;
    logic [WIDTH:0] sum_acdef_r2;
    logic [WIDTH:0] sum_bcdef_r2;

    logic [WIDTH-1:0] saturated_abcde;
    logic [WIDTH-1:0] saturated_abcdf;
    logic [WIDTH-1:0] saturated_abcef;
    logic [WIDTH-1:0] saturated_abdef;
    logic [WIDTH-1:0] saturated_acdef;
    logic [WIDTH-1:0] saturated_bcdef;

    localparam logic [WIDTH:0] saturation_limit = { 3'b0, { WIDTH{ 1'b1 } } };
    localparam logic [WIDTH-1:0] saturation_result = { WIDTH{ 1'b1 } };
    assign saturated_abcde = (sum_abcde_r2 > saturation_limit) ? saturation_result : sum_abcde_r2;
    assign saturated_abcdf = (sum_abcdf_r2 > saturation_limit) ? saturation_result : sum_abcdf_r2;
    assign saturated_abcef = (sum_abcef_r2 > saturation_limit) ? saturation_result : sum_abcef_r2;
    assign saturated_abdef = (sum_abdef_r2 > saturation_limit) ? saturation_result : sum_abdef_r2;
    assign saturated_acdef = (sum_acdef_r2 > saturation_limit) ? saturation_result : sum_acdef_r2;
    assign saturated_bcdef = (sum_bcdef_r2 > saturation_limit) ? saturation_result : sum_bcdef_r2;

    always_ff @(posedge i_clock) begin
        if (i_reset == 1'b1) begin
            sum_ab_r0 <= '0;
            sum_cd_r0 <= '0;
            sum_ef_r0 <= '0;
            term_a_r0 <= '0;
            term_b_r0 <= '0;
            term_c_r0 <= '0;
            term_d_r0 <= '0;
            term_e_r0 <= '0;
            term_f_r0 <= '0;

            sum_abcd_r1 <= '0;
            sum_abef_r1 <= '0;
            sum_cdef_r1 <= '0;
            term_a_r1 <= '0;
            term_b_r1 <= '0;
            term_c_r1 <= '0;
            term_d_r1 <= '0;
            term_e_r1 <= '0;
            term_f_r1 <= '0;

            sum_abcde_r2 <= '0;
            sum_abcdf_r2 <= '0;
            sum_abcef_r2 <= '0;
            sum_abdef_r2 <= '0;
            sum_acdef_r2 <= '0;
            sum_bcdef_r2 <= '0;

            o_out_data <= '0;
        end else begin
            // Stage 0
            sum_ab_r0 <= { 1'b0, i_in_data[WIDTH-1:0] }
                + { 1'b0, i_in_data[2*WIDTH-1:WIDTH] };
            sum_cd_r0 <= { 1'b0, i_in_data[3*WIDTH-1:2*WIDTH] }
                + { 1'b0, i_in_data[4*WIDTH-1:3*WIDTH] };
            sum_ef_r0 <= { 1'b0, i_in_data[5*WIDTH-1:4*WIDTH] }
                + { 1'b0, i_in_data[6*WIDTH-1:5*WIDTH] };

            // Stage 1
            sum_abcd_r1 <= { 1'b0, sum_ab_r0 } + { 1'b0, sum_cd_r0 };
            sum_abef_r1 <= { 1'b0, sum_ab_r0 } + { 1'b0, sum_ef_r0 };
            sum_cdef_r1 <= { 1'b0, sum_cd_r0 } + { 1'b0, sum_ef_r0 };

            // Stage 2
            sum_abcde_r2 <= { 3'b0, term_e_r1 } + { 1'b0, sum_abcd_r1 };
            sum_abcdf_r2 <= { 3'b0, term_f_r1 } + { 1'b0, sum_abcd_r1 };
            sum_abcef_r2 <= { 3'b0, term_c_r1 } + { 1'b0, sum_abef_r1 };
            sum_abdef_r2 <= { 3'b0, term_d_r1 } + { 1'b0, sum_abef_r1 };
            sum_acdef_r2 <= { 3'b0, term_a_r1 } + { 1'b0, sum_cdef_r1 };
            sum_bcdef_r2 <= { 3'b0, term_b_r1 } + { 1'b0, sum_cdef_r1 };

            // Stage 3
            o_out_data <= {
                saturated_abcde,
                saturated_abcdf,
                saturated_abcef,
                saturated_abdef,
                saturated_acdef,
                saturated_bcdef
            };
        end
    end
end // acc6

if (NUM_INPUTS == 3) begin: acc3
    logic [WIDTH:0] sum_ab_r0;
    logic [WIDTH:0] sum_ac_r0;
    logic [WIDTH:0] sum_bc_r0;

    logic [WIDTH:0] sum_ab_r1;
    logic [WIDTH:0] sum_ac_r1;
    logic [WIDTH:0] sum_bc_r1;

    logic [WIDTH:0] sum_ab_r2;
    logic [WIDTH:0] sum_ac_r2;
    logic [WIDTH:0] sum_bc_r2;

    logic [WIDTH-1:0] saturated_ab;
    logic [WIDTH-1:0] saturated_ac;
    logic [WIDTH-1:0] saturated_bc;


    localparam [WIDTH:0] saturation_limit = { 1'b0, { WIDTH{ 1'b1 } } };
    localparam [WIDTH-1:0] saturation_result = { WIDTH{ 1'b1 } };
    assign saturated_ab = (sum_ab_r2 > saturation_limit) ? saturation_result : sum_ab_r2;
    assign saturated_ac = (sum_ac_r2 > saturation_limit) ? saturation_result : sum_ac_r2;
    assign saturated_bc = (sum_bc_r2 > saturation_limit) ? saturation_result : sum_bc_r2;

    always_ff @(posedge i_clock) begin
        if (i_reset == 1'b1) begin
            sum_ab_r0 <= '0;
            sum_bc_r0 <= '0;
            sum_ac_r0 <= '0;

            sum_ab_r1 <= '0;
            sum_bc_r1 <= '0;
            sum_ac_r1 <= '0;

            sum_ab_r2 <= '0;
            sum_bc_r2 <= '0;
            sum_ac_r2 <= '0;

            o_out_data <= '0;
        end else begin
            // Stage 0
            sum_ab_r0 <= { 1'b0, i_in_data[WIDTH-1:0] }
                + { 1'b0, i_in_data[2*WIDTH-1:WIDTH] };
            sum_bc_r0 <= { 1'b0, i_in_data[2*WIDTH-1:WIDTH] }
                + { 1'b0, i_in_data[3*WIDTH-1:2*WIDTH] };
            sum_ac_r0 <= { 1'b0, i_in_data[WIDTH-1:0] }
                + { 1'b0, i_in_data[3*WIDTH-1:2*WIDTH] };

            // Stage 1
            sum_ab_r1 <= sum_ab_r0;
            sum_bc_r1 <= sum_bc_r0;
            sum_ac_r1 <= sum_ac_r0;

            // Stage 2
            sum_ab_r2 <= sum_ab_r1;
            sum_bc_r2 <= sum_bc_r1;
            sum_ac_r2 <= sum_ac_r1;

            // Stage 3
            o_out_data <= {
                saturated_ab,
                saturated_ac,
                saturated_bc
            };
        end
    end
end // acc3

if (NUM_INPUTS == 2) begin: acc2
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
            o_out_data <= '0;
        end else begin
            // Stage 0
            term_a_r0 <= i_in_data[WIDTH-1:0];
            term_b_r0 <= i_in_data[2*WIDTH-1:WIDTH];

            // Stage 1
            term_a_r0 <= term_a_r1;
            term_b_r0 <= term_b_r1;

            // Stage 2
            o_out_data <= {
                term_a_r0,
                term_b_r0
            };

        end
    end
end // acc2

endgenerate

endmodule: ldpc_accumulator

`default_nettype wire
