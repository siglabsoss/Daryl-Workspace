// tb_ebr_fifo.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_ebr_fifo;

localparam integer WIDTH = 16;
localparam integer DEPTH = 1024;

logic [WIDTH-1:0]    i_in_data;
logic                i_in_valid;
logic                o_in_ready;
logic [WIDTH-1:0]    o_out_data;
logic                o_out_valid;
logic                i_out_ready;
logic                i_clock;
logic                i_reset;

ebr_fifo #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH))
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
    i_in_data = 0;
    i_in_valid = 1'b0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

integer count;

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
        #1000;
    end
    i_in_valid = 1'b0;
    #1000;
    if (run_count > 0) begin
        $display("Error: Test 1 failed! No data input, but data output received.");
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

    // Test 2: Simple data test, count in = count out.
    $display("Test 2 Started!");
    test_number = 2;
    reset_all();
    #1000;
    for (count = 0; count < DEPTH; count = count + 1) begin
        @(negedge i_clock) begin
            i_in_data = count;
            i_in_valid = 1'b1;
            i_out_ready = 1'b1;
            #10;
        end
    end
    i_in_valid = 1'b0;
    #(DEPTH*10);
    if (run_count != DEPTH) begin
        $display("Error: Test 2 failed! Expected %d outputs, but received %d.",
            DEPTH, run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 2 Done!");

    // Test 3: Simple data test, count in = count out.
    $display("Test 3 Started!");
    test_number = 3;
    reset_all();
    #1000;
    for (count = 0; count < DEPTH; count = count + 1) begin
        @(negedge i_clock) begin
            i_in_data = count;
            i_in_valid = 1'b1;
            i_out_ready = 1'b0;
            #10;
        end
    end
    i_in_valid = 1'b0;
    i_out_ready = 1'b1;
    #(DEPTH*10);
    if (run_count != DEPTH) begin
        $display("Error: Test 3 failed! Expected %d outputs, but received %d.",
            DEPTH, run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 3 Done!");

    // Finished
    #10000;
    glbl_err_count = glbl_err_count + local_err_count;
    #10;
    $display("Simulation done!");
    $finish();

end

// Tests the output sequence to make sure it matches the input
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        run_count <= 0;
    end else begin
        // Track number of outputs received
        if ((o_out_valid == 1'b1) && (i_out_ready == 1'b1)) begin
            run_count <= run_count + 1;

            if ((test_number == 2) || (test_number == 3)) begin
                if (o_out_data != run_count) begin
                    $display("Data Error! Expected %d, but received %d.", run_count, o_out_data);
                    local_err_count++;
                end
            end
        end
    end
end

endmodule: tb_ebr_fifo

`default_nettype wire
