// tb_channel_modulator.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_channel_modulator;

localparam integer WIDTH = 16;
localparam integer NUM_CHANNELS = 2048;

// Input Sample Interface
logic [WIDTH-1:0] i_inph;
logic [WIDTH-1:0] i_quad;
logic             i_valid;
logic             o_ready;
// Phase Accumulator Increment
logic [12-1:0]    i_phase_inc;
logic             i_phase_inc_valid;
// Output Sample Interface
logic [WIDTH-1:0] o_inph;
logic [WIDTH-1:0] o_quad;
logic             o_valid;
logic             i_ready;
// Clock and Reset
logic             i_clock;
logic             i_reset;

channel_modulator #(
    .WIDTH(WIDTH),
    .NUM_CHANNELS(NUM_CHANNELS))
uut (.*);

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
    i_inph = 0;
    i_quad = 0;
    i_valid = 1'b0;
    i_ready = 1'b0;
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
    i_ready = 1'b1;
    @(negedge i_clock) begin
        i_valid = 1'b0;
        #10;
    end
    i_valid = 1'b0;
    #1000;
    if (run_count > 0) begin
        $display("Error: Test 1 failed! No data input, but data output received.");
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

    // Test 2: Same amount of data in to out...
    $display("Test 1 Started!");
    test_number = 1;
    i_phase_inc = 1;
    i_phase_inc_valid = 1'b1;
    reset_all();
    #1000;
    i_ready = 1'b1;
    for (integer pidx = 0; pidx < 100000; pidx++) begin
        @(negedge i_clock) begin
            i_valid = 1'b1;
            #10;
            if (pidx % 5 > 0) begin
                i_valid = 1'b0;
                #10;
            end
        end
    end
    i_valid = 1'b0;
    #1000;
    if (run_count != 110000000) begin
        $display("Error: Input 100000 samples, received %d samples.", run_count);
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
        // Track number of outputs received
        if ((o_valid == 1'b1) && (i_ready == 1'b1)) begin
            run_count <= run_count + 1;
        end
    end
end

endmodule: tb_channel_modulator

`default_nettype wire
