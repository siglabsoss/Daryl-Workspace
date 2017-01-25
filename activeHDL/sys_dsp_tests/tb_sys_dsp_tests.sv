// tb_sys_dsp_tests.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_sys_dsp_tests;

logic [17:0] i_term_a_data;
logic [17:0] i_term_b_data;
logic [17:0] i_term_c_data;
logic [17:0] o_sum_data;
logic        i_clock;
logic        i_reset;

sys_dsp_tests uut (.*);

logic GSR, PUR;
GSR GSR_INST(.GSR(GSR));
PUR PUR_INST(.PUR(PUR));

initial begin
    GSR = 1'b1;
    PUR = 1'b1;
    #10000;
    GSR = 1'b0;
    PUR = 1'b0;
end

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
    i_term_a_data = 0;
    i_term_b_data = 0;
    i_term_c_data = 0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

initial begin: stimulus
    i_reset = 1'b1;
    #10000;
    reset_all();

    // Test 1: No data in = no data out.
    $display("Test 1 Started!");
    test_number = 1;
    reset_all();
    #1000;
    for (integer idx = 0; idx < 100; idx++) begin
        @(negedge i_clock) begin
            i_term_a_data = idx;
            i_term_b_data = 1000*idx;
            i_term_c_data = 500*idx;
            #10;
        end
    end
    #1000;
    if (run_count > 0) begin
        $display("Error: Test 1 failed! No data input, but data output received.");
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

    // Finished
    #10000;
    glbl_err_count = glbl_err_count + local_err_count;
    $display("Simulation done!");

    $display("\n\nA   = %d", i_term_a_data);
    $display("\n\nB   = %d", i_term_b_data);
    $display("\n\nC   = %d", i_term_c_data);
    $display("\n\nSUM = %d\n\n", o_sum_data);

    $finish();

end

// // Tests the output sequence to make sure it matches the input
// always @(posedge i_clock) begin: seq_check
//     if (i_reset == 1'b1) begin
//         run_count <= 0;
//     end else begin
//         // Track number of outputs received
//         if (o_out_valid == 1'b1) begin
//             run_count <= run_count + 1;
//         end
//     end
// end

endmodule: tb_sys_dsp_tests

`default_nettype wire
