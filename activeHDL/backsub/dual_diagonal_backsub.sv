`timescale 1ps/1ps

`default_nettype none

module dual_diagonal_backsub #(
    parameter integer WIDTH = 8,
    parameter integer NUM_WORDS = 1024
) (
    input  wire logic [WIDTH-1:0] i_in_data,
    input  wire logic             i_in_valid,
    output      logic             o_in_ready,
    output      logic [WIDTH-1:0] o_out_data,
    output      logic             o_out_valid,
    input  wire logic             i_out_ready,
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

logic [$clog2(NUM_WORDS)-1:0] word_count;
logic [WIDTH-1:0]             reg_data_reg;
logic [WIDTH-1:0]             out_data_reg;
logic                         out_valid_reg;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        // Reset state
        out_data_reg <= '0;
        out_valid_reg <= 1'b0;
        word_count <= '0;
        reg_data_reg <= '0;
    end else begin
        if (i_in_valid == 1'b1) begin
            // Reset on vector alignment
            if (word_count == NUM_WORDS-1) begin
                word_count <= '0;
                reg_data_reg <= '0;
            end else begin
                word_count <= word_count + 1;
                reg_data_reg <= reg_data_reg ^ i_in_data;
            end
            // Register output for feedback
            out_data_reg <= reg_data_reg ^ i_in_data;
        end
        // Propagate valid signal
        out_valid_reg <= i_in_valid;
    end
end

assign o_out_data = out_data_reg;
assign o_out_valid = out_valid_reg;

endmodule: dual_diagonal_backsub

`default_nettype wire
