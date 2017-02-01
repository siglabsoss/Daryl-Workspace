//-----------------------------------------------------
// Design Name : comp_mult_tb
// File Name   : comp_mult_tb.v
// Authors     : Anurag Goyal
// Function    : To check functionality of the complex multiplier
//-----------------------------------------------------
`timescale 1ns/100ps
module tb;
parameter INPUT_WIDTH_I = 4;
parameter INPUT_WIDTH_II = 4;
parameter OUTPUT_WIDTH = 4;
parameter WRAP_SATURATE = 1; // WRAP == 0; SATURATE == 1

reg signed  [INPUT_WIDTH_I - 1 : 0]     i_a; // real part of I input
reg signed  [INPUT_WIDTH_I - 1 : 0]     i_b; // imaginary part of I input
reg signed  [INPUT_WIDTH_II - 1 : 0]    i_c; // real part of II input
reg signed  [INPUT_WIDTH_II - 1 : 0]    i_d; // imaginary part of II input
reg signed  [0:0]                       i_clk;
reg signed  [0:0]                       i_rst_p;
reg signed  [0:0]                       i_valid_data;

wire signed [OUTPUT_WIDTH - 1 : 0]      o_r;
wire signed [OUTPUT_WIDTH - 1 : 0]      o_im;
wire signed [0:0]                       o_valid_data;

comp_mult
#(
    .INPUT_WIDTH_I  (INPUT_WIDTH_I),
    .INPUT_WIDTH_II (INPUT_WIDTH_II),
    .OUTPUT_WIDTH   (OUTPUT_WIDTH),
    .WRAP_SATURATE  (WRAP_SATURATE)// WRAP == 0; SATURATE == 1
) UUT
(
    // inputs
    .i_a(i_a), // real part of I input
    .i_b(i_b), // imaginary part of I input
    .i_c(i_c), // real part of II input
    .i_d(i_d), // imaginary part of II input
    .i_clk(i_clk),
    .i_rst_p(i_rst_p),
    .i_valid_data(i_valid_data),
    .o_r(o_r),
    .o_im(o_im),
    .o_valid_data(o_valid_data)
);
integer counter;
initial i_clk = 0;
always #5 i_clk = !i_clk;

initial
begin
    i_rst_p = 0;
    counter <= 0;
    #1;
    i_rst_p = 1;
    i_a = 0;
    i_b = 0;
    i_c = 0;
    i_d = 0;
    i_valid_data = 0;
    #10;
    i_rst_p = 0;

    while (counter != 20)
    begin
    #10;
        i_a = $random % (1<<INPUT_WIDTH_I );
        i_b = $random % (1<<INPUT_WIDTH_I );
        i_c = $random % (1<<INPUT_WIDTH_II);
        i_d = $random % (1<<INPUT_WIDTH_II);
        i_valid_data = 1;
        counter <= counter + 1;
    end
    #10;
    $stop;
end
endmodule