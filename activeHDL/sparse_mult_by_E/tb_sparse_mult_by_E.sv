// tb_sparse_mult_by_A.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_sparse_mult_by_E;

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

sparse_mult_by_E #(.WIDTH(WIDTH)) uut (.*);

always begin: clock_gen
    #5 i_clock = 1'b1;
    #5 i_clock = 1'b0;
end

localparam integer INPUT_LEN = 11;
localparam integer OUTPUT_LEN = 1;

logic [WIDTH/3-1:0] input_samples_low [0:5*INPUT_LEN-1] = {
    2097153, 1073742336, 262144, 134217792, 32768, 16777224,
    4096, 2097153, 1073742336, 262144, 134217792,

    12345, 67890, 2468, 369, 48, 0, 1, 2, 3, 4, 69696969,

    9753, 73236, 21614, 1117191, 31111, 237, 96, 213,
    136631, 250250, 250250,

    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

    123, 246, 123000, 246000, 1346, 12, 96, 53, 36, 44, 0
};

logic [WIDTH/3-1:0] input_samples_mid [0:5*INPUT_LEN-1] = {
    2147484672, 524288, 268435584, 65536, 33554448, 8192,
    4194306, 2147484672, 524288, 268435584, 65536,

    2144842, 5228, 264584, 656, 354, 892, 44306, 1234546,
    524286, 268435583, 65535,

    21472, 588, 284, 636, 348, 892, 906, 272, 584, 25582,
    65534,

    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

    2147484672, 524288, 268435584, 65536, 33554448, 8192,
    41943, 2184672, 524280, 268435580, 65532
};

logic [WIDTH/3-1:0] input_samples_high [0:5*INPUT_LEN-1] = {
    1048576, 536871168, 131072, 67108896, 16384, 8388612,
    2048, 1048576, 536871168, 131072, 67108896,

    1, 8, 2, 6, 4, 2, 8, 6, 1, 72, 96,

    1048576, 536871168, 131072, 67108896, 16384, 8388612,
    2048, 1048576, 536871168, 131072, 67108896,

    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

    308576, 53, 131, 6710, 163, 832, 2048, 1048, 5368, 131,
    67108
};

logic [WIDTH/3-1:0] output_samples_low [0:5*OUTPUT_LEN-1] = {
    134217792, 69696969, 250250, 0, 0
};

logic [WIDTH/3-1:0] output_samples_mid [0:5*OUTPUT_LEN-1] = {
    65536, 65535, 65534, 0, 65532
};

logic [WIDTH/3-1:0] output_samples_high [0:5*OUTPUT_LEN-1] = {
    67108896, 96, 67108896, 0, 67108
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
        #110;
    end
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #2000;
    end
    i_input_valid = 1'b0;
    i_output_ready = 1'b0;
    #10000;
    if (run_count != 1) begin
        $display("Error: Test 2 failed! Expected 1 data word, but received %d.", run_count);
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
    if (run_count != 1) begin
        $display("Error: Test 3 failed! Expected 1 data word, but received %d.", run_count);
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
    if (run_count != 5) begin
        $display("Error: Test 4 failed! Expected 5 data words, but received %d.", run_count);
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
    if (run_count != 5) begin
        $display("Error: Test 4 failed! Expected 5 data words, but received %d.", run_count);
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

endmodule: tb_sparse_mult_by_E

`default_nettype wire
