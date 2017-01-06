// tb_skid.sv
//
// Rudimentary tests for skid buffer.
//

`timescale 10ps / 10ps

`default_nettype none

module tb_dual_diagonal_backsub;

localparam integer WIDTH = 16;
localparam integer NUM_WORDS = 8;

// Clock and Reset
logic                i_clock;
logic                i_reset;
// Upstream signaling
logic [WIDTH-1:0]    i_in_data;
logic                i_in_valid;
// Downstream signaling
logic [WIDTH-1:0]    o_out_data;
logic                o_out_valid;

dual_diagonal_backsub #(
    .WIDTH(WIDTH),
    .NUM_WORDS(NUM_WORDS))
uut (.*);

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
    i_reset = 1'b1;
    i_in_data = 0;
    i_in_valid = 1'b0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

logic [WIDTH-1:0] input_values [0:NUM_WORDS-1] = {
    37449,
    56173,
    28086,
    46811,
    56173,
    28086,
    46811,
    56173
};

logic [WIDTH-1:0] output_values [0:NUM_WORDS-1] = {
    37449,
    18724,
     9362,
    37449,
    18724,
     9362,
    37449,
    18724
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
        i_in_valid = 1'b0;
        #(NUM_WORDS*10);
    end
    i_in_valid = 1'b0;
    #1000;
    if (run_count > 0) begin
        $display("Error: Test 1 failed! No data input, but data output received.");
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

    // Test 2: All zeros in = all zeros out.
    $display("Test 2 Started!");
    test_number = 2;
    reset_all();
    #1000;
    @(negedge i_clock) begin
        i_in_data = 0;
        i_in_valid = 1'b1;
        #(NUM_WORDS*10);
    end
    i_in_valid = 1'b0;
    #10000;
    if (run_count != NUM_WORDS) begin
        $display("Error: Test 2 failed! Expected %d outputs, but %d outputs received.", NUM_WORDS, run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 2 Done!");

    // Test 3: All zeros in = all zeros out.
    $display("Test 3 Started!");
    test_number = 3;
    reset_all();
    #1000;
    for (integer count = 0; count < NUM_WORDS; count = count + 1) begin
        @(negedge i_clock) begin
            i_in_data = input_values[count];
            i_in_valid = 1'b1;
        end
        #10;
    end
    i_in_valid = 1'b0;
    #10000;
    if (run_count != NUM_WORDS) begin
        $display("Error: Test 3 failed! Expected %d outputs, but %d outputs received.", NUM_WORDS, run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 3 Done!");

    // Test 4: All zeros in = all zeros out.
    $display("Test 4 Started!");
    test_number = 4;
    reset_all();
    #1000;
    for (integer count = 0; count < NUM_WORDS; count = count + 1) begin
        @(negedge i_clock) begin
            i_in_data = input_values[count];
            i_in_valid = 1'b1;
        end
        #10;
    end
    for (integer count = 0; count < NUM_WORDS; count = count + 1) begin
        @(negedge i_clock) begin
            i_in_data = input_values[count];
            i_in_valid = 1'b1;
        end
        #10;
    end
    i_in_valid = 1'b0;
    #10000;
    if (run_count != 2*NUM_WORDS) begin
        $display("Error: Test 4 failed! Expected %d outputs, but %d outputs received.", 2*NUM_WORDS, run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 4 Done!");

    // Finished
    glbl_err_count <= glbl_err_count + local_err_count;
    #10000;
    $display("Simulation done!");
    $finish();

end

// Tests the output sequence to make sure it matches the input
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        run_count <= 0;
    end else begin
        // Validate all zero sequence
        if ((o_out_valid == 1'b1) && (test_number == 2)) begin
            if (o_out_data != 0) begin
                $display("Error: Output of 0 expected, but received %d.", o_out_data);
                local_err_count++;
            end
        end
        // Validate all zero sequence
        if ((o_out_valid == 1'b1) && (test_number == 3)) begin
            if (o_out_data != output_values[run_count]) begin
                $display("Error: Output of %d expected, but received %d.", output_values[run_count], o_out_data);
                local_err_count++;
            end
        end
        // Validate all zero sequence
        if ((o_out_valid == 1'b1) && (test_number == 3)) begin
            if (o_out_data != output_values[run_count % NUM_WORDS]) begin
                $display("Error: Output of %d expected, but received %d.", output_values[run_count], o_out_data);
                local_err_count++;
            end
        end
        // Track number of outputs received
        if (o_out_valid == 1'b1) begin
            run_count <= run_count + 1;
        end
    end
end

// Do this in your test bench
initial begin
    $dumpfile("dual_diagonal_backsub.vcd");
    $dumpvars;
end

endmodule: tb_dual_diagonal_backsub

`default_nettype wire
