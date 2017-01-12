`timescale 1ps / 1ps

`default_nettype none

module sparse_mult_by_C #(
    parameter integer IN_WIDTH = 8,
    parameter integer OUT_WIDTH = 96
) (
    input  wire logic [IN_WIDTH-1:0]   i_input_data,
    input  wire logic                  i_input_valid,
    output      logic                  o_input_ready,
    output      logic [OUT_WIDTH-1:0]  o_output_data,
    output      logic                  o_output_valid,
    input  wire logic                  i_output_ready,
    input  wire logic                  i_clock,
    input  wire logic                  i_reset
);

localparam integer INPUT_LENGTH = 144;
localparam integer OUTPUT_LENGTH = 1;

// Track which buffers are full on current clock cycle
logic ping_is_full;
logic pong_is_full;

typedef enum {
    ST_INIT,
    ST_PING,
    ST_PONG,
    ST_WAIT_FOR_PING,
    ST_WAIT_FOR_PONG
} states_t;

states_t fillup_state;
states_t next_fillup_state;
states_t readout_state;
states_t next_readout_state;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        fillup_state <= ST_INIT;
        readout_state <= ST_INIT;
    end else begin
        fillup_state <= next_fillup_state;
        readout_state <= next_readout_state;
    end
end

logic [$clog2(INPUT_LENGTH)-1:0] input_count;
always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        input_count <= '0;
    end else begin
        if ((i_input_valid & o_input_ready) == 1'b1) begin
            if (input_count >= INPUT_LENGTH - 1) begin
                input_count <= '0;
            end else begin
                input_count <= input_count + 1;
            end
        end
    end
end

// Used for the case structure in the next always block
logic [5:0] ping_pong_test;
logic       last_cycle_in;
assign ping_pong_test = {
    last_cycle_in, 1'b1,
    i_input_valid, o_input_ready,
    o_output_valid, i_output_ready
};
always_ff @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_is_full <= 1'b0;
        pong_is_full <= 1'b0;
    end else begin
        // Calculate when we are on the last cycle of input
        if ((i_input_valid == 1'b1)
                && ((fillup_state == ST_PING)
                    || (fillup_state == ST_PONG))) begin
            last_cycle_in <= input_count == INPUT_LENGTH-2;
        end else begin
            last_cycle_in <= 1'b0;
        end
        // Incdicate when the ping and/or pong buffer is full to FSM
        case (ping_pong_test)
        6'b101100, 6'b101101, 6'b101110, 6'b101111, 6'b111100, 6'b111101, 6'b111110: begin
            if (fillup_state == ST_PING) begin
                ping_is_full <= 1'b1;
            end else begin
                pong_is_full <= 1'b1;
            end
        end
        6'b010011, 6'b010111, 6'b011011, 6'b011111, 6'b110011, 6'b110111, 6'b111011: begin
            if (readout_state == ST_PING) begin
                ping_is_full <= 1'b0;
            end else begin
                pong_is_full <= 1'b0;
            end
        end
        6'b111111:
            if (readout_state == ST_PING) begin
                ping_is_full <= 1'b0;
                pong_is_full <= 1'b1;
            end else begin
                ping_is_full <= 1'b1;
                pong_is_full <= 1'b0;
            end
        default: begin
            ping_is_full <= ping_is_full;
            pong_is_full <= pong_is_full;
        end
        endcase
    end
end

always_comb begin
    case (fillup_state)
    ST_PING: begin
        if ((input_count == INPUT_LENGTH - 1)
                && (i_input_valid == 1'b1)) begin
            next_fillup_state = pong_is_full ? ST_WAIT_FOR_PONG : ST_PONG;
        end else begin
            next_fillup_state = ST_PING;
        end
        o_input_ready = 1'b1;
    end
    ST_PONG: begin
        if ((input_count == INPUT_LENGTH - 1)
                && (i_input_valid == 1'b1)) begin
            next_fillup_state = ping_is_full ? ST_WAIT_FOR_PING : ST_PING;
        end else begin
            next_fillup_state = ST_PONG;
        end
        o_input_ready = 1'b1;
    end
    ST_WAIT_FOR_PING: begin
        if (ping_is_full == 1'b0) begin
            next_fillup_state = ST_PING;
        end else begin
            next_fillup_state = ST_WAIT_FOR_PING;
        end
        o_input_ready = 1'b0;
    end
    ST_WAIT_FOR_PONG: begin
        if (pong_is_full == 1'b0) begin
            next_fillup_state = ST_PONG;
        end else begin
            next_fillup_state = ST_WAIT_FOR_PONG;
        end
        o_input_ready = 1'b0;
    end
    default: begin // ST_INIT
        next_fillup_state = ST_PING;
        o_input_ready = 1'b0;
    end
    endcase
end

always_comb begin
    case (readout_state)
    ST_PING: begin
        if (i_output_ready == 1'b1) begin
            next_readout_state = pong_is_full ? ST_PONG : ST_WAIT_FOR_PONG;
        end else begin
            next_readout_state = ST_PING;
        end
        o_output_data = ping_storage_data;
        o_output_valid = 1'b1;
    end
    ST_PONG: begin
        if (i_output_ready == 1'b1) begin
            next_readout_state = ping_is_full ? ST_PING : ST_WAIT_FOR_PING;
        end else begin
            next_readout_state = ST_PONG;
        end
        o_output_data = pong_storage_data;
        o_output_valid = 1'b1;
    end
    ST_WAIT_FOR_PING: begin
        if (ping_is_full == 1'b1) begin
            next_readout_state = ST_PING;
        end else begin
            next_readout_state = ST_WAIT_FOR_PING;
        end
        o_output_data = 0;
        o_output_valid = 1'b0;
    end
    ST_WAIT_FOR_PONG: begin
        if (pong_is_full == 1'b1) begin
            next_readout_state = ST_PONG;
        end else begin
            next_readout_state = ST_WAIT_FOR_PONG;
        end
        o_output_data = 0;
        o_output_valid = 1'b0;
    end
    default: begin // ST_INIT
        next_readout_state = ST_WAIT_FOR_PING;
        o_output_data = 0;
        o_output_valid = 1'b0;
    end
    endcase
end

logic [WIDTH-1:0] ping_storage_data;
logic [WIDTH-1:0] pong_storage_data;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data <= 0;
        pong_storage_data <= 0;
    end else begin
        if ((fillup_state == ST_PING) && (i_input_valid == 1'b1)) begin
            case (input_count)
            0: ping_storage_data <= {
                i_input_data[WIDTH-43:0],
                i_input_data[WIDTH-1:WIDTH-42]
            };
            5: ping_storage_data <= ping_storage_data ^ {
                i_input_data[WIDTH-66:0],
                i_input_data[WIDTH-1:WIDTH-67]
            };
            7: ping_storage_data <= ping_storage_data ^ {
                i_input_data[WIDTH-41:0],
                i_input_data[WIDTH-1:WIDTH-40]
            };
            11: ping_storage_data <= ping_storage_data ^ {
                i_input_data[WIDTH-26:0],
                i_input_data[WIDTH-1:WIDTH-25]
            };
            endcase
        end
        if ((fillup_state == ST_PONG) && (i_input_valid == 1'b1)) begin
            case (input_count)
            0: pong_storage_data <= {
                i_input_data[WIDTH-43:0],
                i_input_data[WIDTH-1:WIDTH-42]
            };
            5: pong_storage_data <= pong_storage_data ^ {
                i_input_data[WIDTH-66:0],
                i_input_data[WIDTH-1:WIDTH-67]
            };
            7: pong_storage_data <= pong_storage_data ^ {
                i_input_data[WIDTH-41:0],
                i_input_data[WIDTH-1:WIDTH-40]
            };
            11: pong_storage_data <= pong_storage_data ^ {
                i_input_data[WIDTH-26:0],
                i_input_data[WIDTH-1:WIDTH-25]
            };
            endcase
        end
    end
end

endmodule: sparse_mult_by_C

`default_nettype wire
