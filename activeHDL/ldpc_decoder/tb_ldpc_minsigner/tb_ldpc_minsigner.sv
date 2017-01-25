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
logic       i_latch_inputs;
logic [7:0] o_data_a0;
logic [7:0] o_data_a1;
logic [7:0] o_data_a2;
logic [7:0] o_data_a3;
logic [7:0] o_data_a4;
logic [7:0] o_data_a5;
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
        i_data_a0 = -11;
        i_data_a1 = -20;
        i_data_a2 = 30;
        i_data_a3 = -40;
        i_data_a4 = 150;
        i_data_a5 = 100;
        i_latch_inputs = 1'b1;
        #10;
    end
    i_latch_inputs = 1'b0;
    #10000;
    if ($signed(o_data_a0) != -20) begin
        $display("Error: Expected a0 = -20, but received a0 = %d.", $signed(o_data_a0));
        glbl_err_count++;
    end
    if ($signed(o_data_a1) != -11) begin
        $display("Error: Expected a1 = -11, but received a1 = %d.", $signed(o_data_a1));
        glbl_err_count++;
    end
    if ($signed(o_data_a2) != 11) begin
        $display("Error: Expected a2 = 11, but received a2 = %d.", $signed(o_data_a2));
        glbl_err_count++;
    end
    if ($signed(o_data_a3) != -11) begin
        $display("Error: Expected a3 = -11, but received a3 = %d.", $signed(o_data_a3));
        glbl_err_count++;
    end
    if ($signed(o_data_a4) != -11) begin
        $display("Error: Expected a4 = -11, but received a4 = %d.", $signed(o_data_a4));
        glbl_err_count++;
    end
    if ($signed(o_data_a5) != 11) begin
        $display("Error: Expected a5 = 11, but received a5 = %d.", $signed(o_data_a5));
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

endmodule: tb_ldpc_minsigner

`default_nettype wire
