// tb_sparse_mult_by_A.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_sparse_mult_by_A;

localparam integer IN_WIDTH = 8;
localparam integer OUT_WIDTH = 96;

// Clock and Reset
logic                 i_clock;
logic                 i_reset;
// Upstream signaling
logic [IN_WIDTH-1:0]  i_input_data;
logic                 i_input_valid;
logic                 o_input_ready;
// Downstream signaling
logic [OUT_WIDTH-1:0] o_output_data;
logic                 o_output_valid;
logic                 i_output_ready;

sparse_mult_by_A #(
    .IN_WIDTH(IN_WIDTH),
    .OUT_WIDTH(OUT_WIDTH))
uut (.*);

always begin: clock_gen
    #5 i_clock = 1'b1;
    #5 i_clock = 1'b0;
end

localparam integer INPUT_LEN = 144;
localparam integer OUTPUT_LEN = 11;

logic [IN_WIDTH-1:0] input_samples [0:5*INPUT_LEN-1] = {
    1, 8, 66, 0, 6, 16, 136, 0, 20, 32, 32, 1, 72, 64, 128, 2, 16,
    129, 0, 6, 32, 4, 1, 8, 64, 16, 2, 48, 128, 64, 4, 160, 0, 1,
    9, 64, 2, 2, 20, 128, 8, 4, 48, 0, 33, 8, 64, 0, 130, 16, 128,
    1, 4, 34, 0, 5, 8, 72, 0, 18, 16, 160, 0, 68, 32, 128, 1, 8,
    65, 0, 2, 16, 132, 0, 12, 32, 16, 1, 40, 64, 64, 2, 144, 128,
    0, 5, 32, 2, 1, 12, 64, 8, 2, 16, 128, 32, 4, 96, 0, 129, 8,
    64, 1, 2, 18, 128, 4, 4, 40, 0, 17, 8, 96, 0, 66, 16, 128, 0,
    4, 33, 0, 3, 8, 68, 0, 10, 16, 144, 0, 36, 32, 64, 1, 136, 64,
    0, 3, 16, 130, 0, 4, 32, 8, 1,

    89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53,
    89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53,
    89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53,
    89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53,
    89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53,
    89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53,
    89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53,
    89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53,
    89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53, 89, 147, 53,
    89, 147, 53, 89, 147, 53, 89, 147, 53,

    1, 0, 32, 0, 0, 4, 0, 128, 0, 0, 16, 0, 0, 2, 0, 64, 0, 0, 8, 0, 0,
    1, 0, 32, 0, 0, 4, 0, 128, 0, 0, 16, 0, 0, 2, 0, 64, 0, 0, 8, 0, 0,
    1, 0, 32, 0, 0, 4, 0, 128, 0, 0, 16, 0, 0, 2, 0, 64, 0, 0, 8, 0, 0,
    1, 0, 32, 0, 0, 4, 0, 128, 0, 0, 16, 0, 0, 2, 0, 64, 0, 0, 8, 0, 0,
    1, 0, 32, 0, 0, 4, 0, 128, 0, 0, 16, 0, 0, 2, 0, 64, 0, 0, 8, 0, 0,
    1, 0, 32, 0, 0, 4, 0, 128, 0, 0, 16, 0, 0, 2, 0, 64, 0, 0, 8, 0, 0,
    1, 0, 32, 0, 0, 4, 0, 128, 0, 0, 16, 0, 0, 2, 0, 64, 0, 0,

    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

    1, 8, 66, 0, 6, 16, 136, 0, 20, 32, 32, 1, 72, 64, 128, 2, 16,
    129, 0, 6, 32, 4, 1, 8, 64, 16, 2, 48, 128, 64, 4, 160, 0, 1,
    9, 64, 2, 2, 20, 128, 8, 4, 48, 0, 33, 8, 64, 0, 130, 16, 128,
    1, 4, 34, 0, 5, 8, 72, 0, 18, 16, 160, 0, 68, 32, 128, 1, 8,
    65, 0, 2, 16, 132, 0, 12, 32, 16, 1, 40, 64, 64, 2, 144, 128,
    0, 5, 32, 2, 1, 12, 64, 8, 2, 16, 128, 32, 4, 96, 0, 129, 8,
    64, 1, 2, 18, 128, 4, 4, 40, 0, 17, 8, 96, 0, 66, 16, 128, 0,
    4, 33, 0, 3, 8, 68, 0, 10, 16, 144, 0, 36, 32, 64, 1, 136, 64,
    0, 3, 16, 130, 0, 4, 32, 8, 1
};

