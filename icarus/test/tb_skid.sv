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

skid #(.WIDTH(WIDTH)) uut (
    .i_clock,
    .i_reset,
    .i_in_data,
    .i_in_valid,
    .o_in_ready,
    .o_out_data,
    .o_out_valid,
    .i_out_ready);

//(.*);

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
    i_in_data = 1;
    i_in_valid = 1'b0;
    i_out_ready = 1'b0;
    #10000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

initial begin: stimulus
    i_reset = 1'b1;
    #10000;
    reset_all();

    // Test 1: No data in = no data out.
    $display("Test 1 Started!");
    increment_value = 1;
    reset_all();
    #10000;
    if (run_count > 0) begin
        $display("Error: est 1 failed! No data input, but data output received.");
        glbl_err_count++;
    end
    #1000;
    $display("Test 1 Done!");

    // Test 2: Output waits until ready is high.
    $display("Test 2 Started!");
    increment_value = 2;
    reset_all();
    i_in_valid = 1'b1;
    #10000;
    if (o_out_data != 0) begin
        if (o_out_valid == 1'b1) begin
            $display("Error: Test 2 failed! Data output received while ready signal low.");
            glbl_err_count++;
        end
    end
    i_out_ready = 1'b1;
    i_in_valid = 1'b0;
    #10000;
    if (o_out_data == 0) begin
        if (o_out_valid == 1'b1) begin
            $display("Error: Test 2 failed! Data output not received while ready signal high.");
            glbl_err_count++;
        end
    end
    #10000;
    if (run_count != 2) begin
        $display("Error: Test 2 failed! Received more data than was taken in.");
        glbl_err_count++;
    end

    // Test 3: Output can deal with a bursty ready signal.
    increment_value = 3;
    reset_all();
    #10000;
    $display("Test 2 Done!");

    // Test 4: Input can deal with a bursty valid signal.
    increment_value = 4;
    reset_all();
    #10000;

    // Test 5: Input and output can deal with bursty signals simultaneously.
    increment_value = 5;
    reset_all();
    #10000;

    // Finished.
    #10000;
    $display("Simuation done!");
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
        // Increment input sequence
        if ((i_in_valid & o_in_ready) == 1'b1) begin
            i_in_data <= i_in_data + increment_value;
        end
        // Validate incrementing output sequence
        if ((o_out_valid & i_out_ready) == 1'b1) begin
            $display("Detected...");
            if (o_out_data != stored_value) begin
                $display("Error: Output of %d expected, but received %d.", stored_value, o_out_data);
                local_err_count++;
            end

            // Increment value for next time
            run_count <= run_count + 1;
            stored_value <= stored_value + increment_value;
        end
    end
end

// Do this in your test bench
initial begin
    $dumpfile("skid.vcd");
    $dumpvars;
end

endmodule: tb_skid

`default_nettype wire