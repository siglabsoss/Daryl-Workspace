`timescale 10ps / 10ps

`default_nettype none

module distributed_fifo #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 512
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

logic [WIDTH-1:0] buffer [0:DEPTH-1] /* synthesis syn_ramstyle="distributed" */;
logic [$clog2(DEPTH)-1:0] head;
logic [$clog2(DEPTH)-1:0] tail;
logic [$clog2(DEPTH):0] water_level; // difference between head and tail

// Read into buffer
always_ff @(posedge i_clock) begin
    buffer[head] <= i_in_data;
end
// Unregistered read out from buffer
always_comb begin
    o_out_data = buffer[tail];
end

// Increment head/tail counters appropriately
always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        head <= 0;
        tail <= 0;
        water_level <= 0;
    end else begin
        if ((i_in_valid == 1'b1) && (o_in_ready == 1'b1)) begin
            if (head == 2*DEPTH-1) begin
                head <= 0;
            end else begin
                head <= head + 1;
            end
        end
        if ((o_out_valid == 1'b1) && (i_out_ready == 1'b1)) begin
            if (tail == 2*DEPTH-1) begin
                tail <= 0;
            end else begin
                tail <= tail + 1;
            end
        end
        case ({i_in_valid, o_in_ready, o_out_valid, i_out_ready})
        4'b1100, 4'b1110, 4'b1101: water_level <= water_level + 1;
        4'b0011, 4'b0111, 4'b1011: water_level <= water_level - 1;
        default: water_level <= water_level;
        endcase
    end
end

enum {
    ST_INIT,
    ST_EMPTY,
    ST_NORMAL,
    ST_FULL
} curr_state, next_state;

always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        curr_state <= ST_INIT;
    end else begin
        curr_state <= next_state;
    end
end

always_comb begin
    case (curr_state)
    ST_EMPTY: begin
        case ({i_in_valid, i_out_ready})
        2'b11, 2'b10: next_state = ST_NORMAL;
        default: next_state = ST_EMPTY;
        endcase
        o_in_ready = 1'b1;
        o_out_valid = 1'b0;
    end
    ST_NORMAL: begin
        case ({i_in_valid, i_out_ready})
        2'b01: next_state = (water_level == 1) ? ST_EMPTY : ST_NORMAL;
        2'b10: next_state = (water_level == DEPTH - 1) ? ST_FULL : ST_NORMAL;
        default: next_state = ST_NORMAL;
        endcase
        o_in_ready = 1'b1;
        o_out_valid = 1'b1;
    end
    ST_FULL: begin
        case ({i_in_valid, i_out_ready})
        2'b11, 2'b01: next_state = ST_NORMAL;
        default: next_state = ST_FULL;
        endcase
        o_in_ready = 1'b0;
        o_out_valid = 1'b1;
    end
    default: begin // ST_INIT
        next_state = ST_EMPTY;
        o_in_ready = 1'b0;
        o_out_valid = 1'b0;
    end
    endcase
end

endmodule: distributed_fifo

`default_nettype wire