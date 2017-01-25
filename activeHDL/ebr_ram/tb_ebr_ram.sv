// tb_ebr_ram.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_ebr_ram;

// Parameter declarations
localparam integer WIDTH = 16;
localparam integer DEPTH = 1024;
// Address + Data interface for input stream
logic [WIDTH-1:0]         i_in_data;
logic [$clog2(DEPTH)-1:0] i_in_addr;
logic                     i_in_valid;
// Address interface for output stream
logic [$clog2(DEPTH)-1:0] i_out_addr;
logic                     i_out_addr_valid;
logic                     o_out_addr_ready;
// Data interface for output stream
logic [WIDTH-1:0]         o_out_data;
logic                     o_out_valid;
logic                     i_out_ready;
logic                     i_clock;
logic                     i_reset;

ebr_ram #(
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
    i_in_addr = 0;
    i_in_valid = 1'b0;
    i_out_addr = 0;
    i_out_addr_valid = 1'b0;
    i_out_ready = 1'b1;
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

    // Test 2: Count data in, count data out.
    $display("Test 2 Started!");
    test_number = 2;
    reset_all();
    #1000;
    for (integer index = 0; index < 1000; index++) begin
        @(negedge i_clock) begin
            i_in_data = (1000-1) - index;
            i_in_addr = index;
            i_in_valid = 1'b1;
            #10;
        end
    end
    i_in_data = 0;
    i_in_addr = 0;
    i_out_ready = 1'b1;
    i_in_valid = 1'b0;
    #100;
    for (integer index = 0; index < 1000; index++) begin
        @(negedge i_clock) begin
            i_out_addr = index;
            i_out_addr_valid = 1'b1;
            #10;
        end
    end
    i_out_addr = 0;
    i_out_addr_valid = 1'b0;
    #1000;
    if (run_count != 1000) begin
        $display("Error: Expected 1000 data points, but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 2 Done!");

    // Test 3: Count data in, count data out. Sporadic input.
    $display("Test 3 Started!");
    test_number = 3;
    reset_all();
    #1000;
    for (integer index = 0; index < 1000; index++) begin
        @(negedge i_clock) begin
            i_in_data = (1000-1) - index;
            i_in_addr = index;
            i_in_valid = 1'b1;
            #10;
            if (index % 3 == 1) begin
                for (integer delay_index = 0; delay_index < index % 5; delay_index++) begin
                    i_in_data = 0;
                    i_in_addr = 0;
                    i_in_valid = 1'b0;
                    #10;
                end
            end else if (index % 5 == 3) begin
                for (integer delay_index = 0; delay_index < index % 3; delay_index++) begin
                    i_in_valid = 1'b0;
                    #10;
                end
            end
        end
    end
    i_in_data = 0;
    i_in_addr = 0;
    i_out_ready = 1'b1;
    i_in_valid = 1'b0;
    #100;
    for (integer index = 0; index < 1000; index++) begin
        @(negedge i_clock) begin
            i_out_addr = index;
            i_out_addr_valid = 1'b1;
            #10;
            if (index % 3 == 1) begin
                for (integer delay_index = 0; delay_index < index % 5; delay_index++) begin
                    i_out_addr = 0;
                    i_out_addr_valid = 1'b0;
                    #10;
                end
            end else if (index % 5 == 3) begin
                for (integer delay_index = 0; delay_index < index % 3; delay_index++) begin
                    i_out_addr_valid = 1'b0;
                    #10;
                end
            end
        end
    end
    i_out_addr = 0;
    i_out_addr_valid = 1'b0;
    #1000;
    if (run_count != 1000) begin
        $display("Error: Expected 1000 data points, but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 3 Done!");

    // Test 4: Count data in, count data out. Sporadic output.
    $display("Test 4 Started!");
    test_number = 3;
    reset_all();
    #1000;
    for (integer index = 0; index < 1000; index++) begin
        @(negedge i_clock) begin
            i_in_data = (1000-1) - index;
            i_in_addr = index;
            i_in_valid = 1'b1;
            #10;
            if (index % 3 == 1) begin
                for (integer delay_index = 0; delay_index < index % 5; delay_index++) begin
                    i_in_data = 0;
                    i_in_addr = 0;
                    i_in_valid = 1'b0;
                    #10;
                end
            end else if (index % 5 == 3) begin
                for (integer delay_index = 0; delay_index < index % 3; delay_index++) begin
                    i_in_valid = 1'b0;
                    #10;
                end
            end
        end
    end
    i_in_data = 0;
    i_in_addr = 0;
    i_out_ready = 1'b0;
    i_in_valid = 1'b0;
    #100;
    for (integer index = 0; index < 1000; index++) begin
        @(negedge i_clock) begin
            i_out_addr = index;
            i_out_addr_valid = 1'b1;
            #10;
            if (index % 2 == 1) begin
                for (integer delay_index = 0; delay_index < 4; delay_index++) begin
                    i_out_addr_valid = 1'b0;
                    i_out_ready = 1'b1;
                    #10;
                end
            end
        end
    end
    i_out_addr = 0;
    i_out_addr_valid = 1'b0;
    #1000;
    if (run_count != 1000) begin
        $display("Error: Expected 1000 data points, but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 4 Done!");

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
        if ((o_out_valid == 1'b1) && (i_out_ready == 1'b1)) begin
            run_count <= run_count + 1;

            if ((test_number == 2) || (test_number == 3)) begin
                if (o_out_data != (1000-1) - run_count) begin
                    $display("Data Error: Expected %d, but received %d.",
                        (1000-1) - run_count, o_out_data);
                end
            end
        end
    end
end

endmodule: tb_ebr_ram

`default_nettype wire
