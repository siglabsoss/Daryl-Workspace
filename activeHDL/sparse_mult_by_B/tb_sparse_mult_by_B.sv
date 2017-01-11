// tb_sparse_mult_by_B.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_sparse_mult_by_B;

localparam integer WIDTH = 96;

// Clock and Reset
logic             i_clock;
logic             i_reset;
// Upstream signaling
logic [WIDTH-1:0] i_input_data;
logic             i_input_valid;
logic             o_input_ready;
// Downstream signaling
logic [WIDTH-1:0] o_output_data;
logic             o_output_valid;
logic             i_output_ready;

sparse_mult_by_B #(.WIDTH(WIDTH)) uut (.*);

always begin: clock_gen
    #5 i_clock = 1'b1;
    #5 i_clock = 1'b0;
end

localparam integer INPUT_LEN = 1;
localparam integer OUTPUT_LEN = 11;

logic [WIDTH/3-1:0] input_samples_low [0:5*INPUT_LEN-1] = {
    1090555976, 1225036360, 81927, 0, 0
};

logic [WIDTH/3-1:0] input_samples_mid [0:5*INPUT_LEN-1] = {
    302579842, 306782352, 1075843087, 0, 0
};

logic [WIDTH/3-1:0] input_samples_high [0:5*INPUT_LEN-1] = {
    545277988, 612518176, 1073938560, 0, 2147483648
};

