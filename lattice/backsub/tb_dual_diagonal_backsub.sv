// tb_skid.sv
//
// Rudimentary tests for skid buffer.
//

`timescale 10ps / 10ps

`default_nettype none

module tb_dual_diagonal_backsub;

localparam integer WIDTH = 16;
localparam integer NUM_WORDS = 8;

// Clock and Reset
logic                i_clock;
logic                i_reset;
// Upstream signaling
logic [WIDTH-1:0]    i_in_data;
logic                i_in_valid;
// Downstream signaling
logic [WIDTH-1:0]    o_out_data;
logic                o_out_valid;

dual_diagonal_backsub #(
    .WIDTH(WIDTH),
    .NUM_WORDS(NUM_WORDS))
uut (.*);

always begin: clock_gen
    #5 i_clock = 1'b1;
    #5 i_clock = 1'b0;
end

// debug variable declarations
logic [31:0] glbl_err_count = 0;
logic [31:0] increment_value = 1;
logic [31:0] run_count = 0;

task reset_all;
    i_reset = 1'b1;
    i_in_data = 0;
    i_in_valid = 1'b0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

initial begin: stimulus
    i_reset = 1'b1;
    #1000;
    reset_all();

    // Test 1: No data in = no data out.
    $display("Test 1 Started!");
    increment_value = 1;
    reset_all();
    #1000;
    @(negedge i_clock) begin
        i_in_valid = 1'b1;
        #(NUM_WORDS);
    end
    i_in_valid = 1'b0;
    #1000;
    if (run_count > 0) begin
        $display("Error: Test 1 failed! No data input, but data output received.");
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

    // Finished
    #10000;
    $display("Simulation done!");
    $finish();

end

// Tests the output sequence to make sure it matches the input
logic [31:0] local_err_count = 0;
logic [31:0] stored_value = 0;
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        stored_value <= 0;
        run_count <= 0;
    end else begin
        // Validate incrementing output sequence
        if (o_out_valid == 1'b1) begin
            if (o_out_data != stored_value) begin
                $display("Error: Output of %d expected, but received %d.", stored_value, o_out_data);
                local_err_count++;
            end
            //$display("    %d", uut.out_data_reg);

            // Increment value for next time
            run_count <= run_count + 1;
            stored_value <= stored_value + increment_value;
        end
    end
end

// Do this in your test bench
initial begin
    $dumpfile("dual_diagonal_backsub.vcd");
    $dumpvars;
end

endmodule: tb_dual_diagonal_backsub

`default_nettype wire