logic [OUT_WIDTH/3-1:0] output_samples_low [0:5*OUTPUT_LEN-1] = {
    35672154, 205916406, 1669652510, 1423038994, 227115252,
    671598824, 1344931553, 2331200019, 537922112, 2270210933,
    36176308,

    1383409490, 3074126775, 3595396310, 2317918858, 4011782639,
    160471305, 2744793507, 3602738134, 4294967295, 4121910005,
    3351018439,

    2483094688, 1258365448, 2392593, 269487232, 69206049,
    2148008960, 84021280, 1132800, 2290123781, 67112992,
    33726464,

    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

    35672154, 205916406, 1669652510, 1423038994, 227115252,
    671598824, 1344931553, 2331200019, 537922112, 2270210933,
    36176308
};

logic [OUT_WIDTH/3-1:0] output_samples_mid [0:5*OUTPUT_LEN-1] = {
    360751444, 675090494, 2378202630, 3759998498, 656962162,
    1418376657, 3092986469, 2529072534, 2703507936, 1127048364,
    2193625168,

    659715367, 1941388147, 1691766116, 2726963362, 4058980081,
    2567540889, 967023161, 1809235307, 4294967295, 1526050650,
    2076687483,

    68321312, 101269552, 104857650, 1610746369, 2315265024,
    133376, 2138177, 1157628457, 4265984, 138444802, 134299732,

    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

    360751444, 675090494, 2378202630, 3759998498, 656962162,
    1418376657, 3092986469, 2529072534, 2703507936, 1127048364,
    2193625168
};

logic [OUT_WIDTH/3-1:0] output_samples_high [0:5*OUTPUT_LEN-1] = {
    52513176, 2450522168, 1923704846, 3798473993, 2255194440,
    1493246624, 825673296, 242322873, 1197595551, 1318666537,
    80252982,

    1965511285, 997439291, 1298454093, 681740840, 519171870,
    2425948560, 2587468698, 3177961149, 4294967295, 2941973935,
    3162228668,

    2097233, 754991400, 537970688, 2154038275, 65540, 1075839041,
    2155873284, 138944514, 77596711, 10555392, 335544480,

    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,

    52513176, 2450522168, 1923704846, 3798473993, 2255194440,
    1493246624, 825673296, 242322873, 1197595551, 1318666537,
    80252982
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
        #1440;
    end
    @(negedge i_clock) begin
        i_input_valid = 1'b0;
        i_output_ready = 1'b1;
        #2000;
    end
    i_input_valid = 1'b0;
    i_output_ready = 1'b0;
    #10000;
    if (run_count != 11) begin
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
            i_input_data = input_samples[idx];
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
    if (run_count != 11) begin
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
            i_input_data = input_samples[idx];
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
            i_input_data = input_samples[idx];
            i_input_valid = 1'b1;
            #10;
        end
    end
    for (integer idx = 2*INPUT_LEN; idx < 3*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 2
            i_input_data = input_samples[idx];
            i_input_valid = 1'b1;
            #10;
        end
    end
    for (integer idx = 3*INPUT_LEN; idx < 4*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 3
            i_input_data = 0;
            i_input_valid = 1'b1;
            #10;
        end
    end
    for (integer idx = 4*INPUT_LEN; idx < 5*INPUT_LEN; idx = idx + 1) begin
        @(negedge i_clock) begin
            // pass 4
            i_input_data = input_samples[idx];
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
    if (run_count != 55) begin
        $display("Error: Test 4 failed! Expected 11 data words, but received %d.", run_count);
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
            i_input_data = input_samples[idx];
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
            i_input_data = input_samples[idx];
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
            i_input_data = input_samples[idx];
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
            i_input_data = 0;
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
            i_input_data = input_samples[idx];
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
    if (run_count != 55) begin
        $display("Error: Test 4 failed! Expected 11 data words, but received %d.", run_count);
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
logic [OUT_WIDTH-1:0] expected_value;
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

endmodule: tb_sparse_mult_by_A

`default_nettype wire