// tb_cic_decim.sv
//

`timescale 10ps / 10ps

`default_nettype none

module tb_cic_decim;

localparam integer IN_WIDTH = 16;
localparam real PI_VALUE = 4 * $atan(1.0);

localparam integer WIDTH = 66;
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

logic                comp_input_ready;
logic [IN_WIDTH-1:0] comp_inph_data;
logic [IN_WIDTH-1:0] comp_quad_data;
logic                comp_inph_pos_oflow;
logic                comp_inph_neg_oflow;
logic                comp_quad_pos_oflow;
logic                comp_quad_neg_oflow;
logic                comp_valid;

// logic [IN_WIDTH-1:0] test_inph_data;
// logic [IN_WIDTH-1:0] test_quad_data;
// logic                test_valid;
// integer           tcount = 0;
// always @(posedge i_clock) begin
//     if (tcount == 312) begin
//         tcount = 0;
//         test_valid <= 1'b1;
//     end else begin
//         tcount++;
//         test_valid <= 1'b0;
//     end

//     test_inph_data <= 1 << 14;
//     test_quad_data <= 1 << 14;
// end

cic_compfir #(
    .WIDTH(IN_WIDTH))
uut2(
    // .i_inph          (test_inph_data     ),
    // .i_quad          (test_quad_data     ),
    // .i_valid         (test_valid         ),
    .i_inph          (16'((o_inph_data[WIDTH-1-:IN_WIDTH+1] + 1'b1) >> 1)),
    .i_quad          (16'((o_quad_data[WIDTH-1-:IN_WIDTH+1] + 1'b1) >> 1)),
    .i_valid         (o_valid                                            ),
    .o_ready         (comp_input_ready                                   ),
    .o_inph          (comp_inph_data                                     ),
    .o_quad          (comp_quad_data                                     ),
    .o_inph_pos_oflow(comp_inph_pos_oflow                                ),
    .o_inph_neg_oflow(comp_inph_neg_oflow                                ),
    .o_quad_pos_oflow(comp_quad_pos_oflow                                ),
    .o_quad_neg_oflow(comp_quad_neg_oflow                                ),
    .o_valid         (comp_valid                                         ),
    .i_clock         (i_clock                                            ),
    .i_reset         (i_reset                                            ));

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

