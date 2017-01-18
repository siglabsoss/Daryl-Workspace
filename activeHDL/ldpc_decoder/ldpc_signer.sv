// ldpc_minimum.sv
// Finds the sign based on up to 8 input signs in 3 clock cycles

`timescale 10ps / 10ps

`default_nettype none

module ldpc_signer #(
    parameter integer SIGNS = 8, // valid values are 2, 4, 8
    parameter integer NUM_WORDS = 1024
) (
    input  wire logic [SIGNS-1:0] i_in_data,
    output      logic             o_out_data,
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

generate

if (SIGNS == 8) begin: sign8
    logic sign_abcd_r0;
    logic sign_efgh_r0;

    logic sign_abcdefgh_r1;

    always_ff @(posedge i_clock) begin
        if(i_reset) begin
            sign_abcd_r0 <= 1'b0;
            sign_efgh_r0 <= 1'b0;
            sign_abcdefgh_r1 <= 1'b0;
            o_out_data <= 0;
        end else begin
            // Stage 0
            sign_abcd_r0 <= ^(i_in_data[3:0]);
            sign_efgh_r0 <= ^(i_in_data[7:4]);
            // Stage 1
            sign_abcdefgh_r1 <= sign_abcd_r0 ^ sign_efgh_r0;
            // Stage 2
            o_out_data <= sign_abcdefgh_r1;
        end
    end
end // sign8

if (SIGNS == 4) begin: sign4
    logic sign_abcd_r0;
    logic sign_abcd_r1;

    always_ff @(posedge i_clock) begin
        if(i_reset) begin
            sign_abcd_r0 <= 1'b0;
            sign_abcd_r1 <= 1'b0;
            o_out_data <= 0;
        end else begin
            // Stage 0
            sign_abcd_r0 <= ^(i_in_data[3:0]);
            // Stage 1
            sign_abcd_r1 <= sign_abcd_r0;
            // Stage 2
            o_out_data <= sign_abcd_r1;
        end
    end
end // sign4

if (SIGNS == 2) begin: sign2
    logic sign_abcd_r0;
    logic sign_abcd_r1;

    always_ff @(posedge i_clock) begin
        if(i_reset) begin
            sign_abcd_r0 <= 1'b0;
            sign_abcd_r1 <= 1'b0;
            o_out_data <= 0;
        end else begin
            // Stage 0
            sign_abcd_r0 <= i_in_data[0] ^ i_in_data[1];
            // Stage 1
            sign_abcd_r1 <= sign_abcd_r0;
            // Stage 2
            o_out_data <= sign_abcd_r1;
        end
    end
end // sign2

endgenerate

endmodule: ldpc_signer

`default_nettype wire
