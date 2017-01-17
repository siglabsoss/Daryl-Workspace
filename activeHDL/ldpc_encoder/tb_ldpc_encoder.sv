// tb_ldpc_encoder.sv

`timescale 10ps / 10ps

`default_nettype none

module tb_ldpc_encoder;

localparam integer WIDTH = 8;

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

localparam CLENGTH = 2304;
localparam SLENGTH = CLENGTH / 2;
localparam logic [0:CLENGTH-1] ldpc_codeword_0 = {
    32'b01000111100000001110001001110101,
    32'b10100000101010111101001000011000,
    32'b11010100110011111001001010001011,
    32'b10011011101111110110110010110000,
    32'b10001111000000011100010011101011,
    32'b01000001010101111010010000110001,
    32'b10101001100111110010010100010111,
    32'b00110111011111101101100101100001,
    32'b00011110000000111000100111010110,
    32'b10000010101011110100100001100011,
    32'b01010011001111100100101000101110,
    32'b01101110111111011011001011000010,
    32'b00111100000001110001001110101101,
    32'b00000101010111101001000011000110,
    32'b10100110011111001001010001011100,
    32'b11011101111110110110010110000100,
    32'b01111000000011100010011101011010,
    32'b00001010101111010010000110001101,
    32'b01001100111110010010100010111001,
    32'b10111011111101101100101100001000,
    32'b11110000000111000100111010110100,
    32'b00010101011110100100001100011010,
    32'b10011001111100100101000101110011,
    32'b01110111111011011001011000010001,
    32'b11100000001110001001110101101000,
    32'b00101010111101001000011000110101,
    32'b00110011111001001010001011100110,
    32'b11101111110110110010110000100011,
    32'b11000000011100010011101011010000,
    32'b01010101111010010000110001101010,
    32'b01100111110010010100010111001101,
    32'b11011111101101100101100001000111,
    32'b10000000111000100111010110100000,
    32'b10101011110100100001100011010100,
    32'b11001111100100101000101110011011,
    32'b10111111011011001011000010001111,
    32'b01011000111110110011101001110010,
    32'b00101011001100111010111111011100,
    32'b11011101010101000111001101010001,
    32'b11001011010111111110100110110011,
    32'b10000110110000011011001001001011,
    32'b00000111000001110111101000011100,
    32'b01000100001011100010111100011010,
    32'b10001010101010111101010110000010,
    32'b01000010110010100001011010101100,
    32'b11101001001010110111001010110011,
    32'b01101111001011111010110110001100,
    32'b01100101100100000101010010010000,
    32'b10111111010010111010100000011111,
    32'b10101110100110100010101001111011,
    32'b01011011001110000000111101011110,
    32'b01001010000010010111011001101101,
    32'b00011101100011101001010011010011,
    32'b00000000001110100100011111111011,
    32'b10101010100011010101000110010101,
    32'b01101001011110111001001101010100,
    32'b00010011001110010011110100001101,
    32'b10100111001000011100111001010010,
    32'b00001011111011000100001110101010,
    32'b00101000001011011000001110100101,
    32'b11001100000101111110011100101111,
    32'b01011011010110101100111100100010,
    32'b00111010010100011111010110001100,
    32'b11000100111010100011100000001000,
    32'b00000001010011101100111100011010,
    32'b10100111001110011100001101000111,
    32'b01101110111111001100101110011101,
    32'b10011001011110000111010100110110,
    32'b00101100101100011101000100101100,
    32'b10011101001111110011001101110001,
    32'b11001011100111010101011100110010,
    32'b11101001100111100111101100111010
};

