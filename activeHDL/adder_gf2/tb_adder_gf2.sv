// tb_skid.sv
//
// Rudimentary tests for skid buffer.
//

`timescale 10ps / 10ps

`default_nettype none

module tb_adder_gf2;

localparam integer WIDTH = 16;

logic [WIDTH-1:0] i_lhs_data;
logic             i_lhs_valid;
logic             o_lhs_ready;
logic [WIDTH-1:0] i_rhs_data;
logic             i_rhs_valid;
logic             o_rhs_ready;
logic [WIDTH-1:0] o_sum_data;
logic             o_sum_valid;
logic             i_sum_ready;
logic             i_clock;
logic             i_reset;

adder_gf2 #(.WIDTH(WIDTH)) uut (.*);

localparam integer VECLEN = 12;

logic [WIDTH-1:0] lhs_input_vector [0:VECLEN-1] = {
    16'hFFFF, 16'hF0F0, 16'h0F0F, 16'h8000,
    16'h8080, 16'h1001, 16'h1100, 16'h3333,
    16'h5555, 16'h1234, 16'h4321, 16'h1101
};

logic [WIDTH-1:0] rhs_input_vector [0:VECLEN-1] = {
    16'h1001, 16'h0110, 16'h1616, 16'hB00B,
    16'hB005, 16'hB001, 16'hBEEF, 16'hFEED,
    16'hEFEF, 16'hAAAA, 16'hC0DA, 16'h0CDA
};

logic [WIDTH-1:0] sum_output_vector [0:VECLEN-1] = {
    16'hEFFE, 16'hF1E0, 16'h1919, 16'h300B,
    16'h3085, 16'hA000, 16'hAFEF, 16'hCDDE,
    16'hBABA, 16'hB89E, 16'h83FB, 16'h1DDB
};

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
    i_lhs_data = 0;
    i_lhs_valid = 1'b0;
    i_rhs_data = 0;
    i_rhs_valid = 1'b0;
    i_sum_ready = 1'b0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

integer countval;
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
        i_rhs_valid = 1'b0;
        i_lhs_valid = 1'b0;
        i_sum_ready = 1'b1;
        #(VECLEN*10);
    end
    i_rhs_valid = 1'b0;
    i_lhs_valid = 1'b0;
    i_sum_ready = 1'b1;
    #1000;
    i_sum_ready = 1'b0;
    #10;
    if (run_count > 0) begin
        $display("Error: Test 1 failed! No data input, but data output received.");
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

    // Test 1: Basic xor operation
    $display("Test 2 Started!");
    test_number = 2;
    reset_all();
    #1000;
    for(countval = 0; countval < VECLEN; countval = countval + 1) begin
        @(negedge i_clock) begin
            i_rhs_data = rhs_input_vector[countval];
            i_rhs_valid = 1'b1;
            i_lhs_data = lhs_input_vector[countval];
            i_lhs_valid = 1'b1;
            i_sum_ready = 1'b1;
            #10;
        end
    end
    i_rhs_valid = 1'b0;
    i_lhs_valid = 1'b0;
    i_sum_ready = 1'b1;
    #10000;
    i_sum_ready = 1'b0;
    #10;
    if (run_count != VECLEN) begin
        $display("Error: Test 2 failed! Expected 12 outputs, but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 2 Done!");

    // Test 3: lhs lags after rhs
    $display("Test 3 Started!");
    test_number = 3;
    reset_all();
    #1000;
    for(countval = 0; countval < VECLEN; countval = countval + 1) begin
        @(negedge i_clock) begin
            i_rhs_data = rhs_input_vector[countval];
            i_rhs_valid = 1'b1;
            #10;
            i_rhs_data = 0;
            i_rhs_valid = 1'b0;
        end
        @(negedge i_clock) begin
            i_lhs_data = lhs_input_vector[countval];
            i_lhs_valid = 1'b1;
            #10;
            i_lhs_data = 0;
            i_lhs_valid = 1'b0;
        end
        @(negedge i_clock) begin
            i_sum_ready = 1'b1;
            #20;
        end
    end
    i_rhs_valid = 1'b0;
    i_lhs_valid = 1'b0;
    i_sum_ready = 1'b1;
    #10000;
    i_sum_ready = 1'b0;
    #10;
    if (run_count != VECLEN) begin
        $display("Error: Test 3 failed! Expected 12 outputs, but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 3 Done!");

    // Finished
    #10000;
    glbl_err_count = glbl_err_count + local_err_count;
    #10;
    $display("Simulation done!");
    if (glbl_err_count == 0) begin
        $display("SUCCESS!");
    end else begin
        $display("FAILED!");
        $display("Detected %d errors...", glbl_err_count);
    end
    $finish();

end

// Tests the output sequence to make sure it matches the input
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        run_count <= 0;
    end else begin
        // Track number of outputs received
        if ((o_sum_valid == 1'b1) && (i_sum_ready == 1'b1)) begin
            run_count <= run_count + 1;
        end

        if (test_number == 2) begin
            if ((o_sum_valid == 1'b1) && (i_sum_ready == 1'b1)) begin
                if (o_sum_data != sum_output_vector[run_count]) begin
                    $display("Data error detected: Expected %d, but received %d (run_count = %d)",
                            sum_output_vector[run_count], o_sum_data, run_count);
                    local_err_count = local_err_count + 1;
                end
            end
        end
    end
end

endmodule: tb_adder_gf2

`default_nettype wire
