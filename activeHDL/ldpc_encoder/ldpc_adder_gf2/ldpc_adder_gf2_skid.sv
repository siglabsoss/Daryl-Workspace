`timescale 10ps / 10ps

`default_nettype none

module ldpc_adder_gf2_skid #(
    parameter integer WIDTH = 16
) (
    input wire logic                i_clock,
    input wire logic                i_reset,
    // Upstream signaling
    input wire logic [WIDTH-1:0]    i_in_data,
    input wire logic                i_in_valid,
    output     logic                o_in_ready,
    // Downstream signaling
    output     logic [WIDTH-1:0]    o_out_data,
    output     logic                o_out_valid,
    input wire logic                i_out_ready);

// Reserve a place for out stored data, and a
// signal to indicate whether or not it is full.
logic [WIDTH-1:0] skid_reg;

enum {
    ST_START,
    ST_IDLE,
    ST_PASSTHRU,
    ST_HALT
} curr_state, next_state;

// Combinatorial outputs of FSM
logic [WIDTH-1:0] next_out_data;
logic             next_out_valid;
logic [WIDTH-1:0] next_skid_reg;
logic             next_in_ready;

// Register containing same data that is at output
logic [WIDTH-1:0] out_data_reg;

always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        curr_state <= ST_START;
        o_out_valid <= 1'b0;
        out_data_reg <= 0;
        skid_reg <= 0;
        o_in_ready <= 1'b0;
    end else begin
        // Update state machine
        curr_state <= next_state;
        out_data_reg <= next_out_data;
        o_out_valid <= next_out_valid;
        // Update skid buffer signals
        skid_reg <= next_skid_reg;
        // Update input interface signals
        o_in_ready <= next_in_ready;
    end
end

always_comb begin
    case (curr_state)
    ST_IDLE: begin
        next_out_data = i_in_data;
        next_out_valid = i_in_valid;
        next_skid_reg = 0;
        next_in_ready = 1'b1;
        next_state = i_in_valid ? ST_PASSTHRU : ST_IDLE;
    end
    ST_PASSTHRU: begin
        case ({i_out_ready, i_in_valid})
        2'b11: begin
            next_out_data = i_in_data;
            next_out_valid = 1'b1;
            next_in_ready = 1'b1;
            next_skid_reg = i_in_data;
            next_state = ST_PASSTHRU;
        end
        2'b10: begin
            next_out_data = out_data_reg;
            next_out_valid = 1'b0;
            next_in_ready = 1'b1;
            next_skid_reg = i_in_data;
            next_state = ST_IDLE;
        end
        2'b01: begin
            next_out_data = out_data_reg;
            next_out_valid = 1'b0;
            next_in_ready = 1'b0;
            next_skid_reg = i_in_data;
            next_state = ST_HALT;
        end
        2'b00: begin
            next_out_data = out_data_reg;
            next_out_valid = 1'b1;
            next_in_ready = 1'b1;
            next_skid_reg = i_in_data;
            next_state = ST_PASSTHRU;
        end
        default: $display("Error: Reached the unreachable state!");
        endcase
    end
    ST_HALT: begin
        //$display("@%d: %d (not %d)", $stime, i_out_ready ? skid_reg : out_data_reg, (~i_out_ready) ? skid_reg : out_data_reg);
        next_out_data = i_out_ready ? skid_reg : out_data_reg;
        next_out_valid = 1'b1;
        next_skid_reg = skid_reg;
        next_in_ready = i_out_ready;
        next_state = i_out_ready ? ST_PASSTHRU : ST_HALT;
    end
    default: begin
        next_out_data = 0;
        next_out_valid = 1'b0;
        next_skid_reg = 0;
        next_in_ready = 1'b1;
        next_state = ST_IDLE;
    end
    endcase
end

// Wire output data signal to output port
assign o_out_data = out_data_reg;

endmodule: ldpc_adder_gf2_skid

`default_nettype wire