real frequencies [0:4999] = '{ 5000{ 0.0 } };
real passband_mean;
integer freq_count;
integer samp_num;
real fc;


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
    $display("Test 2 Started!");
    test_number = 2;
    reset_all();
    #1000;
    samp_num = 0;
    for(integer lcount = 0; lcount < 4*3130; lcount++) begin
        @(negedge i_clock) begin
            i_inph_data = $rtoi($floor(0.5 + $itor((1 << IN_WIDTH-1) - 1) * $cos(2.0*PI_VALUE*0.00001*samp_num)));
            i_quad_data = $rtoi($floor(0.5 + $itor((1 << IN_WIDTH-1) - 1) * $sin(2.0*PI_VALUE*0.00001*samp_num)));
            i_valid = 1'b1;
            samp_num = samp_num + 1;
            #10;
        end
    end
    i_valid = 1'b0;
    #2000;
    if (run_count != 40) begin
        $display("Error: Test 2 failed! Expected 40 samples at output but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 2 Done!");

    // Test 3: Simple Sine In, Simple Sine Out to File
    $display("Test 3 Started!");
    test_number = 3;
    reset_all();
    #1000;
    samp_num = 0;
    for(integer lcount = 0; lcount < 4000*313; lcount++) begin
        @(negedge i_clock) begin
            i_inph_data = $rtoi($itor((1 << IN_WIDTH-1) - 1) * $cos(2.0*PI_VALUE*0.0001*samp_num));
            i_quad_data = $rtoi($itor((1 << IN_WIDTH-1) - 1) * $sin(2.0*PI_VALUE*0.0001*samp_num));
            i_valid = 1'b1;
            samp_num = samp_num + 1;
            #10;
        end
    end
    i_valid = 1'b0;
    #2000;
    if (run_count != 4000) begin
        $display("Error: Test 3 failed! Expected 4000 samples at output but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 3 Done!");

    // Test 4: Simple Sines In, Simple Sines Out to File
    $display("Test 4 Started!");
    test_number = 4;
    reset_all();
    #1000;
    samp_num = 0;
    for(integer lcount = 0; lcount < 4000*313; lcount++) begin
        @(negedge i_clock) begin
            i_inph_data = $rtoi($itor((1 << IN_WIDTH-1) - 1) * $cos(2.0*PI_VALUE*0.00001*samp_num))
                + $rtoi($itor((1 << IN_WIDTH-2) - 1) * $cos(2.0*PI_VALUE*0.00002*samp_num))
                + $rtoi($itor((1 << IN_WIDTH-3) - 1) * $cos(2.0*PI_VALUE*0.00003*samp_num))
                + $rtoi($itor((1 << IN_WIDTH-4) - 1) * $cos(2.0*PI_VALUE*0.00004*samp_num))
                + $rtoi($itor((1 << IN_WIDTH-5) - 1) * $cos(2.0*PI_VALUE*0.00005*samp_num))
                + $rtoi($itor((1 << IN_WIDTH-1) - 1) * $cos(2.0*PI_VALUE*0.01*samp_num));
            i_quad_data = $rtoi($itor((1 << IN_WIDTH-1) - 1) * $sin(2.0*PI_VALUE*0.00001*samp_num))
                + $rtoi($itor((1 << IN_WIDTH-2) - 1) * $sin(2.0*PI_VALUE*0.00002*samp_num))
                + $rtoi($itor((1 << IN_WIDTH-3) - 1) * $sin(2.0*PI_VALUE*0.00003*samp_num))
                + $rtoi($itor((1 << IN_WIDTH-4) - 1) * $sin(2.0*PI_VALUE*0.00004*samp_num))
                + $rtoi($itor((1 << IN_WIDTH-5) - 1) * $sin(2.0*PI_VALUE*0.00005*samp_num))
                + $rtoi($itor((1 << IN_WIDTH-1) - 1) * $sin(2.0*PI_VALUE*0.01*samp_num));
            i_valid = 1'b1;
            samp_num = samp_num + 1;
            #10;
        end
    end
    i_valid = 1'b0;
    #2000;
    if (run_count != 4000) begin
        $display("Error: Test 4 failed! Expected 4000 samples at output but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 4 Done!");

    // Test 5: Sine sweep to file
    $display("Test 5 Started!");
    test_number = 5;
    for(fc = -0.5/313; fc < 0.5/313; fc = fc + 0.01/313) begin
        $display("    Setting sinusoidal frequency to %f", fc);
        reset_all();
        #1000;
        samp_num = 0;
        for(integer lcount = 0; lcount < 4000*313; lcount++) begin
            @(negedge i_clock) begin
                i_inph_data = $rtoi($itor((1 << IN_WIDTH-1) - 1) * $cos(2.0*PI_VALUE*fc*samp_num));
                i_quad_data = $rtoi($itor((1 << IN_WIDTH-1) - 1) * $sin(2.0*PI_VALUE*fc*samp_num));
                i_valid = 1'b1;
                samp_num = samp_num + 1;
                #10;
            end
        end
        i_valid = 1'b0;
        #2000;
    end
    if (run_count != 4000) begin
        $display("Error: Test 5 failed! Expected 4000 samples at output but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 5 Done!");