localparam logic [0:CLENGTH-1] ldpc_codeword_1 = {
   32'b10000100001000010000100001000010,
   32'b00010000100001000010000100001000,
   32'b01000010000100001000010000100001,
   32'b00001000010000100001000010000100,
   32'b00100001000010000100001000010000,
   32'b10000100001000010000100001000010,
   32'b00010000100001000010000100001000,
   32'b01000010000100001000010000100001,
   32'b00001000010000100001000010000100,
   32'b00100001000010000100001000010000,
   32'b10000100001000010000100001000010,
   32'b00010000100001000010000100001000,
   32'b01000010000100001000010000100001,
   32'b00001000010000100001000010000100,
   32'b00100001000010000100001000010000,
   32'b10000100001000010000100001000010,
   32'b00010000100001000010000100001000,
   32'b01000010000100001000010000100001,
   32'b00001000010000100001000010000100,
   32'b00100001000010000100001000010000,
   32'b10000100001000010000100001000010,
   32'b00010000100001000010000100001000,
   32'b01000010000100001000010000100001,
   32'b00001000010000100001000010000100,
   32'b00100001000010000100001000010000,
   32'b10000100001000010000100001000010,
   32'b00010000100001000010000100001000,
   32'b01000010000100001000010000100001,
   32'b00001000010000100001000010000100,
   32'b00100001000010000100001000010000,
   32'b10000100001000010000100001000010,
   32'b00010000100001000010000100001000,
   32'b01000010000100001000010000100001,
   32'b00001000010000100001000010000100,
   32'b00100001000010000100001000010000,
   32'b10000100001000010000100001000010,
   32'b01110101110111111101110101000111,
   32'b00100001010011111111111100111011,
   32'b10111101010110101001110101101001,
   32'b00100101010101100101000011000001,
   32'b01010000101101010010001011010111,
   32'b00111101001100001111111101101000,
   32'b00000100010001110101101010110001,
   32'b11010100100101000010101010010101,
   32'b00101101101101001110111111101100,
   32'b10101001001011000000001100011100,
   32'b10100111000010001100110110101100,
   32'b11100011110001110011010100111010,
   32'b11100011011111101001011111011010,
   32'b10010110100001001100110110101000,
   32'b10110001010100111001000000010011,
   32'b10000000011001100101000111101011,
   32'b00011010111001111101010101101110,
   32'b10000000010100111001000110011111,
   32'b10010110101000010100101010011101,
   32'b10110111010001000100100101001101,
   32'b11111011001110001011110101111010,
   32'b10010110101000100111000101000011,
   32'b01000000111110011010010100101110,
   32'b11100011111111101000110011110110,
   32'b10111001110110101011011101110010,
   32'b11001100100110110011000110001011,
   32'b11001010101011000001100001010011,
   32'b01110111101000011110110100101000,
   32'b00011010001010001010111001110100,
   32'b00110101010100111111111101101010,
   32'b10101001010101100101000011000111,
   32'b01100001111101100101100111001111,
   32'b11101001100011010000100011010101,
   32'b01101111000001001100010001100010,
   32'b01001000011110100101100111001111,
   32'b11011000000000010110101111001101
};

localparam logic [0:CLENGTH-1] ldpc_codeword_2 = {
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000,
   32'b00000000000000000000000000000000
};

logic [0:CLENGTH-1] ldpc_encoded_codeword_0;
logic [0:CLENGTH-1] ldpc_encoded_codeword_1;
logic [0:CLENGTH-1] ldpc_encoded_codeword_2;

ldpc_encoder uut (.*);

always begin: clock_gen
    #5 i_clock = 1'b1;
    #5 i_clock = 1'b0;
end

// debug variable declarations
logic [31:0] glbl_err_count = 0;
logic [31:0] test_number = 1;
logic [31:0] run_count = 0;
logic [31:0] count = 0;

// Used by check process, declared here so it
// can be included in the final tall for the
// global error count.
logic [31:0] local_err_count = 0;

