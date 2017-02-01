//-----------------------------------------------------
// Design Name : comp_mult
// File Name   : comp_mult.v
// Authors     : Anurag Goyal
// Function    : To compute complex multiplication. Output is given on the next clock
// Reference: http://mathworld.wolfram.com/ComplexMultiplication.html
//-----------------------------------------------------
`default_nettype none
module comp_mult
#(
    parameter INPUT_WIDTH_I = 18,
    parameter INPUT_WIDTH_II = 18,
    parameter OUTPUT_WIDTH = 18,
    parameter WRAP_SATURATE = 1, // WRAP == 0; SATURATE == 1
    parameter CAL_WIDTH = INPUT_WIDTH_I + INPUT_WIDTH_II + 1 // result width for i_a * i_c
    // parameter dummy_pos = {{(CAL_WIDTH + 4 - (OUTPUT_WIDTH-1)){1'b0}}, {(OUTPUT_WIDTH-1){1'b1}}},
    // parameter dummy_neg = {{(CAL_WIDTH + 4 - (OUTPUT_WIDTH-1)){1'b1}}, {(OUTPUT_WIDTH-1){1'b0}}}
)
(
    // inputs
    input wire signed   [INPUT_WIDTH_I - 1 : 0]     i_a, // real part of I input
    input wire signed   [INPUT_WIDTH_I - 1 : 0]     i_b, // imaginary part of I input
    input wire signed   [INPUT_WIDTH_II - 1 : 0]    i_c, // real part of II input
    input wire signed   [INPUT_WIDTH_II - 1 : 0]    i_d, // imaginary part of II input
    input wire signed   [0:0]                       i_clk,
    input wire signed   [0:0]                       i_rst_p,
    input wire          [0:0]                       i_valid_data,
    // outputs
    output reg signed   [OUTPUT_WIDTH - 1 : 0]      o_r,
    output reg signed   [OUTPUT_WIDTH - 1 : 0]      o_im,
    output reg          [0:0]                       o_valid_data
);
reg signed  [INPUT_WIDTH_I - 1 : 0]     A;
reg signed  [INPUT_WIDTH_I - 1 : 0]     B;
reg signed  [INPUT_WIDTH_II - 1 : 0]    C;
reg signed  [INPUT_WIDTH_II - 1 : 0]    D;
reg signed [INPUT_WIDTH_I : 0]      A_plus_B;
reg signed [INPUT_WIDTH_II : 0]     C_plus_D;
reg signed [CAL_WIDTH + 3 - 1 : 0]  A_plus_B_times_C_plus_D;
reg signed [CAL_WIDTH - 1 : 0]      AC;
reg signed [CAL_WIDTH - 1 : 0]      BD;

reg signed [CAL_WIDTH + 4 - 1 : 0]  z_r;
reg signed [CAL_WIDTH + 4 - 1 : 0]  z_im;
wire signed [CAL_WIDTH + 4 - 1 : 0] dummy_pos;
wire signed [CAL_WIDTH + 4 - 1 : 0] dummy_neg;

assign dummy_pos = {{(CAL_WIDTH + 4 - (OUTPUT_WIDTH-1)){1'b0}}, {(OUTPUT_WIDTH-1){1'b1}}};
assign dummy_neg = {{(CAL_WIDTH + 4 - (OUTPUT_WIDTH-1)){1'b1}}, {(OUTPUT_WIDTH-1){1'b0}}};

reg valid_data;
reg valid_valid_data;
reg valid_valid_valid_data;

always @(posedge i_clk)
begin
    if (i_rst_p)
    begin
        AC <= 0;
        BD <= 0;
        o_valid_data <= 0;
        valid_data <= 0;
        valid_valid_data <= 0;
        valid_valid_valid_data <= 0;
        o_r <= 0;
        o_im <= 0;
        z_r <= 0;
        z_im <= 0;
        A_plus_B <= 0;
        C_plus_D <= 0;
        A <= 0;
        B <= 0;
        C <= 0;
        D <= 0;
    end
    else
    begin
        // First stage
        if (i_valid_data)
        begin
            A_plus_B <= i_a + i_b;
            C_plus_D <= i_c + i_d;
            A <= i_a;
            B <= i_b;
            C <= i_c;
            D <= i_d;
        end
        valid_valid_valid_data <= i_valid_data;

        // second stage
        if (valid_valid_valid_data)
        begin
            AC <= A * C;
            BD <= B * D;
            A_plus_B_times_C_plus_D <= A_plus_B * C_plus_D;
        end
        valid_data <= valid_valid_valid_data;

        // third stage
        if (valid_data)
        begin
            z_r <= AC - BD;
            z_im <= A_plus_B_times_C_plus_D - AC - BD;
        end
        valid_valid_data <= valid_data;

        // fourth stage
        if (valid_valid_data)
        begin
            if (WRAP_SATURATE)
            begin
                if (z_r > dummy_pos) // z_r > 3
                begin
                    o_r <= {1'b0, {(OUTPUT_WIDTH-1){1'b1}}};
                    // synopsys translate_off
                    $display ("+ve");
                    // synopsys translate_on
                end
                else if (z_r < dummy_neg) // z_r < -4
                begin
                    o_r <= {1'b1, {(OUTPUT_WIDTH-1){1'b0}}};
                    // synopsys translate_off
                    $display ("-ve");
                    // synopsys translate_on
                end
                else
                begin
                    o_r <= {z_r[CAL_WIDTH + 4 - 1], z_r [OUTPUT_WIDTH-2:0]};
                    // synopsys translate_off
                    $display ("nothing");
                    // synopsys translate_on
                end

                if (z_im > dummy_pos)
                begin
                    o_im <= {1'b0, {(OUTPUT_WIDTH-1){1'b1}}};
                end
                else if (z_im < dummy_neg) // z_r < -4
                begin
                    o_im <= {1'b1, {(OUTPUT_WIDTH-1){1'b0}}};
                end
                else
                begin
                    o_im <= {z_im[CAL_WIDTH + 4 - 1], z_im [OUTPUT_WIDTH-2:0]};
                end
            end
            else
            begin
                o_r <= {z_r[CAL_WIDTH + 4 - 1], z_r [OUTPUT_WIDTH-2:0]};
                o_im <= {z_im[CAL_WIDTH + 4 - 1], z_im [OUTPUT_WIDTH-2:0]};
            end
        end
        o_valid_data <= valid_valid_data;
        // o_r <= {z_r[CAL_WIDTH + 4 - 1], z_r [OUTPUT_WIDTH-2:0]};
        // o_im <= {z_im[CAL_WIDTH + 4 - 1], z_im [OUTPUT_WIDTH-2:0]};
    end
end

endmodule

`default_nettype wire