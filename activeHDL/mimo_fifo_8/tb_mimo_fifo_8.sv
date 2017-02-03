// tb_mimo_fifo_8.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_mimo_fifo_8;

// module params
localparam integer WIDTH = 16;
localparam integer DEPTH = 128;

// Testbench params
localparam integer NUM_INPUTS = 8;
localparam integer NUM_OUTPUTS = 8;

logic [WIDTH-1:0]       i_data [0:NUM_OUTPUTS-1];
logic [2:0]             i_to_branch [0:NUM_OUTPUTS-1];
logic                   i_valid;
logic                   o_ready;
logic [WIDTH-1:0]       o_data [0:NUM_OUTPUTS-1];
logic [NUM_OUTPUTS-1:0] o_valid;
logic                   i_clock;
logic                   i_reset;

mimo_fifo_8 #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH))
uut (
    .i_data_0     (i_data[0]     ),
    .i_data_1     (i_data[1]     ),
    .i_data_2     (i_data[2]     ),
    .i_data_3     (i_data[3]     ),
    .i_data_4     (i_data[4]     ),
    .i_data_5     (i_data[5]     ),
    .i_data_6     (i_data[6]     ),
    .i_data_7     (i_data[7]     ),
    .i_to_branch_0(i_to_branch[0]),
    .i_to_branch_1(i_to_branch[1]),
    .i_to_branch_2(i_to_branch[2]),
    .i_to_branch_3(i_to_branch[3]),
    .i_to_branch_4(i_to_branch[4]),
    .i_to_branch_5(i_to_branch[5]),
    .i_to_branch_6(i_to_branch[6]),
    .i_to_branch_7(i_to_branch[7]),
    .i_valid      (i_valid       ),
    .o_ready      (o_ready       ),
    .o_data_0     (o_data[0]     ),
    .o_data_1     (o_data[1]     ),
    .o_data_2     (o_data[2]     ),
    .o_data_3     (o_data[3]     ),
    .o_data_4     (o_data[4]     ),
    .o_data_5     (o_data[5]     ),
    .o_data_6     (o_data[6]     ),
    .o_data_7     (o_data[7]     ),
    .o_valid_0    (o_valid[0]    ),
    .o_valid_1    (o_valid[1]    ),
    .o_valid_2    (o_valid[2]    ),
    .o_valid_3    (o_valid[3]    ),
    .o_valid_4    (o_valid[4]    ),
    .o_valid_5    (o_valid[5]    ),
    .o_valid_6    (o_valid[6]    ),
    .o_valid_7    (o_valid[7]    ),
    .i_clock      (i_clock       ),
    .i_reset      (i_reset       ));

always begin: clock_gen
    #5 i_clock = 1'b1;
    #5 i_clock = 1'b0;
end

// debug variable declarations
logic [31:0] glbl_err_count = 0;
logic [31:0] test_number = 1;
logic [31:0] run_count [0:NUM_OUTPUTS-1];

// Used by check process, declared here so it
// can be included in the final tall for the
// global error count.
logic [31:0] local_err_count = 0;

task reset_all;
    i_reset = 1'b1;
    for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
        i_data[idx] = 0;
        i_to_branch[idx] = 0;
    end
    i_valid = 1'b0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

