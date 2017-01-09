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

logic [IN_WIDTH-1:0] input_samples [0:INPUT_LEN-1] = {
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

logic [OUT_WIDTH/3-1:0] output_samples_low [0:OUTPUT_LEN-1] = {
    35672154, 205916406, 1669652510, 1423038994, 227115252,
    671598824, 1344931553, 2331200019, 537922112, 2270210933,
    36176308
};

logic [OUT_WIDTH/3-1:0] output_samples_mid [0:OUTPUT_LEN-1] = {
    360751444, 675090494, 2378202630, 3759998498, 656962162,
    1418376657, 3092986469, 2529072534, 2703507936, 1127048364,
    2193625168
};

logic [OUT_WIDTH/3-1:0] output_samples_high [0:OUTPUT_LEN-1] = {
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
            i_input_data <= input_samples[idx];
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

    // Finished
    #10000;
    glbl_err_count <= glbl_err_count + local_err_count;
    $display("Simulation done!");
    $finish();

end

// Tests the output sequence to make sure it matches the input
logic [OUT_WIDTH-1:0] expected_value;
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        run_count <= 0;
    end else begin
        // Track number of outputs received
        if ((o_output_valid == 1'b1) && (i_output_ready == 1'b1)) begin
            // Make sure data for test 2 is valid (all zeros)
            if (test_number == 2) begin
                if (o_output_data != 0) begin
                    local_err_count = local_err_count + 1;
                    $display("Data error. Test 1 expects all zeros, but received %d.", o_output_data);
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
                    $display("Data error. Test 1 expects %b, but received %b.", expected_value, o_output_data);
                end
            end
            // Increment the run count
            run_count <= run_count + 1;
        end
    end
end

endmodule: tb_sparse_mult_by_A

`default_nettype wire
