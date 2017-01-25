// tb_adder_trees.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_adder_trees;

logic [15:0] i_data_a0;
logic [15:0] i_data_a1;
logic [15:0] i_data_a2;
logic [15:0] i_data_a3;
logic [15:0] i_data_a4;
logic [15:0] i_data_a5;
logic [15:0] o_data_a0;
logic [15:0] o_data_a1;
logic [15:0] o_data_a2;
logic [15:0] o_data_a3;
logic [15:0] o_data_a4;
logic [15:0] o_data_a5;
logic        i_clock;
logic        i_reset;

adder_trees uut (.*);

logic GSR, PUR;
GSR GSR_INST(GSR);
PUR PUR_INST(PUR);

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
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

initial begin: stimulus
    GSR = 1'b0;
    PUR = 1'b0;
    i_reset = 1'b1;
    #10000;
    GSR = 1'b1;
    PUR = 1'b1;
    #1000;
    reset_all();

    // Test 1: No data in = no data out.
    $display("Test 1 Started!");
    test_number = 1;
    reset_all();
    #1000;
    @(negedge i_clock) begin
        i_data_a0 = -1000;
        i_data_a1 = 2000;
        i_data_a2 = -3000;
        i_data_a3 = 4000;
        i_data_a4 = -5000;
        #10;
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

endmodule: tb_adder_trees

`default_nettype wire
