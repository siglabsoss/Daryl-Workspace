// tb_ldpc_minsigner.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_ldpc_minsigner;

logic [7:0] i_data_a0;
logic [7:0] i_data_a1;
logic [7:0] i_data_a2;
logic [7:0] i_data_a3;
logic [7:0] i_data_a4;
logic [7:0] i_data_a5;
logic       i_valid;
logic [7:0] o_data_a0;
logic [7:0] o_data_a1;
logic [7:0] o_data_a2;
logic [7:0] o_data_a3;
logic [7:0] o_data_a4;
logic [7:0] o_data_a5;
logic       o_valid;
logic       i_clock;
logic       i_reset;

ldpc_minsigner uut (.*);

always begin: clock_gen
    #5 i_clock = 1'b1;
    #5 i_clock = 1'b0;
end

// debug variable declarations
logic [31:0] glbl_err_count = 0;
logic [31:0] test_number = 1;
logic [31:0] run_count = 0;

// Used by check process, declared here so it
// can be included in the final tall for the
// global error count.
logic [31:0] local_err_count = 0;

task reset_all;
    i_data_a0 = 0;
    i_data_a1 = 0;
    i_data_a2 = 0;
    i_data_a3 = 0;
    i_data_a4 = 0;
    i_data_a5 = 0;
    i_valid = 0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

localparam logic [7:0] input_llr_vecs [0:3] = {
    { 8'(-11), 8'(-20), 8'(30), 8'(-40), 8'(-106), 8'(100) },
    { 8'( 11), 8'( 20), 8'(30), 8'( 40), 8'(  50), 8'( 10) },
    { 8'(-11), 8'( -2), 8'(-2), 8'(-10), 8'( -50), 8'(-10) },
    { 8'( 11), 8'( 12), 8'(-1), 8'( 33), 8'(  24), 8'( 12) }
};

localparam logic [7:0] output_llr_vecs [0:3] = {
    { 8'(-20), 8'(-11), 8'(11), 8'(-11), 8'(-11), 8'( 11) },
    { 8'( 10), 8'( 10), 8'(10), 8'( 10), 8'( 10), 8'( 11) },
    { 8'( -2), 8'( -2), 8'(-2), 8'( -2), 8'( -2), 8'( -2) },
    { 8'( -1), 8'( -1), 8'(11), 8'( -1), 8'( -1), 8'( -1) }
};

initial begin: stimulus
    i_reset = 1'b1;
    #1000;
    reset_all();

    // Test 1: No data in = no data out.
    $display("Test 1 Started!");
    test_number = 1;
    reset_all();
    #1000;
    @(negedge i_clock) begin
        i_data_a0 = -11;  // output = -20
        i_data_a1 = -20;  // output = -11
        i_data_a2 = 30;   // output = 11
        i_data_a3 = -40;  // output = -11
        i_data_a4 = -106; // output = -11
        i_data_a5 = 100;  // output = 11
        i_valid = 1'b0;
        #10;
    end
    #10000;
    if (run_count != 0) begin
        $display("Error: Expected 4 outputs, received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

    // Test 2: Basic operation on a single input.
    $display("Test 2 Started!");
    test_number = 2;
    reset_all();
    #1000;
    @(negedge i_clock) begin
        i_data_a0 = -11;  // output = -20
        i_data_a1 = -20;  // output = -11
        i_data_a2 = 30;   // output = 11
        i_data_a3 = -40;  // output = -11
        i_data_a4 = -106; // output = -11
        i_data_a5 = 100;  // output = 11
        i_valid = 1'b1;
        #10;
    end
    i_valid = 1'b0;
    #10000;
    if (run_count != 1) begin
        $display("Error: Expected 1 output, received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 2 Done!");

    // Test 3: Pipelined operations on multiple inputs.
    $display("Test 3 Started!");
    test_number = 3;
    reset_all();
    #1000;
    for (integer index = 0; index < 4; index++) begin
        @(negedge i_clock) begin
            i_data_a0 = input_llr_vecs[0][0];
            i_data_a1 = input_llr_vecs[0][1];
            i_data_a2 = input_llr_vecs[0][2];
            i_data_a3 = input_llr_vecs[0][3];
            i_data_a4 = input_llr_vecs[0][4];
            i_data_a5 = input_llr_vecs[0][5];
            i_valid = 1'b1;
            #10;
        end
    end
    i_valid = 1'b0;
    #10000;
    if (run_count != 1) begin
        $display("Error: Expected 1 output, received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 3 Done!");

    // Finished
    #10000;
    glbl_err_count = glbl_err_count + local_err_count;
    $display("Simulation done!");
    $finish();

end

// Tests the output sequence to make sure it matches the input
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        run_count <= 0;
    end else begin
        // Track number of outputs received
        if (o_valid == 1'b1) begin
            // Count number of outputs
            run_count <= run_count + 1;

            // Test data vectors
            if (test_number == 2) begin
                if ($signed(o_data_a0) == -20) begin
                    $display("Data error: Expected output a0 = -20, but received %d.", o_data_a0);
                    local_err_count = local_err_count + 1;
                end
                if ($signed(o_data_a1) == -11) begin
                    $display("Data error: Expected output a1 = -11, but received %d.", o_data_a1);
                    local_err_count = local_err_count + 1;
                end
                if ($signed(o_data_a2) == 11) begin
                    $display("Data error: Expected output a2 = 11, but received %d.", o_data_a2);
                    local_err_count = local_err_count + 1;
                end
                if ($signed(o_data_a3) == -11) begin
                    $display("Data error: Expected output a3 = -11, but received %d.", o_data_a3);
                    local_err_count = local_err_count + 1;
                end
                if ($signed(o_data_a4) == -11) begin
                    $display("Data error: Expected output a4 = -11, but received %d.", o_data_a4);
                    local_err_count = local_err_count + 1;
                end
                if ($signed(o_data_a5) == 11) begin
                    $display("Data error: Expected output a5 = 11, but received %d.", o_data_a5);
                    local_err_count = local_err_count + 1;
                end
            end
        end
    end
end

endmodule: tb_ldpc_minsigner

`default_nettype wire
