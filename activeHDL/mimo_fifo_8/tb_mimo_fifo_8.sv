// tb_mimo_fifo_8.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_mimo_fifo_8;

// module params
localparam integer WIDTH = 16;
localparam integer DEPTH = 128;

// Testbench params
localparam integer NUM_INPUTS = 8;
localparam integer NUM_OUTPUTS = 8;

logic [WIDTH-1:0]       i_data [0:NUM_OUTPUTS-1];
logic [2:0]             i_to_branch [0:NUM_OUTPUTS-1];
logic                   i_valid;
logic                   o_ready;
logic [WIDTH-1:0]       o_data [0:NUM_OUTPUTS-1];
logic [NUM_OUTPUTS-1:0] o_valid;
logic                   i_clock;
logic                   i_reset;

mimo_fifo_8 #(
	.WIDTH(WIDTH), 
	.DEPTH(DEPTH)) 
uut (
	.i_data_0     (i_data[0]     ), 
	.i_data_1     (i_data[1]     ),
	.i_data_2     (i_data[2]     ),
	.i_data_3     (i_data[3]     ),
	.i_data_4     (i_data[4]     ),
	.i_data_5     (i_data[5]     ),
	.i_data_6     (i_data[6]     ),
	.i_data_7     (i_data[7]     ),
	.i_to_branch_0(i_to_branch[0]),
	.i_to_branch_1(i_to_branch[1]),
	.i_to_branch_2(i_to_branch[2]),
	.i_to_branch_3(i_to_branch[3]),
	.i_to_branch_4(i_to_branch[4]),
	.i_to_branch_5(i_to_branch[5]),
	.i_to_branch_6(i_to_branch[6]),
	.i_to_branch_7(i_to_branch[7]),
	.i_valid      (i_valid       ),
	.o_ready      (o_ready       ),
	.o_data_0     (o_data[0]     ),
	.o_data_1     (o_data[1]     ),
	.o_data_2     (o_data[2]     ),
	.o_data_3     (o_data[3]     ),
	.o_data_4     (o_data[4]     ),
	.o_data_5     (o_data[5]     ),
	.o_data_6     (o_data[6]     ),
	.o_data_7     (o_data[7]     ),
	.o_valid_0    (o_valid[0]    ),
	.o_valid_1    (o_valid[1]    ),
	.o_valid_2    (o_valid[2]    ),
	.o_valid_3    (o_valid[3]    ),
	.o_valid_4    (o_valid[4]    ),
	.o_valid_5    (o_valid[5]    ),
	.o_valid_6    (o_valid[6]    ),
	.o_valid_7    (o_valid[7]    ));

always begin: clock_gen
    #5 i_clock = 1'b1;
    #5 i_clock = 1'b0;
end

// debug variable declarations
logic [31:0] glbl_err_count = 0;
logic [31:0] test_number = 1;
logic [31:0] run_count [0:NUM_OUTPUTS-1];

// Used by check process, declared here so it
// can be included in the final tall for the
// global error count.
logic [31:0] local_err_count = 0;

task reset_all;
    i_reset = 1'b1;
    for (integer idx = 0; idx < NUM_INPUTS; idx = idx + 1) begin
		i_data[idx] = 0;
		i_to_branch[idx] = 0;
	end
	i_valid = 1'b0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

integer timeout_counter = 0;
task input_on_all(
	input logic [WIDTH-1:0] data_values [0:NUM_INPUTS-1],
	input logic [2:0]       to_branch   [0:NUM_INPUTS-1]
);
	@(negedge i_clock) begin
		if (o_ready == 1'b1) begin
			i_valid = 1'b1;
			#10;
		end else begin
			i_valid = 1'b1;
			#4;
			timeout_counter = 0;
			while ((o_ready == 1'b0) && (timeout_counter < 10000)) begin
				timeout_counter++;
				#10;
			end
			#6;
			if (timeout_counter == 10000) begin
				$display("Error: Write timed out after %d iterations.", timeout_counter);
			end
		end
		i_valid = 1'b0;
	end
endtask:input_on_all;

initial begin: stimulus
    i_reset = 1'b1;
    #1000;
    reset_all();

    // Test 1: No data in = no data out.
    $display("Test 1 Started!");
    test_number = 1;
    reset_all();
    #10000;
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
	    if (run_count[0] > 0) begin
    	    $display("Error: Test 1 failed! No data input, but data output received on %d.", idx);
        	glbl_err_count++;
    	end
    end
    #100;
    $display("Test 1 Done!");

    // Test 2: Port N to port N.
    $display("Test 2 Started!");
    test_number = 2;
    reset_all();
    #1000;
    input_on_all(
    	{ 0, 1, 2, 3, 4, 5, 6, 7 }, 
    	{ 0, 1, 2, 3, 4, 5, 6, 7 }
    );
    #1000;
	for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
	    if (o_data[idx] != idx) begin
    	    $display("Data Error: Expected branch %d to equal %d, but %d received.", 
    	    	idx, idx, o_data[idx]);
        	glbl_err_count++;
    	end
    end
    for (integer idx = 0; idx < NUM_OUTPUTS; idx++) begin
	    if (run_count[idx] != 1) begin
    	    $display("Error: Expected 1 output, but receivd %d outputs.", 
    	    	run_count[idx]);
        	glbl_err_count++;
    	end
    end
    #100;
    $display("Test 2 Done!");

    // Finished
    #10000;
    glbl_err_count = glbl_err_count + local_err_count;
    $display("Simulation done!");
    $finish();

end

// Tests the output sequence to make sure it matches the input
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
    	for (integer idx = 0; idx < NUM_OUTPUTS; idx = idx + 1) begin
	        run_count[idx] <= 0;
	    end
    end else begin
        // Track number of outputs received
        for (integer idx = 0; idx < NUM_OUTPUTS; idx = idx + 1) begin
	        if (o_valid[idx] == 1'b1) begin
	            run_count[idx] <= run_count[idx] + 1;
	        end
	    end
    end
end

endmodule: tb_mimo_fifo_8

`default_nettype wire
