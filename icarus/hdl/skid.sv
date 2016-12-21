`timescale 10ps / 10ps

`default_nettype none

module skid #(
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
logic             skid_reg_full;

// enum {
//     ST_START,
//     ST_IDLE,
//     ST_PASSTHRU,
//     ST_HALT
// } curr_state, next_state;
localparam logic [1:0] ST_START    = 2'b00;
localparam logic [1:0] ST_IDLE     = 2'b01;
localparam logic [1:0] ST_PASSTHRU = 2'b10;
localparam logic [1:0] ST_HALT     = 2'b11;
logic [1:0] curr_state;
logic [1:0] next_state;

// Combinatorial outputs of FSM
logic next_out_data;
logic next_out_valid;
logic next_skid_reg;
logic next_skid_reg_full;
logic next_in_ready;

// Register containing same data as output
logic [WIDTH-1:0] out_data_reg;

always @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        #1 curr_state <= ST_START;
        #1 o_out_data <= 0;
        #1 o_out_valid <= 1'b0;
        #1 out_data_reg <= 0;
        #1 skid_reg <= 0;
        #1 skid_reg_full <= 1'b0;
        #1 o_in_ready <= 1'b0;
    end else begin
        // Update state machine
        #1 curr_state <= next_state;
        // Update output interface signals
        #1 o_out_data <= next_out_data;
        #1 out_data_reg <= next_out_data;
        #1 o_out_valid <= next_out_valid;
        // Update skid buffer signals
        #1 skid_reg <= next_skid_reg;
        #1 skid_reg_full <= next_skid_reg_full;
        // Update input interface signals
        #1 o_in_ready <= next_in_ready;
    end
end

always @(*) begin
    case (curr_state)
    ST_IDLE: begin
        next_out_data = i_in_data;
        next_out_valid = i_in_valid;
        next_skid_reg = 0;
        next_skid_reg_full = 1'b0;
        next_in_ready = 1'b1;
        next_state = i_in_valid ? ST_PASSTHRU : ST_IDLE;
    end
    ST_PASSTHRU: begin
        $display("@%d: %d", $stime, i_in_data);
        case ({i_out_ready, i_in_valid})
        2'b11: begin
            next_out_data = i_out_ready ? i_in_data : out_data_reg;
            next_out_valid = ~(i_out_ready & (~i_in_valid));
            next_in_ready = 1'b1;
            next_skid_reg = i_in_data;
            next_skid_reg_full = 1'b0;
            next_state = ST_PASSTHRU;
        end
        2'b10: begin
            next_in_ready = 1'b1;
            next_skid_reg = i_in_data;
            next_skid_reg_full = 1'b0;
            next_state = ST_IDLE;
        end
        2'b01: begin
            next_in_ready = 1'b0;
            next_skid_reg = i_in_data;
            next_skid_reg_full = 1'b1;
            next_state = ST_HALT;

        end
        2'b00: begin
            next_in_ready = 1'b1;
            next_skid_reg = i_in_data;
            next_skid_reg_full = 1'b0;
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
        next_skid_reg_full = ~i_out_ready;
        next_in_ready = i_out_ready;
        next_state = i_out_ready ? ST_PASSTHRU : ST_HALT;
    end
    default: begin
        next_out_data = 0;
        next_out_valid = 1'b0;
        next_skid_reg = 0;
        next_skid_reg_full = 1'b0;
        next_in_ready = 1'b1;
        next_state = ST_IDLE;
    end
    endcase
end

endmodule: skid

`default_nettype wire