/*
    // Test 6: Impulse Response (for human eyes -- comment out for automated testing)
    $display("Test 6 Started!");
    test_number = 6;
    reset_all();
    #1000;
    samp_num = 0;
    for(integer lcount = 0; lcount < 4000; lcount++) begin
        @(negedge i_clock) begin
            if (lcount == 0) begin
                test_inph_data = (1 << IN_WIDTH-3);
                test_quad_data = (1 << IN_WIDTH-3);
            end else begin
                test_inph_data = 0;
                test_quad_data = 0;
            end
            test_valid = 1'b1;
            samp_num = samp_num + 1;
            #10;
            test_valid = 1'b0;
            #3120;
        end
    end
    test_valid = 1'b0;
    #2000;
    if (run_count != 4000) begin
        $display("Error: Test 6 failed! Expected 4000 samples at output but received %d.", run_count);
        glbl_err_count++;
    end
    #100;
    $display("Test 6 Done!");
*/

    // Test the passband ripple is less than 0.5 dB
    passband_mean = 0.0;
    for (integer fcount = 0; fcount < freq_count; fcount++) begin
        passband_mean = passband_mean + frequencies[fcount];
    end
    passband_mean = passband_mean / $itor(freq_count);
    for (integer fcount = 0; fcount < freq_count; fcount++) begin
        if (frequencies[fcount] > passband_mean) begin
            if (20*$log10((frequencies[fcount] - passband_mean)) > 0.5) begin
                $display("Error, ripple in passband exceeds 0.5 dB!");
                glbl_err_count++;
            end
        end else if (frequencies[fcount] < passband_mean) begin
            if (20*$log10((passband_mean - frequencies[fcount])) > 0.5) begin
                $display("Error, ripple in passband exceeds 0.5 dB!");
                glbl_err_count++;
            end
        end
    end

    // Finished
    #10000;
    glbl_err_count = glbl_err_count + local_err_count;
    #100;
    if (glbl_err_count == 0) begin
        $display("<<TB_SUCCESS>>");
    end else begin
        $display("Error count = %d", glbl_err_count);
    end
    $display("Simulation done!");
    $finish();

end

integer fid3;
integer fid4;
integer fid5;

initial begin
    fid3 = $fopen("test3.txt", "w+");
    fid4 = $fopen("test4.txt", "w+");
    fid5 = $fopen("test5.txt", "w+");
end

final begin
    $fclose(fid3);
    $fclose(fid4);
    $fclose(fid5);
end

// Tests the output sequence to make sure it matches the input
real last_frequency;
real magnitude;
real phase;
real inph;
real quad;
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        last_frequency <= -100.0;
        run_count <= 0;
        freq_count <= 0;
    end else begin
        // Track number of outputs received
        if (o_valid == 1'b1) begin
            run_count <= run_count + 1;
            if (test_number == 3) begin
                $fwrite(fid3,"%d, %d\n", $signed(o_inph_data), $signed(o_quad_data));
            end
            if (test_number == 4) begin
                $fwrite(fid4,"%d, %d\n", $signed(o_inph_data), $signed(o_quad_data));
            end
        end
        if (comp_valid == 1'b1) begin
            if (test_number == 5) begin
                if ((samp_num > 3000*313) && (last_frequency != fc)) begin
                    inph = $signed(o_inph_data);
                    quad = $signed(o_quad_data);
                    //$display("%f, %f", inph, quad);
                    magnitude = $sqrt(inph * inph + quad * quad);
                    phase = $atan2(quad, inph);
                    $fwrite(fid5,"%f, %f, %f, ", fc, magnitude, phase);
                    inph = $signed(comp_inph_data);
                    quad = $signed(comp_quad_data);
                    //$display("%f, %f\n", inph, quad);
                    magnitude = $sqrt(inph * inph + quad * quad);
                    phase = $atan2(quad, inph);
                    $fwrite(fid5,"%f, %f\n", magnitude, phase);

                    if ((fc > -0.25/313.0) && (fc < 0.25/313.0)) begin
                        frequencies[freq_count] <= magnitude;
                        freq_count <= freq_count + 1;
                    end

                    last_frequency <= fc;
                end
            end
        end
    end
end

endmodule: tb_cic_decim

`default_nettype wire
