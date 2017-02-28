// tb_cic_interp.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_cic_interp;

localparam integer WIDTH = 16;

// Clock and Reset
logic                i_clock;
logic                i_reset;
// Upstream signaling
logic [WIDTH-1:0]    i_in_data;
logic                i_in_valid;
// Downstream signaling
logic [WIDTH-1:0]    o_out_data;
logic                o_out_valid;

cic_interp #(.WIDTH(WIDTH)) uut (.*);

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
    test_number = 1;
    reset_all();
    #1000;
    @(negedge i_clock) begin
        i_in_valid = 1'b0;
        #10;
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
        if (o_out_valid == 1'b1) begin
            run_count <= run_count + 1;
        end
    end
end

endmodule: tb_cic_interp

`default_nettype wire