task input_on_all(
    input logic [WIDTH-1:0] data_values [0:NUM_INPUTS-1],
    input logic [2:0]       to_branch   [0:NUM_INPUTS-1]
);
    integer timeout_counter = 0;
    @(negedge i_clock) begin
        for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
            i_data[idx] = data_values[idx];
            i_to_branch[idx] = to_branch[idx];
        end
        if (o_ready == 1'b1) begin
            i_valid = 1'b1;
            #10;
        end else begin
            i_valid = 1'b1;
            #4;
            timeout_counter = 0;
            while ((o_ready == 1'b0) && (timeout_counter < 10000)) begin
                timeout_counter++;
                #10;
            end
            #6;
            if (timeout_counter == 10000) begin
                $display("Error: Write timed out after %d iterations.", timeout_counter);
            end
        end
        i_valid = 1'b0;
    end
endtask: input_on_all;

initial begin: stimulus
    logic [WIDTH-1:0] data_values   [0:NUM_INPUTS-1];
    logic [2:0]       branch_values [0:NUM_INPUTS-1];

    i_reset = 1'b1;
    #1000;
    reset_all();

    // Test 1: No data in = no data out.
    $display("Test 1 Started!");
    test_number = 1;
    reset_all();
    #10000;
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
        if (run_count[idx] > 0) begin
            $display("Error: Test 1 failed! No data input, but data output received on %d.", idx);
            glbl_err_count++;
        end
    end
    #1000;
    $display("Test 1 Done!");

    // Test 2: Data n to port n.
    $display("Test 2 Started!");
    test_number = 2;
    reset_all();
    i_reset = 1'b0;
    #1000;
    for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
        data_values[idx] = idx;
        branch_values[idx] = idx;
    end
    input_on_all(data_values, branch_values);
    #1000;
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
        if (run_count[idx] != 1) begin
            $display("Error: Expected 1 output, but received %d outputs.",
                run_count[idx]);
            glbl_err_count++;
        end
    end
    #10000;
    $display("Test 2 Done!");

    // Test 3: Data n to port 0.
    $display("Test 3 Started!");
    test_number = 3;
    reset_all();
    i_reset = 1'b0;
    #1000;
    for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
        data_values[idx] = idx;
        branch_values[idx] = 0;
    end
    input_on_all(data_values, branch_values);
    #1000;
    if (run_count[0] != 8) begin
        $display("Branch 0 Error: Expected 8 outputs, but received %d outputs.",
            run_count[0]);
        glbl_err_count++;
    end
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
        if ((idx != 0) && (run_count[idx] > 0)) begin
            $display("Branch %d Error: Expected 0 outputs, but received %d outputs.",
                idx, run_count[idx]);
        end
    end
    #10000;
    $display("Test 3 Done!");

    // Test 4: Data n to port 1.
    $display("Test 4 Started!");
    test_number = 4;
    reset_all();
    i_reset = 1'b0;
    #1000;
    for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
        data_values[idx] = idx;
        branch_values[idx] = 1;
    end
    input_on_all(data_values, branch_values);
    #1000;
    if (run_count[1] != 8) begin
        $display("Branch 1 Error: Expected 8 outputs, but received %d outputs.",
            run_count[1]);
        glbl_err_count++;
    end
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
        if ((idx != 1) && (run_count[idx] > 0)) begin
            $display("Branch %d Error: Expected 0 outputs, but received %d outputs.",
                idx, run_count[idx]);
        end
    end
    #10000;
    $display("Test 4 Done!");

    // Test 4: Data n to port 2.
    $display("Test 5 Started!");
    test_number = 5;
    reset_all();
    i_reset = 1'b0;
    #1000;
    for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
        data_values[idx] = idx;
        branch_values[idx] = 2;
    end
    input_on_all(data_values, branch_values);
    #1000;
    if (run_count[2] != 8) begin
        $display("Branch 2 Error: Expected 8 outputs, but received %d outputs.",
            run_count[2]);
        glbl_err_count++;
    end
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
        if ((idx != 2) && (run_count[idx] > 0)) begin
            $display("Branch %d Error: Expected 0 outputs, but received %d outputs.",
                idx, run_count[idx]);
        end
    end
    #10000;
    $display("Test 5 Done!");

    // Test 6: Data n to port 3.
    $display("Test 6 Started!");
    test_number = 6;
    reset_all();
    i_reset = 1'b0;
    #1000;
    for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
        data_values[idx] = idx;
        branch_values[idx] = 3;
    end
    input_on_all(data_values, branch_values);
    #1000;
    if (run_count[3] != 8 ) begin
        $display("Branch 3 Error: Expected 8 outputs, but received %d outputs.",
            run_count[3]);
        glbl_err_count++;
    end
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
        if ((idx != 3) && (run_count[idx] > 0)) begin
            $display("Branch %d Error: Expected 0 outputs, but received %d outputs.",
                idx, run_count[idx]);
        end
    end
    #10000;
    $display("Test 6 Done!");

    // Test 7: Data n to port 4.
    $display("Test 7 Started!");
    test_number = 7;
    reset_all();
    i_reset = 1'b0;
    #1000;
    for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
        data_values[idx] = idx;
        branch_values[idx] = 4;
    end
    input_on_all(data_values, branch_values);
    #1000;
    if (run_count[4] != 8 ) begin
        $display("Branch 4 Error: Expected 8 outputs, but received %d outputs.",
            run_count[4]);
        glbl_err_count++;
    end
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
        if ((idx != 4) && (run_count[idx] > 0)) begin
            $display("Branch %d Error: Expected 0 outputs, but received %d outputs.",
                idx, run_count[idx]);
        end
    end
    #10000;
    $display("Test 7 Done!");

    // Test 8: Data n to port 5.
    $display("Test 8 Started!");
    test_number = 8;
    reset_all();
    i_reset = 1'b0;
    #1000;
    for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
        data_values[idx] = idx;
        branch_values[idx] = 5;
    end
    input_on_all(data_values, branch_values);
    #1000;
    if (run_count[5] != 8) begin
        $display("Branch 5 Error: Expected 8 outputs, but received %d outputs.",
            run_count[5]);
        glbl_err_count++;
    end
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
        if ((idx != 5) && (run_count[idx] > 0)) begin
            $display("Branch %d Error: Expected 0 outputs, but received %d outputs.",
                idx, run_count[idx]);
        end
    end
    #10000;
    $display("Test 8 Done!");

    // Test 9: Data n to port 6.
    $display("Test 9 Started!");
    test_number = 9;
    reset_all();
    i_reset = 1'b0;
    #1000;
    for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
        data_values[idx] = idx;
        branch_values[idx] = 6;
    end
    input_on_all(data_values, branch_values);
    #1000;
    if (run_count[6] != 8 ) begin
        $display("Branch 6 Error: Expected 8 outputs, but received %d outputs.",
            run_count[6]);
        glbl_err_count++;
    end
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
        if ((idx != 6) && (run_count[idx] > 0)) begin
            $display("Branch %d Error: Expected 0 outputs, but received %d outputs.",
                idx, run_count[idx]);
        end
    end
    #10000;
    $display("Test 9 Done!");

    // Test 10: Data n to port 7.
    $display("Test 10 Started!");
    test_number = 10;
    reset_all();
    i_reset = 1'b0;
    #1000;
    for (integer idx = 0; idx < NUM_INPUTS; idx++) begin
        data_values[idx] = idx;
        branch_values[idx] = 7;
    end
    input_on_all(data_values, branch_values);
    #1000;
    if (run_count[7] != 8 ) begin
        $display("Branch 7 Error: Expected 8 outputs, but received %d outputs.",
            run_count[7]);
        glbl_err_count++;
    end
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
        if ((idx != 7) && (run_count[idx] > 0)) begin
            $display("Branch %d Error: Expected 0 outputs, but received %d outputs.",
                idx, run_count[idx]);
        end
    end
    #10000;
    $display("Test 10 Done!");

    // Finished
    #10000;
    glbl_err_count = glbl_err_count + local_err_count;
    $display("Simulation done!");
    $finish();

end

// Tests the output sequence to make sure it matches the input
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        for (integer idx = 0; idx < NUM_OUTPUTS; idx = idx + 1) begin
            run_count[idx] <= 0;
        end
    end else begin
        // Track number of outputs received
        for (integer idx = 0; idx < NUM_OUTPUTS; idx = idx + 1) begin
            if (o_valid[idx] == 1'b1) begin
                if ((o_data[idx] != idx) && (test_number == 2)) begin
                    $display("Data Error: Expected branch %d to equal %d, but %d received.",
                        idx, idx, o_data[idx]);
                    glbl_err_count++;
                end

                if ((test_number >= 3) && (test_number <= 10)) begin
                    if ((o_data[idx] != run_count[idx]) && (idx == test_number-3)) begin
                        $display("Data Error: Expected branch %d to equal %d, but %d received.",
                            idx, run_count[idx], o_data[idx]);
                        glbl_err_count++;
                    end else if (idx != test_number-3) begin
                        $display("Data Error: No data input on branch %d, but received %d",
                            idx, o_data[idx]);
                    end
                end

                run_count[idx] = run_count[idx] + 1;
            end
        end
    end
end

endmodule: tb_mimo_fifo_8

`default_nettype wire