logic [WIDTH/3-1:0] output_samples_low [0:5*OUTPUT_LEN-1] = {
    2152211472, 0, 0, 0, 0, 1090555976, 0, 0, 0, 0, 0,
    2185831442, 0, 0, 0, 0, 1225036360, 0, 0, 0, 0, 0,
    10486688, 0, 0, 0, 0, 81927, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

logic [WIDTH/3-1:0] output_samples_mid [0:5*OUTPUT_LEN-1] = {
    75514144, 0, 0, 0, 0, 302579842, 0, 0, 0, 0, 0,
    613435428, 0, 0, 0, 0, 306782352, 0, 0, 0, 0, 0,
    268961664, 0, 0, 0, 0, 1075843087, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

logic [WIDTH/3-1:0] output_samples_high [0:5*OUTPUT_LEN-1] = {
    1076105737, 0, 0, 0, 0, 545277988, 0, 0, 0, 0, 0,
    1092915209, 0, 0, 0, 0, 612518176, 0, 0, 0, 0, 0,
    25182240, 0, 0, 0, 0, 1073938560, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 2147483648, 0, 0, 0, 0, 0
};

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
    i_input_data = 0;
    i_input_valid = 1'b0;
    i_output_ready = 1'b0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

integer loop_count = 0;
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
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #1000;
    end
    i_input_valid = 1'b0;
    i_output_ready = 1'b0;
    #1000;
    if (run_count > 0) begin
        $display("Error: Test 1 failed! No data input, but data output received.");
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

    $display("Test 2 Started!");
    test_number = 2;
    reset_all();
    #1000;
    @(negedge i_clock) begin
        i_input_valid = 1'b1;
        i_output_ready = 1'b0;
        #10;
    end
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #2000;
    end
    i_input_valid = 1'b0;
    i_output_ready = 1'b0;
    #10000;
    if (run_count != OUTPUT_LEN) begin
        $display("Error: Test 2 failed! Expected 11 data words, but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 2 Done!");

    $display("Test 3 Started!");
    test_number = 3;
    reset_all();
    #1000;
    i_output_ready = 1'b1;
    #10;
    for (integer idx = 0; idx < INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #2000;
    end
    i_input_valid = 1'b0;
    i_output_ready = 1'b0;
    #10000;
    if (run_count != OUTPUT_LEN) begin
        $display("Error: Test 3 failed! Expected 11 data words, but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 3 Done!");

    $display("Test 4 Started!");
    test_number = 4;
    reset_all();
    #1000;
    i_output_ready = 1'b1;
    #10;
    for (integer idx = 0; idx < INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 0
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #2000;
    end
    for (integer idx = INPUT_LEN; idx < 2*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 1
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    i_input_valid = 1'b0;
    loop_count = 0;
    while((o_input_ready != 1'b1) && loop_count < 1000) #10 loop_count = loop_count + 1;
    for (integer idx = 2*INPUT_LEN; idx < 3*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 2
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    i_input_valid = 1'b0;
    loop_count = 0;
    while((o_input_ready != 1'b1) && loop_count < 1000) #10 loop_count = loop_count + 1;
    for (integer idx = 3*INPUT_LEN; idx < 4*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 3
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    i_input_valid = 1'b0;
    loop_count = 0;
    while((o_input_ready != 1'b1) && loop_count < 1000) #10 loop_count = loop_count + 1;
    for (integer idx = 4*INPUT_LEN; idx < 5*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 4
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    i_input_valid = 1'b0;
    loop_count = 0;
    while((o_input_ready != 1'b1) && loop_count < 1000) #10 loop_count = loop_count + 1;
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #200000;
    end
    i_input_valid = 1'b0;
    i_output_ready = 1'b0;
    #10000;
    if (run_count != 5*OUTPUT_LEN) begin
        $display("Error: Test 4 failed! Expected 55 data words, but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 4 Done!");

    $display("Test 5 Started!");
    test_number = 5;
    reset_all();
    #1000;
    i_output_ready = 1'b1;
    #10;
    for (integer idx = 0; idx < INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 0
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #2000;
    end
    for (integer idx = INPUT_LEN; idx < 2*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 1
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #200;
    end
    for (integer idx = 2*INPUT_LEN; idx < 3*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 2
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #200;
    end
    for (integer idx = 3*INPUT_LEN; idx < 4*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 3
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #200;
    end
    for (integer idx = 4*INPUT_LEN; idx < 5*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 4
            i_input_data = {
                input_samples_high[idx],
                input_samples_mid[idx],
                input_samples_low[idx]
            };
            i_input_valid = 1'b1;
            #10;
        end
    end
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #200000;
    end
    i_input_valid = 1'b0;
    i_output_ready = 1'b0;
    #10000;
    if (run_count != 5*OUTPUT_LEN) begin
        $display("Error: Test 5 failed! Expected 55 data words, but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 5 Done!");

    // Finished
    #10000;
    glbl_err_count <= glbl_err_count + local_err_count;
    $display("Simulation done!");
    $finish();

end

// Tests the output sequence to make sure it matches the input
logic [31:0] pass_count;
logic [WIDTH-1:0] expected_value;
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        run_count <= 0;
        pass_count <= 0;
    end else begin
        // Track number of outputs received
        if ((o_output_valid == 1'b1) && (i_output_ready == 1'b1)) begin
            // Make sure data for test 2 is valid (all zeros)
            if (test_number == 2) begin
                if (o_output_data != 0) begin
                    local_err_count = local_err_count + 1;
                    $display("Data error. Test 2 expects all zeros, but received %d.", o_output_data);
                end
            end
            // Make sure data for test 3 is valid
            if (test_number == 3) begin
                expected_value = {
                    output_samples_high[run_count],
                    output_samples_mid[run_count],
                    output_samples_low[run_count]
                };
                if (o_output_data != expected_value) begin
                    local_err_count = local_err_count + 1;
                    $display("Data error. Test 3 expects %b, but received %b.", expected_value, o_output_data);
                end
            end
            // Make sure data for tests 4 and 5 is valid
            if ((test_number == 4) || (test_number == 5)) begin
                if (pass_count == 3) begin
                    expected_value = 0;
                end else if (run_count < 5 * OUTPUT_LEN) begin
                    expected_value = {
                        output_samples_high[run_count],
                        output_samples_mid[run_count],
                        output_samples_low[run_count]
                    };
                end else begin
                    expected_value = 'x;
                end
                if (o_output_data != expected_value) begin
                    local_err_count = local_err_count + 1;
                    $display("Data error on pass %d of test %d. (run_count = %d)", pass_count, test_number, run_count);
                    $display("Expects %b, but received %b.", expected_value, o_output_data);
                end
                if (run_count % OUTPUT_LEN == OUTPUT_LEN-1) begin
                    pass_count = pass_count + 1;
                end
            end
            // Increment the run count
            run_count <= run_count + 1;
        end
    end
end

endmodule: tb_sparse_mult_by_B

`default_nettype wire
