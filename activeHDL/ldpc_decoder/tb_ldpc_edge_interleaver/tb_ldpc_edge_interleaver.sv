// tb_ldpc_edge_interleaver.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_ldpc_edge_interleaver;

localparam EXPANSION_FACTOR = 96;

// ldpc_column_to_row
logic                                   i_valid_c2r;
logic [$clog2(12*EXPANSION_FACTOR)-1:0] o_index_for_a0_c2r;
logic [$clog2(12*EXPANSION_FACTOR)-1:0] o_index_for_a1_c2r;
logic [$clog2(12*EXPANSION_FACTOR)-1:0] o_index_for_a2_c2r;
logic [$clog2(12*EXPANSION_FACTOR)-1:0] o_index_for_a3_c2r;
logic [$clog2(12*EXPANSION_FACTOR)-1:0] o_index_for_a4_c2r;
logic [$clog2(12*EXPANSION_FACTOR)-1:0] o_index_for_a5_c2r;
logic [$clog2(8)-1:0]                   o_branch_for_a0_c2r;
logic [$clog2(8)-1:0]                   o_branch_for_a1_c2r;
logic [$clog2(8)-1:0]                   o_branch_for_a2_c2r;
logic [$clog2(8)-1:0]                   o_branch_for_a3_c2r;
logic [$clog2(8)-1:0]                   o_branch_for_a4_c2r;
logic [$clog2(8)-1:0]                   o_branch_for_a5_c2r;

// ldpc_row_to_column
logic                                   i_valid_r2c;
logic [$clog2(24*EXPANSION_FACTOR)-1:0] o_index_for_a0_r2c;
logic [$clog2(24*EXPANSION_FACTOR)-1:0] o_index_for_a1_r2c;
logic [$clog2(24*EXPANSION_FACTOR)-1:0] o_index_for_a2_r2c;
logic [$clog2(24*EXPANSION_FACTOR)-1:0] o_index_for_a3_r2c;
logic [$clog2(24*EXPANSION_FACTOR)-1:0] o_index_for_a4_r2c;
logic [$clog2(24*EXPANSION_FACTOR)-1:0] o_index_for_a5_r2c;
logic [$clog2(24*EXPANSION_FACTOR)-1:0] o_index_for_a6_r2c;
logic [$clog2(8)-1:0]                   o_branch_for_a0_r2c;
logic [$clog2(8)-1:0]                   o_branch_for_a1_r2c;
logic [$clog2(8)-1:0]                   o_branch_for_a2_r2c;
logic [$clog2(8)-1:0]                   o_branch_for_a3_r2c;
logic [$clog2(8)-1:0]                   o_branch_for_a4_r2c;
logic [$clog2(8)-1:0]                   o_branch_for_a5_r2c;
logic [$clog2(8)-1:0]                   o_branch_for_a6_r2c;

logic                                   i_clock;
logic                                   i_reset;

ldpc_column_to_row_rom c2r_uut (
    .i_valid        (i_valid_c2r        ),
    .o_index_for_a0 (o_index_for_a0_c2r ),
    .o_index_for_a1 (o_index_for_a1_c2r ),
    .o_index_for_a2 (o_index_for_a2_c2r ),
    .o_index_for_a3 (o_index_for_a3_c2r ),
    .o_index_for_a4 (o_index_for_a4_c2r ),
    .o_index_for_a5 (o_index_for_a5_c2r ),
    .o_branch_for_a0(o_branch_for_a0_c2r),
    .o_branch_for_a1(o_branch_for_a1_c2r),
    .o_branch_for_a2(o_branch_for_a2_c2r),
    .o_branch_for_a3(o_branch_for_a3_c2r),
    .o_branch_for_a4(o_branch_for_a4_c2r),
    .o_branch_for_a5(o_branch_for_a5_c2r),
    .i_clock        (i_clock            ),
    .i_reset        (i_reset            ));

ldpc_row_to_column_rom r2c_uut (
    .i_valid        (i_valid_r2c       ),
    .o_index_for_a0 (o_index_for_a0_r2c),
    .o_index_for_a1 (o_index_for_a1_r2c),
    .o_index_for_a2 (o_index_for_a2_r2c),
    .o_index_for_a3 (o_index_for_a3_r2c),
    .o_index_for_a4 (o_index_for_a4_r2c),
    .o_index_for_a5 (o_index_for_a5_r2c),
    .o_index_for_a6 (o_index_for_a6_r2c),
    .o_branch_for_a0(o_branch_for_a0_r2c),
    .o_branch_for_a1(o_branch_for_a1_r2c),
    .o_branch_for_a2(o_branch_for_a2_r2c),
    .o_branch_for_a3(o_branch_for_a3_r2c),
    .o_branch_for_a4(o_branch_for_a4_r2c),
    .o_branch_for_a5(o_branch_for_a5_r2c),
    .o_branch_for_a6(o_branch_for_a6_r2c),
    .i_clock        (i_clock            ),
    .i_reset        (i_reset            ));

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
    i_valid_c2r = 1'b0;
    i_valid_r2c = 1'b0;
    i_reset = 1'b1;
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
        i_valid_r2c = 1'b0;
        i_valid_c2r = 1'b0;
        #10;
    end
    #10000;
    if (run_count != 0) begin
        $display("Error: Expected no output, received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

// Test 1: No data in = no data out.
    $display("Test 1 Started!");
    test_number = 1;
    reset_all();
    #1000;
    @(negedge i_clock) begin
        i_valid_r2c = 1'b1;
        i_valid_c2r = 1'b1;
        #23040;
    end
    @(negedge i_clock) begin
        i_valid_r2c = 1'b0;
        i_valid_c2r = 1'b0;
        #10;
    end
    #10000;
    if (run_count != 0) begin
        $display("Error: Expected no output, received %d.", run_count);
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

// Tests the output sequence to make sure it matches the input
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        run_count <= 0;
    end else begin
        // // Track number of outputs received
        // if (o_valid == 1'b1) begin
        //     // Count number of outputs
        //     run_count <= run_count + 1;
        // end
    end
end

endmodule: tb_ldpc_edge_interleaver

`default_nettype wire
