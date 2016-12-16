/*****************************************************
    TEST TO VERIFY ICARUS VERILOG SIMULATOR WORKS
    WITH SYSTEMVERILOG CONSTRUCTS.
******************************************************/

`timescale 10ps/10ps

`default_nettype none

module test;

// Behavioral/Combinatorial Test
logic a_value;
logic b_value;
logic c_value;
logic d_value;

always @ (a_value, b_value) begin
    c_value = a_value ^ b_value;
end

always @ (*) begin
    d_value = a_value ^ b_value;
end

// Primitive Instantiation Test
logic z_value;

LUT4 #(
    .init(16'b1010101010101010))
lut4_inst (
    .A(a_value),
    .B(b_value),
    .C(c_value),
    .D(d_value),
    .Z(z_value));

// Stimulus/Test Logic
integer error_count = 0;
initial begin
    // Even parity test
    a_value = 1'b1;
    b_value = 1'b1;

    // C = A ^ B
    if (c_value != 1'b0) begin
        $display("c_value is incorrect! (%b != %b)", c_value, 1'b0);
        error_count++;
    end

    // D = A ^ B
    if (d_value != 1'b0) begin
        $display("d_value is incorrect! (%b != %b)", d_value, 1'b0);
        error_count++;
    end

    // Configured to test for an odd number of ones in A, B, C, D
    if (z_value != 1'b0) begin
        $display("LUT test failed! (%b != %b)", z_value, 1'b0);
        error_count++;
    end

    // Odd parity test
    a_value = 1'b1;
    b_value = 1'b0;

    // C = A ^ B
    if (c_value != 1'b1) begin
        $display("c_value is incorrect! (%b != %b)", c_value, 1'b0);
        error_count++;
    end

    // D = A ^ B
    if (d_value != 1'b1) begin
        $display("d_value is incorrect! (%b != %b)", d_value, 1'b0);
        error_count++;
    end

    // Configured to test for an odd number of ones in A, B, C, D
    if (z_value != 1'b1) begin
        $display("LUT test failed! (%b != %b)", z_value, 1'b0);
        error_count++;
    end

    // Finished
    $display("Done testing...");
    $finish();
end


endmodule: test

`default_nettype wire