task reset_all;
    i_reset = 1'b1;
    i_in_data = 0;
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
    test_number = 1;
    reset_all();
    #1000;
    @(negedge i_clock) begin
        i_in_valid = 1'b0;
        #(10000);
    end
    i_in_valid = 1'b0;
    #1000;
    if (run_count > 0) begin
        $display("Error: Test 1 failed! No data input, but data output received.");
        glbl_err_count++;
    end
    #100;
    $display("Test 1 Done!");

    // Test 2: Produce codeword 0.
    $display("Test 2 Started!");
    test_number = 2;
    reset_all();
    #10000;
    i_out_ready = 1'b1;
    #1000;
    for (count = 0; count < SLENGTH/8; count++) begin
        @(negedge i_clock) begin
            i_in_valid = 1'b1;
            i_in_data = {
                ldpc_codeword_0[count*8 + 7],
                ldpc_codeword_0[count*8 + 6],
                ldpc_codeword_0[count*8 + 5],
                ldpc_codeword_0[count*8 + 4],
                ldpc_codeword_0[count*8 + 3],
                ldpc_codeword_0[count*8 + 2],
                ldpc_codeword_0[count*8 + 1],
                ldpc_codeword_0[count*8    ]
            };
            if (o_in_ready == 1'b1) begin
                #10;
            end else begin
                @(posedge o_in_ready) begin
                    #10;
                end
            end
        end
    end
    i_in_data = 0;
    i_in_valid = 1'b0;
    #(10*(4*CLENGTH));
    i_out_ready = 1'b0;
    #100;
    if (run_count != CLENGTH/8) begin
        $display("Error: Test 2 failed! Expected %d but received %d outputs.", CLENGTH/8, run_count);
        glbl_err_count++;
    end
    $display("Test 2 Done!");

    // Test 3: Produce multiple codewords.
    $display("Test 3 Started!");
    test_number = 3;
    reset_all();
    #10000;
    i_out_ready = 1'b1;
    #1000;
    for (count = 0; count < SLENGTH/8; count++) begin
        @(negedge i_clock) begin
            i_in_valid = 1'b1;
            i_in_data = {
                ldpc_codeword_0[count*8 + 7],
                ldpc_codeword_0[count*8 + 6],
                ldpc_codeword_0[count*8 + 5],
                ldpc_codeword_0[count*8 + 4],
                ldpc_codeword_0[count*8 + 3],
                ldpc_codeword_0[count*8 + 2],
                ldpc_codeword_0[count*8 + 1],
                ldpc_codeword_0[count*8    ]
            };
            if (o_in_ready == 1'b1) begin
                #10;
            end else begin
                @(posedge o_in_ready) begin
                    #10;
                end
            end
        end
    end
    i_in_data = 0;
    i_in_valid = 1'b0;
    #(10*(4*CLENGTH));
    i_out_ready = 1'b1;
    #1000;
    for (count = 0; count < SLENGTH/8; count++) begin
        @(negedge i_clock) begin
            i_in_valid = 1'b1;
            i_in_data = {
                ldpc_codeword_1[count*8 + 7],
                ldpc_codeword_1[count*8 + 6],
                ldpc_codeword_1[count*8 + 5],
                ldpc_codeword_1[count*8 + 4],
                ldpc_codeword_1[count*8 + 3],
                ldpc_codeword_1[count*8 + 2],
                ldpc_codeword_1[count*8 + 1],
                ldpc_codeword_1[count*8    ]
            };
            if (o_in_ready == 1'b1) begin
                #10;
            end else begin
                @(posedge o_in_ready) begin
                    #10;
                end
            end
        end
    end
    i_in_data = 0;
    i_in_valid = 1'b0;
    #(10*(4*CLENGTH));
    i_out_ready = 1'b1;
    #1000;
    for (count = 0; count < SLENGTH/8; count++) begin
        @(negedge i_clock) begin
            i_in_valid = 1'b1;
            i_in_data = {
                ldpc_codeword_2[count*8 + 7],
                ldpc_codeword_2[count*8 + 6],
                ldpc_codeword_2[count*8 + 5],
                ldpc_codeword_2[count*8 + 4],
                ldpc_codeword_2[count*8 + 3],
                ldpc_codeword_2[count*8 + 2],
                ldpc_codeword_2[count*8 + 1],
                ldpc_codeword_2[count*8    ]
            };
            if (o_in_ready == 1'b1) begin
                #10;
            end else begin
                @(posedge o_in_ready) begin
                    #10;
                end
            end
        end
    end
    i_in_data = 0;
    i_in_valid = 1'b0;
    #(10*(4*CLENGTH));
    i_out_ready = 1'b0;
    #100;
    if (run_count != 3 * CLENGTH/8) begin
        $display("Error: Test 3 failed! Expected %d but received %d outputs.", 3 * CLENGTH/8, run_count);
        glbl_err_count++;
    end
    $display("Test 3 Done!");

    // Test 4: Produce multiple codewords with intermittent stimulus.
    $display("Test 4 Started!");
    test_number = 4;
    reset_all();
    #10000;
    i_out_ready = 1'b1;
    #1000;
    for (count = 0; count < SLENGTH/8; count++) begin
        @(negedge i_clock) begin
            i_in_valid = 1'b1;
            i_in_data = {
                ldpc_codeword_0[count*8 + 7],
                ldpc_codeword_0[count*8 + 6],
                ldpc_codeword_0[count*8 + 5],
                ldpc_codeword_0[count*8 + 4],
                ldpc_codeword_0[count*8 + 3],
                ldpc_codeword_0[count*8 + 2],
                ldpc_codeword_0[count*8 + 1],
                ldpc_codeword_0[count*8    ]
            };
            if (o_in_ready == 1'b1) begin
                #10;
            end else begin
                @(posedge o_in_ready) begin
                    #10;
                end
            end
            i_in_valid = 1'b0;
            i_in_data = 0;
            #(10*(count % 3));
        end
    end
    i_in_data = 0;
    i_in_valid = 1'b0;
    #(10*(4*CLENGTH));
    i_out_ready = 1'b1;
    #1000;
    for (count = 0; count < SLENGTH/8; count++) begin
        @(negedge i_clock) begin
            i_in_valid = 1'b1;
            i_in_data = {
                ldpc_codeword_1[count*8 + 7],
                ldpc_codeword_1[count*8 + 6],
                ldpc_codeword_1[count*8 + 5],
                ldpc_codeword_1[count*8 + 4],
                ldpc_codeword_1[count*8 + 3],
                ldpc_codeword_1[count*8 + 2],
                ldpc_codeword_1[count*8 + 1],
                ldpc_codeword_1[count*8    ]
            };
            if (o_in_ready == 1'b1) begin
                #10;
            end else begin
                @(posedge o_in_ready) begin
                    #10;
                end
            end
            i_in_valid = 1'b0;
            i_in_data = 0;
            #(10*(count % 7));
        end
    end
    i_in_data = 0;
    i_in_valid = 1'b0;
    #(10*(4*CLENGTH));
    i_out_ready = 1'b1;
    #1000;
    for (count = 0; count < SLENGTH/8; count++) begin
        @(negedge i_clock) begin
            i_in_valid = 1'b1;
            i_in_data = {
                ldpc_codeword_2[count*8 + 7],
                ldpc_codeword_2[count*8 + 6],
                ldpc_codeword_2[count*8 + 5],
                ldpc_codeword_2[count*8 + 4],
                ldpc_codeword_2[count*8 + 3],
                ldpc_codeword_2[count*8 + 2],
                ldpc_codeword_2[count*8 + 1],
                ldpc_codeword_2[count*8    ]
            };
            if (o_in_ready == 1'b1) begin
                #10;
            end else begin
                @(posedge o_in_ready) begin
                    #10;
                end
            end
            i_in_valid = 1'b0;
            i_in_data = 0;
            #(10*(count % 11));
        end
    end
    i_in_data = 0;
    i_in_valid = 1'b0;
    #(10*(4*CLENGTH));
    i_out_ready = 1'b0;
    #100;
    if (run_count != 3 * CLENGTH/8) begin
        $display("Error: Test 4 failed! Expected %d but received %d outputs.", 3 * CLENGTH/8, run_count);
        glbl_err_count++;
    end
    $display("Test 4 Done!");

    // Finished
    #10000;
    glbl_err_count = glbl_err_count + local_err_count;
    #10;
    $display("Simulation done!");
    if (glbl_err_count > 0) begin
        $display("Found %d errors!", glbl_err_count);
    end else begin
        $display("<< Success! >>");
    end

    // Extract the received codeword for further analysis in MATLAB
    // $display("rx_cwd = [",);
    // for (count = 0; count < CLENGTH; count++) begin
    //     $display("%b", ldpc_encoded_codeword_1[count]);
    // end
    // $display("];",);
    $finish();

end

// Tests the output sequence to make sure it matches the input
logic [7:0] expected_value;
always @(posedge i_clock) begin: seq_check
    if (i_reset == 1'b1) begin
        run_count <= 0;
    end else begin
        // Track number of outputs received
        if ((o_out_valid == 1'b1) && (i_out_ready == 1'b1)) begin
            if (test_number == 2) begin
                expected_value = {
                    ldpc_codeword_0[8 * run_count + 7],
                    ldpc_codeword_0[8 * run_count + 6],
                    ldpc_codeword_0[8 * run_count + 5],
                    ldpc_codeword_0[8 * run_count + 4],
                    ldpc_codeword_0[8 * run_count + 3],
                    ldpc_codeword_0[8 * run_count + 2],
                    ldpc_codeword_0[8 * run_count + 1],
                    ldpc_codeword_0[8 * run_count    ]
                };
                if (o_out_data != expected_value) begin
                    $display("Expected %b but received %b (run_count = %d)",
                        expected_value, o_out_data, run_count);
                    local_err_count++;
                end
                ldpc_encoded_codeword_0[8 * run_count + 7] <= o_out_data[7];
                ldpc_encoded_codeword_0[8 * run_count + 6] <= o_out_data[6];
                ldpc_encoded_codeword_0[8 * run_count + 5] <= o_out_data[5];
                ldpc_encoded_codeword_0[8 * run_count + 4] <= o_out_data[4];
                ldpc_encoded_codeword_0[8 * run_count + 3] <= o_out_data[3];
                ldpc_encoded_codeword_0[8 * run_count + 2] <= o_out_data[2];
                ldpc_encoded_codeword_0[8 * run_count + 1] <= o_out_data[1];
                ldpc_encoded_codeword_0[8 * run_count    ] <= o_out_data[0];
            end

            if ((test_number == 3) || (test_number == 4)) begin
                if (run_count < CLENGTH / 8) begin
                    expected_value = {
                        ldpc_codeword_0[8 * run_count + 7],
                        ldpc_codeword_0[8 * run_count + 6],
                        ldpc_codeword_0[8 * run_count + 5],
                        ldpc_codeword_0[8 * run_count + 4],
                        ldpc_codeword_0[8 * run_count + 3],
                        ldpc_codeword_0[8 * run_count + 2],
                        ldpc_codeword_0[8 * run_count + 1],
                        ldpc_codeword_0[8 * run_count    ]
                    };
                    if (o_out_data != expected_value) begin
                        $display("Expected %b but received %b (run_count = %d)",
                            expected_value, o_out_data, run_count);
                        local_err_count++;
                    end
                end else if (run_count < 2*CLENGTH/8) begin
                    expected_value = {
                        ldpc_codeword_1[8 * (run_count % (CLENGTH/8)) + 7],
                        ldpc_codeword_1[8 * (run_count % (CLENGTH/8)) + 6],
                        ldpc_codeword_1[8 * (run_count % (CLENGTH/8)) + 5],
                        ldpc_codeword_1[8 * (run_count % (CLENGTH/8)) + 4],
                        ldpc_codeword_1[8 * (run_count % (CLENGTH/8)) + 3],
                        ldpc_codeword_1[8 * (run_count % (CLENGTH/8)) + 2],
                        ldpc_codeword_1[8 * (run_count % (CLENGTH/8)) + 1],
                        ldpc_codeword_1[8 * (run_count % (CLENGTH/8))    ]
                    };
                    if (o_out_data != expected_value) begin
                        $display("Expected %b but received %b (run_count = %d)",
                            expected_value, o_out_data, run_count);
                        local_err_count++;
                    end
                    ldpc_encoded_codeword_1[8 * (run_count % (CLENGTH/8)) + 7] <= o_out_data[7];
                    ldpc_encoded_codeword_1[8 * (run_count % (CLENGTH/8)) + 6] <= o_out_data[6];
                    ldpc_encoded_codeword_1[8 * (run_count % (CLENGTH/8)) + 5] <= o_out_data[5];
                    ldpc_encoded_codeword_1[8 * (run_count % (CLENGTH/8)) + 4] <= o_out_data[4];
                    ldpc_encoded_codeword_1[8 * (run_count % (CLENGTH/8)) + 3] <= o_out_data[3];
                    ldpc_encoded_codeword_1[8 * (run_count % (CLENGTH/8)) + 2] <= o_out_data[2];
                    ldpc_encoded_codeword_1[8 * (run_count % (CLENGTH/8)) + 1] <= o_out_data[1];
                    ldpc_encoded_codeword_1[8 * (run_count % (CLENGTH/8))    ] <= o_out_data[0];
                end else if (run_count < 3*CLENGTH/8) begin
                    expected_value = {
                        ldpc_codeword_2[8 * (run_count % (CLENGTH/8)) + 7],
                        ldpc_codeword_2[8 * (run_count % (CLENGTH/8)) + 6],
                        ldpc_codeword_2[8 * (run_count % (CLENGTH/8)) + 5],
                        ldpc_codeword_2[8 * (run_count % (CLENGTH/8)) + 4],
                        ldpc_codeword_2[8 * (run_count % (CLENGTH/8)) + 3],
                        ldpc_codeword_2[8 * (run_count % (CLENGTH/8)) + 2],
                        ldpc_codeword_2[8 * (run_count % (CLENGTH/8)) + 1],
                        ldpc_codeword_2[8 * (run_count % (CLENGTH/8))    ]
                    };
                    if (o_out_data != expected_value) begin
                        $display("Expected %b but received %b (run_count = %d)",
                            expected_value, o_out_data, run_count);
                        local_err_count++;
                    end
                    ldpc_encoded_codeword_2[8 * (run_count % (CLENGTH/8)) + 7] <= o_out_data[7];
                    ldpc_encoded_codeword_2[8 * (run_count % (CLENGTH/8)) + 6] <= o_out_data[6];
                    ldpc_encoded_codeword_2[8 * (run_count % (CLENGTH/8)) + 5] <= o_out_data[5];
                    ldpc_encoded_codeword_2[8 * (run_count % (CLENGTH/8)) + 4] <= o_out_data[4];
                    ldpc_encoded_codeword_2[8 * (run_count % (CLENGTH/8)) + 3] <= o_out_data[3];
                    ldpc_encoded_codeword_2[8 * (run_count % (CLENGTH/8)) + 2] <= o_out_data[2];
                    ldpc_encoded_codeword_2[8 * (run_count % (CLENGTH/8)) + 1] <= o_out_data[1];
                    ldpc_encoded_codeword_2[8 * (run_count % (CLENGTH/8))    ] <= o_out_data[0];
                end
            end
            run_count <= run_count + 1;
        end
    end
end

endmodule: tb_ldpc_encoder

`default_nettype wire
