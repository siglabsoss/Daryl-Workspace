// tb_cic_interp.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_cic_interp;

localparam integer IN_WIDTH = 16;

localparam integer WIDTH = 55;
localparam integer FACTOR = 313;
localparam integer DELAY = 2;
localparam integer STAGES = 5;

logic [WIDTH-1:0] i_inph_data;
logic [WIDTH-1:0] i_quad_data;
logic             o_ready;
logic [WIDTH-1:0] o_inph_data;
logic [WIDTH-1:0] o_quad_data;
logic             i_ready;
logic             i_clock;
logic             i_reset;

cic_interp #(
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
    i_ready = 1'b0;
    #1000;
    @(negedge i_clock) i_reset = 1'b0;
endtask: reset_all

initial begin: stimulus
    i_ready = 1'b0;
    i_reset = 1'b1;
    #1000000;
    reset_all();

    // Test 1: No data in = no data out.
    $display("Test 1 Started!");
    test_number = 1;
    reset_all();
    #1000;
    i_ready = 1'b1;
    #1000000;
    i_ready = 1'b0;
    #1000;
    $display("Test 1 Done!");

    // Finished
    #10000;
    glbl_err_count = glbl_err_count + local_err_count;
    $display("Simulation done!");
    $finish();

end

localparam real PI_VALUE = 4 * $atan(1.0);
integer samp_num;
always @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        i_inph_data <= '0;
        i_quad_data <= '0;
        samp_num <= 0;
    end else if (o_ready == 1'b1) begin
        i_inph_data <= $rtoi($itor((1 << IN_WIDTH-1) - 1) * $cos(2.0*PI_VALUE*0.01*samp_num));
        i_quad_data <= $rtoi($itor((1 << IN_WIDTH-1) - 1) * $sin(2.0*PI_VALUE*0.01*samp_num));
        samp_num <= samp_num + 1;
    end
end

endmodule: tb_cic_interp

`default_nettype wire
