// tb_dds.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_ddsx2;

logic [32-1:0] i_phase_inc;
logic          i_phase_inc_valid;
logic [36-1:0] o_cosine_data;
logic [36-1:0] o_sine_data;
logic [36-1:0] o_cosine_delay_data;
logic [36-1:0] o_sine_delay_data;
logic          i_ready;
logic          i_clock;
logic          i_reset;

logic          gsr;
logic          pur;

ddsx2 uut (.*);
GSR GSR_inst(gsr);
PUR PUR_inst(pur);

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
    i_phase_inc = 0;
    i_phase_inc_valid = 1'b0;
    i_ready = 1'b0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

integer fid;

initial begin: stimulus
    i_reset = 1'b1;
    gsr = 1'b0;
    pur = 1'b0;
    #1000;
    gsr = 1'b1;
    pur = 1'b1;
    #1000;
    reset_all();

    // Test 1: No data in = no data out.
    $display("Test 1 Started!");
    test_number = 1;
    reset_all();
    #1000;
    @(negedge i_clock) begin
        i_ready = 1'b0;
        #10;
    end
    i_ready = 1'b0;
    #1000;
    $display("Test 1 Done!");

    // Test 2: Write some samples to a test file
    $display("Test 2 Started!");
    test_number = 1;
    reset_all();
    #1000;
    i_phase_inc <= $rtoi((31.5 / 250.0) * $pow(2.0, 32.0));
    i_phase_inc_valid <= 1'b1;
    #10;
    i_phase_inc <= '0;
    i_phase_inc_valid <= 1'b0;
    #10;
    fid = $fopen("outvec.txt");
    for (integer iter_idx = 0; iter_idx < 262144+100; iter_idx++) begin
        @(negedge i_clock) begin
            i_ready = 1'b1;
            $fwrite(fid, "%d,%d\n", $signed(o_cosine_data), $signed(o_sine_data));
            $fwrite(fid, "%d,%d\n", $signed(o_cosine_delay_data), $signed(o_sine_delay_data));
            #10;
        end
    end
    $fclose(fid);
    i_ready = 1'b0;
    #1000;
    $display("Test 2 Done!");

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
//         if (i_ready == 1'b1) begin
//             run_count <= run_count + 1;
//         end
//     end
// end

endmodule: tb_ddsx2

`default_nettype wire

