// tb_skid.sv
//
// Rudimentary tests for skid buffer.
//

`timescale 10ps / 10ps

`default_nettype none

module tb_skid;

localparam integer WIDTH = 16;

// Clock and Reset
logic                i_clock;
logic                i_reset;
// Upstream signaling
logic [WIDTH-1:0]    i_in_data;
logic                i_in_valid;
logic                o_in_ready;
// Downstream signaling
logic [WIDTH-1:0]    o_out_data;
logic                o_out_valid;
logic                i_out_ready;

skid #(.WIDTH(WIDTH)) uut (.*);

always begin: clock_gen
    #5 i_clock = 1'b1;
    #5 i_clock = 1'b0;
end

// debug variable declarations
logic [31:0] loop_index = 0;
logic [31:0] glbl_err_count = 0;
logic [31:0] increment_value = 1;
logic [31:0] run_count = 0;

task reset_all;
    i_reset = 1'b1;
    i_in_valid = 1'b0;
    i_out_ready = 1'b0;
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
    if (run_count > 0) begin
        $display("Error: est 1 failed! No data input, but data output received.");
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

    // Test 2: Output waits until ready is high.
    $display("Test 2 Started!");
    increment_value = 2;
    reset_all();
    @(negedge i_clock) i_in_valid = 1'b1;
    #1000;
    if (o_out_data != 0) begin
        if (o_out_valid == 1'b1) begin
            $display("cycle number: %d", $stime);
            $display("Error: Test 2 failed! Data output received while ready signal low.");
            glbl_err_count++;
        end
    end
    @(negedge i_clock) begin
        i_out_ready = 1'b1;
        i_in_valid = 1'b0;
    end
    #1000;
    if (o_out_data == 0) begin
        if (o_out_valid == 1'b1) begin
            $display("Error: Test 2 failed! Data output not received while ready signal high.");
            glbl_err_count++;
        end
    end
    #1000;
    if (run_count != 2) begin
        $display("Error: Test 2 failed! Received more data than was taken in.");
        glbl_err_count++;
    end

    $display("Test 2 Done!");

    // Test 3: Output can deal with a bursty ready signal.
    $display("Test 3 Started!");
    increment_value = 3;
    reset_all();
    #1000;
    i_in_valid = 1'b1;
    #1000;
    @(negedge i_clock) begin
        i_out_ready = 1'b1;
    end
    #20; // 2 samples
    @(negedge i_clock) begin
        i_out_ready = 1'b0;
    end
    #30;
    @(negedge i_clock) begin
        i_out_ready = 1'b1;
    end
    #40; // plus 4 samples
    @(negedge i_clock) begin
        i_out_ready = 1'b0;
    end
    #50;
    @(negedge i_clock) begin
        i_out_ready = 1'b1;
    end
    #100; // plus 10 samples
    @(negedge i_clock) begin
        i_out_ready = 1'b0;
    end
    #50;
    if (run_count != 16) begin
        $display("Error: Test 3 failed! Received more data than expected.");
        glbl_err_count++;
    end
    //$display("    %d, %d", uut.out_data_reg, uut.skid_reg);
    $display("Test 3 Done!");

    // Test 4: Input can deal with a bursty valid signal.
    $display("Test 4 Started!");
    increment_value = 4;
    reset_all();
    @(negedge i_clock) begin
        i_out_ready = 1'b1;
    end
    #1000;
    @(negedge i_clock) begin
        i_in_valid = 1'b1;
    end // 5 samples
    #50;
    @(negedge i_clock) begin
        i_in_valid = 1'b0;
    end
    #100;
    @(negedge i_clock) begin
        i_in_valid = 1'b1;
    end
    #50; // plus 5 samples
    @(negedge i_clock) begin
        i_in_valid = 1'b0;
    end
    #200;
    @(negedge i_clock) begin
        i_in_valid = 1'b1;
    end // plus 35 samples
    #350;
    @(negedge i_clock) begin
        i_in_valid = 1'b0;
    end
    #400;
    if (run_count != 45) begin
        $display("Error: Test 4 failed! Received %d samples, expected 45.", run_count);
        glbl_err_count++;
    end
    $display("Test 4 Done!");

    // Test 5: Input and output can deal with bursty signals simultaneously.
    $display("Test 5 Started!");
    increment_value = 5;
    reset_all();
    #1000;

    $display("Test 5 Done!");

    // Finished
    #10000;
    $display("Simulation done!");
    $finish();

end

// Tests the output sequence to make sure it matches the input
logic [31:0] local_err_count = 0;
logic [31:0] stored_value = 0;
logic        increment_i_in_data = 1'b0;
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        stored_value <= 0;
        run_count <= 0;
        increment_i_in_data <= 1'b0;
    end else begin
        // Flag input counter to be incremented
        increment_i_in_data <= i_in_valid & o_in_ready;

        // Validate incrementing output sequence
        if ((o_out_valid & i_out_ready) == 1'b1) begin
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

// Increment input counter
always @(negedge i_clock) begin: incrementer
    if (i_reset == 1'b1) begin
        i_in_data <= 0;
    end else if (increment_i_in_data == 1'b1) begin
        i_in_data <= i_in_data + increment_value;
    end
end

// Do this in your test bench
initial begin
    $dumpfile("skid.vcd");
    $dumpvars;
end

endmodule: tb_skid

`default_nettype wire
