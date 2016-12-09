`timescale 1ps/1ps

`default_nettype none

module dual_diagonal_backsub #(
    parameter integer WIDTH = 8
) (
    input  wire logic [WIDTH-1:0] in_data,
    input  wire logic             in_valid,
    output      logic [WIDTH-1:0] out_data,
    output      logic             out_valid,
    input  wire logic             clock,
    input  wire logic             reset
);

localparam integer NUM_WORDS = 1024;

logic [$clog2(NUM_WORDS)-1:0] word_count;
logic [WIDTH-1:0]             reg_data;

always_ff @ (posedge clock) begin
    if (reset == 1'b1) begin
        // Reset state
        out_valid <= 1'b0;
        word_count <= '0;
        reg_data <= '0;
    end else begin
        if (in_valid == 1'b1) begin
            // Reset on vector alignment
            if (word_count == NUM_WORDS-1) begin
                word_count <= '0;
                reg_data <= '0;
            end else begin
                word_count <= word_count + 1;
                reg_data <= out_data;
            end
            // Register output for feedback
            out_data <= reg_data ^ in_data;
        end
        // Propagate valid signal
        out_valid <= in_valid;
    end
end

endmodule: dual_diagonal_backsub

`default_nettype wire
