// tb_cic_decim.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_cic_decim;

localparam integer IN_WIDTH = 16;
localparam real PI_VALUE = 4 * $atan(1.0);

localparam integer WIDTH = 55;
localparam integer FACTOR = 313;
localparam integer DELAY = 2;
localparam integer STAGES = 5;

logic [WIDTH-1:0] i_inph_data;
logic [WIDTH-1:0] i_quad_data;
logic             i_valid;
logic [WIDTH-1:0] o_inph_data;
logic [WIDTH-1:0] o_quad_data;
logic             o_valid;
logic             i_clock;
logic             i_reset;

cic_decim #(
    .WIDTH(WIDTH),
    .FACTOR(FACTOR),
    .DELAY(DELAY),
    .STAGES(STAGES))
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
    i_inph_data = 0;
    i_quad_data = 0;
    i_valid = 1'b0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

integer samp_num;

initial begin: stimulus
    i_reset = 1'b1;
    samp_num = 0;
    #1000;
    reset_all();

    // Test 1: No data in = no data out.
    $display("Test 1 Started!");
    test_number = 1;
    reset_all();
    #1000;
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

    // Test 2: Simple Sine In, Simple Sine Out
    $display("Test 1 Started!");
    test_number = 1;
    reset_all();
    #1000;
    samp_num = 0;
    for(integer lcount = 0; lcount < 4*3130; lcount++) begin
        @(negedge i_clock) begin
            i_inph_data <= $rtoi($itor((1 << IN_WIDTH-1) - 1) * $cos(2.0*PI_VALUE*0.01*samp_num));
            i_quad_data <= $rtoi($itor((1 << IN_WIDTH-1) - 1) * $sin(2.0*PI_VALUE*0.01*samp_num));
            i_valid = 1'b1;
            samp_num = samp_num + 1;
            #10;
        end
    end
    i_valid = 1'b0;
    #1000;
    // if (run_count > 0) begin
    //     $display("Error: Test 1 failed! No data input, but data output received.");
    //     glbl_err_count++;
    // end
    // #100;
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
        run_count <= 0;
    end else begin
        // Track number of outputs received
        if (o_valid == 1'b1) begin
            run_count <= run_count + 1;
        end
    end
end

endmodule: tb_cic_decim

`default_nettype wire
