// Generated from template on 06/01/2017.
`timescale 1ps / 1ps

`default_nettype none

module sparse_mult #(
    parameter integer IN_WIDTH = 8,  // SHOULD BE A POWER OF 2
    parameter integer OUT_WIDTH = 96  // SHOULD BE A POWER OF 2
) (
    input  wire logic [IN_WIDTH-1:0]    i_data,
    input  wire logic                   i_valid,
    output      logic                   o_ready,
    output      logic [OUT_WIDTH-1:0]   o_data,
    output      logic                   o_valid,
    input  wire logic                   i_ready,
    input  wire logic                   i_clock,
    input  wire logic                   i_reset
);

localparam integer INPUT_LENGTH = 10;
localparam integer OUTPUT_LENGTH = 10;

// Track which buffer is currently input
logic input_is_ping;
// Track which buffer is currently output
logic output_is_ping;
// Track which buffers are full on current clock cycle
logic ping_is_full;
logic pong_is_full;
// Track which buffers are full on last clock cycle
logic ping_was_full;
logic pong_was_full;

typedef enum {
    ST_INIT,
    ST_PING,
    ST_PONG,
    ST_WAIT
} states_t;

states_t fillup_state, next_fillup_state;
states_t readout_state, next_readout_state;

always_ff @ (posedge clock) begin
    if (reset == 1'b1) begin
        fillup_state <= ST_INIT;
        readout_state <= ST_INIT;
    end else begin
        fillup_state <= next_fillup_state;
        readout_state <= next_readout_state;
    end
end

logic [$clog2(INPUT_LENGTH)-1:0] input_counter;
logic [$clog2(OUTPUT_LENGTH)-1:0] output_counter;
always_ff @ (posedge clock) begin
    if (reset == 1'b1) begin
        input_counter <= '0;
        output_counter <= '0;
    end else begin
        if ((input_valid & input_ready) == 1'b1) begin
            if (input_count >= INPUT_LENGTH - 1) begin
                input_count <= '0;
            end else begin
                input_counter <= input_counter + 1;
            end
        end
        if ((output_valid & output_ready) == 1'b1) begin
            if (output_count >= OUTPUT_LENGTH - 1) begin
                output_count <= '0;
            end else begin
                output_counter <= output_counter + 1;
            end
        end
    end
end

always_comb begin
    case (fillup_state)
    ST_PING: begin
        if ((input_counter == INPUT_LENGTH - 1)
                && (input_valid == 1'b1)) begin
            next_fillup_state = pong_is_full ? ST_WAIT : ST_PONG;
        end
        input_ready = 1'b1;
    end
    ST_PONG: begin
        if ((input_counter == INPUT_LENGTH - 1)
                && (input_valid == 1'b1)) begin
            next_fillup_state = ping_is_full ? ST_WAIT : ST_PING;
        end
        input_ready = 1'b1;
    end
    ST_WAIT: begin
        if (ping_is_full == 1'b0) begin
            next_fillup_state = ST_PING;
        end else if (pong_is_full == 1'b0) begin
            next_fillup_state = ST_PONG;
        end else begin
            next_fillup_state = ST_WAIT;
        end
        input_ready = 1'b0;
    end
    default: begin // ST_INIT
        next_fillup_state = ST_PING;
        input_ready = 1'b0;
    end
    endcase
end

always_comb begin
    case (readout_state)
    ST_PING: begin
        if ((output_counter == OUTPUT_LENGTH - 1)
                && (output_ready == 1'b1)) begin
            next_readout_state = ping_is_full ? ST_PING : ST_WAIT;
        end
        output_valid = 1'b1;
    end
    ST_PONG: begin
        if ((output_counter == OUTPUT_LENGTH - 1)
                && (output_ready == 1'b1)) begin
            next_readout_state = ping_is_full ? ST_PING : ST_WAIT;
        end
        output_valid = 1'b1;
    end
    ST_WAIT: begin
        if (ping_is_full == 1'b1) begin
            next_readout_state = ST_PING;
        end else if (pong_is_full == 1'b1) begin
            next_readout_state = ST_PONG;
        end else begin
            next_readout_state = ST_WAIT;
        end
        output_valid = 1'b0;
    end
    default: begin // ST_INIT
        next_readout_state = ST_WAIT;
        output_valid = 1'b0;
    end
    endcase
end

logic ping_storage_data_0;
logic pong_storage_data_0;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            98 / IN_WIDTH: ping_storage_data_0 <= ping_storage_data_0 ^ input_data(98 % IN_WIDTH);
            215 / IN_WIDTH: ping_storage_data_0 <= ping_storage_data_0 ^ input_data(215 % IN_WIDTH);
            809 / IN_WIDTH: ping_storage_data_0 <= ping_storage_data_0 ^ input_data(809 % IN_WIDTH);
            877 / IN_WIDTH: ping_storage_data_0 <= ping_storage_data_0 ^ input_data(877 % IN_WIDTH);
            default: pong_storage_data_0 <= pong_storage_data_0;
            endcase
        end else begin
            case (input_count)
            98 / IN_WIDTH: pong_storage_data_0 <= pong_storage_data_0 ^ input_data(98 % IN_WIDTH);
            215 / IN_WIDTH: pong_storage_data_0 <= pong_storage_data_0 ^ input_data(215 % IN_WIDTH);
            809 / IN_WIDTH: pong_storage_data_0 <= pong_storage_data_0 ^ input_data(809 % IN_WIDTH);
            877 / IN_WIDTH: pong_storage_data_0 <= pong_storage_data_0 ^ input_data(877 % IN_WIDTH);
            default: pong_storage_data_0 <= pong_storage_data_0;
            endcase
        end
    end
end

logic ping_storage_data_1;
logic pong_storage_data_1;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            99 / IN_WIDTH: ping_storage_data_1 <= ping_storage_data_1 ^ input_data(99 % IN_WIDTH);
            216 / IN_WIDTH: ping_storage_data_1 <= ping_storage_data_1 ^ input_data(216 % IN_WIDTH);
            810 / IN_WIDTH: ping_storage_data_1 <= ping_storage_data_1 ^ input_data(810 % IN_WIDTH);
            878 / IN_WIDTH: ping_storage_data_1 <= ping_storage_data_1 ^ input_data(878 % IN_WIDTH);
            default: pong_storage_data_1 <= pong_storage_data_1;
            endcase
        end else begin
            case (input_count)
            99 / IN_WIDTH: pong_storage_data_1 <= pong_storage_data_1 ^ input_data(99 % IN_WIDTH);
            216 / IN_WIDTH: pong_storage_data_1 <= pong_storage_data_1 ^ input_data(216 % IN_WIDTH);
            810 / IN_WIDTH: pong_storage_data_1 <= pong_storage_data_1 ^ input_data(810 % IN_WIDTH);
            878 / IN_WIDTH: pong_storage_data_1 <= pong_storage_data_1 ^ input_data(878 % IN_WIDTH);
            default: pong_storage_data_1 <= pong_storage_data_1;
            endcase
        end
    end
end

logic ping_storage_data_2;
logic pong_storage_data_2;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            100 / IN_WIDTH: ping_storage_data_2 <= ping_storage_data_2 ^ input_data(100 % IN_WIDTH);
            217 / IN_WIDTH: ping_storage_data_2 <= ping_storage_data_2 ^ input_data(217 % IN_WIDTH);
            811 / IN_WIDTH: ping_storage_data_2 <= ping_storage_data_2 ^ input_data(811 % IN_WIDTH);
            879 / IN_WIDTH: ping_storage_data_2 <= ping_storage_data_2 ^ input_data(879 % IN_WIDTH);
            default: pong_storage_data_2 <= pong_storage_data_2;
            endcase
        end else begin
            case (input_count)
            100 / IN_WIDTH: pong_storage_data_2 <= pong_storage_data_2 ^ input_data(100 % IN_WIDTH);
            217 / IN_WIDTH: pong_storage_data_2 <= pong_storage_data_2 ^ input_data(217 % IN_WIDTH);
            811 / IN_WIDTH: pong_storage_data_2 <= pong_storage_data_2 ^ input_data(811 % IN_WIDTH);
            879 / IN_WIDTH: pong_storage_data_2 <= pong_storage_data_2 ^ input_data(879 % IN_WIDTH);
            default: pong_storage_data_2 <= pong_storage_data_2;
            endcase
        end
    end
end

logic ping_storage_data_3;
logic pong_storage_data_3;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            101 / IN_WIDTH: ping_storage_data_3 <= ping_storage_data_3 ^ input_data(101 % IN_WIDTH);
            218 / IN_WIDTH: ping_storage_data_3 <= ping_storage_data_3 ^ input_data(218 % IN_WIDTH);
            812 / IN_WIDTH: ping_storage_data_3 <= ping_storage_data_3 ^ input_data(812 % IN_WIDTH);
            880 / IN_WIDTH: ping_storage_data_3 <= ping_storage_data_3 ^ input_data(880 % IN_WIDTH);
            default: pong_storage_data_3 <= pong_storage_data_3;
            endcase
        end else begin
            case (input_count)
            101 / IN_WIDTH: pong_storage_data_3 <= pong_storage_data_3 ^ input_data(101 % IN_WIDTH);
            218 / IN_WIDTH: pong_storage_data_3 <= pong_storage_data_3 ^ input_data(218 % IN_WIDTH);
            812 / IN_WIDTH: pong_storage_data_3 <= pong_storage_data_3 ^ input_data(812 % IN_WIDTH);
            880 / IN_WIDTH: pong_storage_data_3 <= pong_storage_data_3 ^ input_data(880 % IN_WIDTH);
            default: pong_storage_data_3 <= pong_storage_data_3;
            endcase
        end
    end
end

logic ping_storage_data_4;
logic pong_storage_data_4;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            102 / IN_WIDTH: ping_storage_data_4 <= ping_storage_data_4 ^ input_data(102 % IN_WIDTH);
            219 / IN_WIDTH: ping_storage_data_4 <= ping_storage_data_4 ^ input_data(219 % IN_WIDTH);
            813 / IN_WIDTH: ping_storage_data_4 <= ping_storage_data_4 ^ input_data(813 % IN_WIDTH);
            881 / IN_WIDTH: ping_storage_data_4 <= ping_storage_data_4 ^ input_data(881 % IN_WIDTH);
            default: pong_storage_data_4 <= pong_storage_data_4;
            endcase
        end else begin
            case (input_count)
            102 / IN_WIDTH: pong_storage_data_4 <= pong_storage_data_4 ^ input_data(102 % IN_WIDTH);
            219 / IN_WIDTH: pong_storage_data_4 <= pong_storage_data_4 ^ input_data(219 % IN_WIDTH);
            813 / IN_WIDTH: pong_storage_data_4 <= pong_storage_data_4 ^ input_data(813 % IN_WIDTH);
            881 / IN_WIDTH: pong_storage_data_4 <= pong_storage_data_4 ^ input_data(881 % IN_WIDTH);
            default: pong_storage_data_4 <= pong_storage_data_4;
            endcase
        end
    end
end

logic ping_storage_data_5;
logic pong_storage_data_5;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            103 / IN_WIDTH: ping_storage_data_5 <= ping_storage_data_5 ^ input_data(103 % IN_WIDTH);
            220 / IN_WIDTH: ping_storage_data_5 <= ping_storage_data_5 ^ input_data(220 % IN_WIDTH);
            814 / IN_WIDTH: ping_storage_data_5 <= ping_storage_data_5 ^ input_data(814 % IN_WIDTH);
            882 / IN_WIDTH: ping_storage_data_5 <= ping_storage_data_5 ^ input_data(882 % IN_WIDTH);
            default: pong_storage_data_5 <= pong_storage_data_5;
            endcase
        end else begin
            case (input_count)
            103 / IN_WIDTH: pong_storage_data_5 <= pong_storage_data_5 ^ input_data(103 % IN_WIDTH);
            220 / IN_WIDTH: pong_storage_data_5 <= pong_storage_data_5 ^ input_data(220 % IN_WIDTH);
            814 / IN_WIDTH: pong_storage_data_5 <= pong_storage_data_5 ^ input_data(814 % IN_WIDTH);
            882 / IN_WIDTH: pong_storage_data_5 <= pong_storage_data_5 ^ input_data(882 % IN_WIDTH);
            default: pong_storage_data_5 <= pong_storage_data_5;
            endcase
        end
    end
end

logic ping_storage_data_6;
logic pong_storage_data_6;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            104 / IN_WIDTH: ping_storage_data_6 <= ping_storage_data_6 ^ input_data(104 % IN_WIDTH);
            221 / IN_WIDTH: ping_storage_data_6 <= ping_storage_data_6 ^ input_data(221 % IN_WIDTH);
            815 / IN_WIDTH: ping_storage_data_6 <= ping_storage_data_6 ^ input_data(815 % IN_WIDTH);
            883 / IN_WIDTH: ping_storage_data_6 <= ping_storage_data_6 ^ input_data(883 % IN_WIDTH);
            default: pong_storage_data_6 <= pong_storage_data_6;
            endcase
        end else begin
            case (input_count)
            104 / IN_WIDTH: pong_storage_data_6 <= pong_storage_data_6 ^ input_data(104 % IN_WIDTH);
            221 / IN_WIDTH: pong_storage_data_6 <= pong_storage_data_6 ^ input_data(221 % IN_WIDTH);
            815 / IN_WIDTH: pong_storage_data_6 <= pong_storage_data_6 ^ input_data(815 % IN_WIDTH);
            883 / IN_WIDTH: pong_storage_data_6 <= pong_storage_data_6 ^ input_data(883 % IN_WIDTH);
            default: pong_storage_data_6 <= pong_storage_data_6;
            endcase
        end
    end
end

logic ping_storage_data_7;
logic pong_storage_data_7;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            105 / IN_WIDTH: ping_storage_data_7 <= ping_storage_data_7 ^ input_data(105 % IN_WIDTH);
            222 / IN_WIDTH: ping_storage_data_7 <= ping_storage_data_7 ^ input_data(222 % IN_WIDTH);
            816 / IN_WIDTH: ping_storage_data_7 <= ping_storage_data_7 ^ input_data(816 % IN_WIDTH);
            884 / IN_WIDTH: ping_storage_data_7 <= ping_storage_data_7 ^ input_data(884 % IN_WIDTH);
            default: pong_storage_data_7 <= pong_storage_data_7;
            endcase
        end else begin
            case (input_count)
            105 / IN_WIDTH: pong_storage_data_7 <= pong_storage_data_7 ^ input_data(105 % IN_WIDTH);
            222 / IN_WIDTH: pong_storage_data_7 <= pong_storage_data_7 ^ input_data(222 % IN_WIDTH);
            816 / IN_WIDTH: pong_storage_data_7 <= pong_storage_data_7 ^ input_data(816 % IN_WIDTH);
            884 / IN_WIDTH: pong_storage_data_7 <= pong_storage_data_7 ^ input_data(884 % IN_WIDTH);
            default: pong_storage_data_7 <= pong_storage_data_7;
            endcase
        end
    end
end

logic ping_storage_data_8;
logic pong_storage_data_8;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            106 / IN_WIDTH: ping_storage_data_8 <= ping_storage_data_8 ^ input_data(106 % IN_WIDTH);
            223 / IN_WIDTH: ping_storage_data_8 <= ping_storage_data_8 ^ input_data(223 % IN_WIDTH);
            817 / IN_WIDTH: ping_storage_data_8 <= ping_storage_data_8 ^ input_data(817 % IN_WIDTH);
            885 / IN_WIDTH: ping_storage_data_8 <= ping_storage_data_8 ^ input_data(885 % IN_WIDTH);
            default: pong_storage_data_8 <= pong_storage_data_8;
            endcase
        end else begin
            case (input_count)
            106 / IN_WIDTH: pong_storage_data_8 <= pong_storage_data_8 ^ input_data(106 % IN_WIDTH);
            223 / IN_WIDTH: pong_storage_data_8 <= pong_storage_data_8 ^ input_data(223 % IN_WIDTH);
            817 / IN_WIDTH: pong_storage_data_8 <= pong_storage_data_8 ^ input_data(817 % IN_WIDTH);
            885 / IN_WIDTH: pong_storage_data_8 <= pong_storage_data_8 ^ input_data(885 % IN_WIDTH);
            default: pong_storage_data_8 <= pong_storage_data_8;
            endcase
        end
    end
end

logic ping_storage_data_9;
logic pong_storage_data_9;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            107 / IN_WIDTH: ping_storage_data_9 <= ping_storage_data_9 ^ input_data(107 % IN_WIDTH);
            224 / IN_WIDTH: ping_storage_data_9 <= ping_storage_data_9 ^ input_data(224 % IN_WIDTH);
            818 / IN_WIDTH: ping_storage_data_9 <= ping_storage_data_9 ^ input_data(818 % IN_WIDTH);
            886 / IN_WIDTH: ping_storage_data_9 <= ping_storage_data_9 ^ input_data(886 % IN_WIDTH);
            default: pong_storage_data_9 <= pong_storage_data_9;
            endcase
        end else begin
            case (input_count)
            107 / IN_WIDTH: pong_storage_data_9 <= pong_storage_data_9 ^ input_data(107 % IN_WIDTH);
            224 / IN_WIDTH: pong_storage_data_9 <= pong_storage_data_9 ^ input_data(224 % IN_WIDTH);
            818 / IN_WIDTH: pong_storage_data_9 <= pong_storage_data_9 ^ input_data(818 % IN_WIDTH);
            886 / IN_WIDTH: pong_storage_data_9 <= pong_storage_data_9 ^ input_data(886 % IN_WIDTH);
            default: pong_storage_data_9 <= pong_storage_data_9;
            endcase
        end
    end
end

logic ping_storage_data_10;
logic pong_storage_data_10;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            108 / IN_WIDTH: ping_storage_data_10 <= ping_storage_data_10 ^ input_data(108 % IN_WIDTH);
            225 / IN_WIDTH: ping_storage_data_10 <= ping_storage_data_10 ^ input_data(225 % IN_WIDTH);
            819 / IN_WIDTH: ping_storage_data_10 <= ping_storage_data_10 ^ input_data(819 % IN_WIDTH);
            887 / IN_WIDTH: ping_storage_data_10 <= ping_storage_data_10 ^ input_data(887 % IN_WIDTH);
            default: pong_storage_data_10 <= pong_storage_data_10;
            endcase
        end else begin
            case (input_count)
            108 / IN_WIDTH: pong_storage_data_10 <= pong_storage_data_10 ^ input_data(108 % IN_WIDTH);
            225 / IN_WIDTH: pong_storage_data_10 <= pong_storage_data_10 ^ input_data(225 % IN_WIDTH);
            819 / IN_WIDTH: pong_storage_data_10 <= pong_storage_data_10 ^ input_data(819 % IN_WIDTH);
            887 / IN_WIDTH: pong_storage_data_10 <= pong_storage_data_10 ^ input_data(887 % IN_WIDTH);
            default: pong_storage_data_10 <= pong_storage_data_10;
            endcase
        end
    end
end

logic ping_storage_data_11;
logic pong_storage_data_11;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            109 / IN_WIDTH: ping_storage_data_11 <= ping_storage_data_11 ^ input_data(109 % IN_WIDTH);
            226 / IN_WIDTH: ping_storage_data_11 <= ping_storage_data_11 ^ input_data(226 % IN_WIDTH);
            820 / IN_WIDTH: ping_storage_data_11 <= ping_storage_data_11 ^ input_data(820 % IN_WIDTH);
            888 / IN_WIDTH: ping_storage_data_11 <= ping_storage_data_11 ^ input_data(888 % IN_WIDTH);
            default: pong_storage_data_11 <= pong_storage_data_11;
            endcase
        end else begin
            case (input_count)
            109 / IN_WIDTH: pong_storage_data_11 <= pong_storage_data_11 ^ input_data(109 % IN_WIDTH);
            226 / IN_WIDTH: pong_storage_data_11 <= pong_storage_data_11 ^ input_data(226 % IN_WIDTH);
            820 / IN_WIDTH: pong_storage_data_11 <= pong_storage_data_11 ^ input_data(820 % IN_WIDTH);
            888 / IN_WIDTH: pong_storage_data_11 <= pong_storage_data_11 ^ input_data(888 % IN_WIDTH);
            default: pong_storage_data_11 <= pong_storage_data_11;
            endcase
        end
    end
end

logic ping_storage_data_12;
logic pong_storage_data_12;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            110 / IN_WIDTH: ping_storage_data_12 <= ping_storage_data_12 ^ input_data(110 % IN_WIDTH);
            227 / IN_WIDTH: ping_storage_data_12 <= ping_storage_data_12 ^ input_data(227 % IN_WIDTH);
            821 / IN_WIDTH: ping_storage_data_12 <= ping_storage_data_12 ^ input_data(821 % IN_WIDTH);
            889 / IN_WIDTH: ping_storage_data_12 <= ping_storage_data_12 ^ input_data(889 % IN_WIDTH);
            default: pong_storage_data_12 <= pong_storage_data_12;
            endcase
        end else begin
            case (input_count)
            110 / IN_WIDTH: pong_storage_data_12 <= pong_storage_data_12 ^ input_data(110 % IN_WIDTH);
            227 / IN_WIDTH: pong_storage_data_12 <= pong_storage_data_12 ^ input_data(227 % IN_WIDTH);
            821 / IN_WIDTH: pong_storage_data_12 <= pong_storage_data_12 ^ input_data(821 % IN_WIDTH);
            889 / IN_WIDTH: pong_storage_data_12 <= pong_storage_data_12 ^ input_data(889 % IN_WIDTH);
            default: pong_storage_data_12 <= pong_storage_data_12;
            endcase
        end
    end
end

logic ping_storage_data_13;
logic pong_storage_data_13;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            111 / IN_WIDTH: ping_storage_data_13 <= ping_storage_data_13 ^ input_data(111 % IN_WIDTH);
            228 / IN_WIDTH: ping_storage_data_13 <= ping_storage_data_13 ^ input_data(228 % IN_WIDTH);
            822 / IN_WIDTH: ping_storage_data_13 <= ping_storage_data_13 ^ input_data(822 % IN_WIDTH);
            890 / IN_WIDTH: ping_storage_data_13 <= ping_storage_data_13 ^ input_data(890 % IN_WIDTH);
            default: pong_storage_data_13 <= pong_storage_data_13;
            endcase
        end else begin
            case (input_count)
            111 / IN_WIDTH: pong_storage_data_13 <= pong_storage_data_13 ^ input_data(111 % IN_WIDTH);
            228 / IN_WIDTH: pong_storage_data_13 <= pong_storage_data_13 ^ input_data(228 % IN_WIDTH);
            822 / IN_WIDTH: pong_storage_data_13 <= pong_storage_data_13 ^ input_data(822 % IN_WIDTH);
            890 / IN_WIDTH: pong_storage_data_13 <= pong_storage_data_13 ^ input_data(890 % IN_WIDTH);
            default: pong_storage_data_13 <= pong_storage_data_13;
            endcase
        end
    end
end

logic ping_storage_data_14;
logic pong_storage_data_14;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            112 / IN_WIDTH: ping_storage_data_14 <= ping_storage_data_14 ^ input_data(112 % IN_WIDTH);
            229 / IN_WIDTH: ping_storage_data_14 <= ping_storage_data_14 ^ input_data(229 % IN_WIDTH);
            823 / IN_WIDTH: ping_storage_data_14 <= ping_storage_data_14 ^ input_data(823 % IN_WIDTH);
            891 / IN_WIDTH: ping_storage_data_14 <= ping_storage_data_14 ^ input_data(891 % IN_WIDTH);
            default: pong_storage_data_14 <= pong_storage_data_14;
            endcase
        end else begin
            case (input_count)
            112 / IN_WIDTH: pong_storage_data_14 <= pong_storage_data_14 ^ input_data(112 % IN_WIDTH);
            229 / IN_WIDTH: pong_storage_data_14 <= pong_storage_data_14 ^ input_data(229 % IN_WIDTH);
            823 / IN_WIDTH: pong_storage_data_14 <= pong_storage_data_14 ^ input_data(823 % IN_WIDTH);
            891 / IN_WIDTH: pong_storage_data_14 <= pong_storage_data_14 ^ input_data(891 % IN_WIDTH);
            default: pong_storage_data_14 <= pong_storage_data_14;
            endcase
        end
    end
end

logic ping_storage_data_15;
logic pong_storage_data_15;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            113 / IN_WIDTH: ping_storage_data_15 <= ping_storage_data_15 ^ input_data(113 % IN_WIDTH);
            230 / IN_WIDTH: ping_storage_data_15 <= ping_storage_data_15 ^ input_data(230 % IN_WIDTH);
            824 / IN_WIDTH: ping_storage_data_15 <= ping_storage_data_15 ^ input_data(824 % IN_WIDTH);
            892 / IN_WIDTH: ping_storage_data_15 <= ping_storage_data_15 ^ input_data(892 % IN_WIDTH);
            default: pong_storage_data_15 <= pong_storage_data_15;
            endcase
        end else begin
            case (input_count)
            113 / IN_WIDTH: pong_storage_data_15 <= pong_storage_data_15 ^ input_data(113 % IN_WIDTH);
            230 / IN_WIDTH: pong_storage_data_15 <= pong_storage_data_15 ^ input_data(230 % IN_WIDTH);
            824 / IN_WIDTH: pong_storage_data_15 <= pong_storage_data_15 ^ input_data(824 % IN_WIDTH);
            892 / IN_WIDTH: pong_storage_data_15 <= pong_storage_data_15 ^ input_data(892 % IN_WIDTH);
            default: pong_storage_data_15 <= pong_storage_data_15;
            endcase
        end
    end
end

logic ping_storage_data_16;
logic pong_storage_data_16;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            114 / IN_WIDTH: ping_storage_data_16 <= ping_storage_data_16 ^ input_data(114 % IN_WIDTH);
            231 / IN_WIDTH: ping_storage_data_16 <= ping_storage_data_16 ^ input_data(231 % IN_WIDTH);
            825 / IN_WIDTH: ping_storage_data_16 <= ping_storage_data_16 ^ input_data(825 % IN_WIDTH);
            893 / IN_WIDTH: ping_storage_data_16 <= ping_storage_data_16 ^ input_data(893 % IN_WIDTH);
            default: pong_storage_data_16 <= pong_storage_data_16;
            endcase
        end else begin
            case (input_count)
            114 / IN_WIDTH: pong_storage_data_16 <= pong_storage_data_16 ^ input_data(114 % IN_WIDTH);
            231 / IN_WIDTH: pong_storage_data_16 <= pong_storage_data_16 ^ input_data(231 % IN_WIDTH);
            825 / IN_WIDTH: pong_storage_data_16 <= pong_storage_data_16 ^ input_data(825 % IN_WIDTH);
            893 / IN_WIDTH: pong_storage_data_16 <= pong_storage_data_16 ^ input_data(893 % IN_WIDTH);
            default: pong_storage_data_16 <= pong_storage_data_16;
            endcase
        end
    end
end

logic ping_storage_data_17;
logic pong_storage_data_17;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            115 / IN_WIDTH: ping_storage_data_17 <= ping_storage_data_17 ^ input_data(115 % IN_WIDTH);
            232 / IN_WIDTH: ping_storage_data_17 <= ping_storage_data_17 ^ input_data(232 % IN_WIDTH);
            826 / IN_WIDTH: ping_storage_data_17 <= ping_storage_data_17 ^ input_data(826 % IN_WIDTH);
            894 / IN_WIDTH: ping_storage_data_17 <= ping_storage_data_17 ^ input_data(894 % IN_WIDTH);
            default: pong_storage_data_17 <= pong_storage_data_17;
            endcase
        end else begin
            case (input_count)
            115 / IN_WIDTH: pong_storage_data_17 <= pong_storage_data_17 ^ input_data(115 % IN_WIDTH);
            232 / IN_WIDTH: pong_storage_data_17 <= pong_storage_data_17 ^ input_data(232 % IN_WIDTH);
            826 / IN_WIDTH: pong_storage_data_17 <= pong_storage_data_17 ^ input_data(826 % IN_WIDTH);
            894 / IN_WIDTH: pong_storage_data_17 <= pong_storage_data_17 ^ input_data(894 % IN_WIDTH);
            default: pong_storage_data_17 <= pong_storage_data_17;
            endcase
        end
    end
end

logic ping_storage_data_18;
logic pong_storage_data_18;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            116 / IN_WIDTH: ping_storage_data_18 <= ping_storage_data_18 ^ input_data(116 % IN_WIDTH);
            233 / IN_WIDTH: ping_storage_data_18 <= ping_storage_data_18 ^ input_data(233 % IN_WIDTH);
            827 / IN_WIDTH: ping_storage_data_18 <= ping_storage_data_18 ^ input_data(827 % IN_WIDTH);
            895 / IN_WIDTH: ping_storage_data_18 <= ping_storage_data_18 ^ input_data(895 % IN_WIDTH);
            default: pong_storage_data_18 <= pong_storage_data_18;
            endcase
        end else begin
            case (input_count)
            116 / IN_WIDTH: pong_storage_data_18 <= pong_storage_data_18 ^ input_data(116 % IN_WIDTH);
            233 / IN_WIDTH: pong_storage_data_18 <= pong_storage_data_18 ^ input_data(233 % IN_WIDTH);
            827 / IN_WIDTH: pong_storage_data_18 <= pong_storage_data_18 ^ input_data(827 % IN_WIDTH);
            895 / IN_WIDTH: pong_storage_data_18 <= pong_storage_data_18 ^ input_data(895 % IN_WIDTH);
            default: pong_storage_data_18 <= pong_storage_data_18;
            endcase
        end
    end
end

logic ping_storage_data_19;
logic pong_storage_data_19;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            117 / IN_WIDTH: ping_storage_data_19 <= ping_storage_data_19 ^ input_data(117 % IN_WIDTH);
            234 / IN_WIDTH: ping_storage_data_19 <= ping_storage_data_19 ^ input_data(234 % IN_WIDTH);
            828 / IN_WIDTH: ping_storage_data_19 <= ping_storage_data_19 ^ input_data(828 % IN_WIDTH);
            896 / IN_WIDTH: ping_storage_data_19 <= ping_storage_data_19 ^ input_data(896 % IN_WIDTH);
            default: pong_storage_data_19 <= pong_storage_data_19;
            endcase
        end else begin
            case (input_count)
            117 / IN_WIDTH: pong_storage_data_19 <= pong_storage_data_19 ^ input_data(117 % IN_WIDTH);
            234 / IN_WIDTH: pong_storage_data_19 <= pong_storage_data_19 ^ input_data(234 % IN_WIDTH);
            828 / IN_WIDTH: pong_storage_data_19 <= pong_storage_data_19 ^ input_data(828 % IN_WIDTH);
            896 / IN_WIDTH: pong_storage_data_19 <= pong_storage_data_19 ^ input_data(896 % IN_WIDTH);
            default: pong_storage_data_19 <= pong_storage_data_19;
            endcase
        end
    end
end

logic ping_storage_data_20;
logic pong_storage_data_20;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            118 / IN_WIDTH: ping_storage_data_20 <= ping_storage_data_20 ^ input_data(118 % IN_WIDTH);
            235 / IN_WIDTH: ping_storage_data_20 <= ping_storage_data_20 ^ input_data(235 % IN_WIDTH);
            829 / IN_WIDTH: ping_storage_data_20 <= ping_storage_data_20 ^ input_data(829 % IN_WIDTH);
            897 / IN_WIDTH: ping_storage_data_20 <= ping_storage_data_20 ^ input_data(897 % IN_WIDTH);
            default: pong_storage_data_20 <= pong_storage_data_20;
            endcase
        end else begin
            case (input_count)
            118 / IN_WIDTH: pong_storage_data_20 <= pong_storage_data_20 ^ input_data(118 % IN_WIDTH);
            235 / IN_WIDTH: pong_storage_data_20 <= pong_storage_data_20 ^ input_data(235 % IN_WIDTH);
            829 / IN_WIDTH: pong_storage_data_20 <= pong_storage_data_20 ^ input_data(829 % IN_WIDTH);
            897 / IN_WIDTH: pong_storage_data_20 <= pong_storage_data_20 ^ input_data(897 % IN_WIDTH);
            default: pong_storage_data_20 <= pong_storage_data_20;
            endcase
        end
    end
end

logic ping_storage_data_21;
logic pong_storage_data_21;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            119 / IN_WIDTH: ping_storage_data_21 <= ping_storage_data_21 ^ input_data(119 % IN_WIDTH);
            236 / IN_WIDTH: ping_storage_data_21 <= ping_storage_data_21 ^ input_data(236 % IN_WIDTH);
            830 / IN_WIDTH: ping_storage_data_21 <= ping_storage_data_21 ^ input_data(830 % IN_WIDTH);
            898 / IN_WIDTH: ping_storage_data_21 <= ping_storage_data_21 ^ input_data(898 % IN_WIDTH);
            default: pong_storage_data_21 <= pong_storage_data_21;
            endcase
        end else begin
            case (input_count)
            119 / IN_WIDTH: pong_storage_data_21 <= pong_storage_data_21 ^ input_data(119 % IN_WIDTH);
            236 / IN_WIDTH: pong_storage_data_21 <= pong_storage_data_21 ^ input_data(236 % IN_WIDTH);
            830 / IN_WIDTH: pong_storage_data_21 <= pong_storage_data_21 ^ input_data(830 % IN_WIDTH);
            898 / IN_WIDTH: pong_storage_data_21 <= pong_storage_data_21 ^ input_data(898 % IN_WIDTH);
            default: pong_storage_data_21 <= pong_storage_data_21;
            endcase
        end
    end
end

logic ping_storage_data_22;
logic pong_storage_data_22;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            120 / IN_WIDTH: ping_storage_data_22 <= ping_storage_data_22 ^ input_data(120 % IN_WIDTH);
            237 / IN_WIDTH: ping_storage_data_22 <= ping_storage_data_22 ^ input_data(237 % IN_WIDTH);
            831 / IN_WIDTH: ping_storage_data_22 <= ping_storage_data_22 ^ input_data(831 % IN_WIDTH);
            899 / IN_WIDTH: ping_storage_data_22 <= ping_storage_data_22 ^ input_data(899 % IN_WIDTH);
            default: pong_storage_data_22 <= pong_storage_data_22;
            endcase
        end else begin
            case (input_count)
            120 / IN_WIDTH: pong_storage_data_22 <= pong_storage_data_22 ^ input_data(120 % IN_WIDTH);
            237 / IN_WIDTH: pong_storage_data_22 <= pong_storage_data_22 ^ input_data(237 % IN_WIDTH);
            831 / IN_WIDTH: pong_storage_data_22 <= pong_storage_data_22 ^ input_data(831 % IN_WIDTH);
            899 / IN_WIDTH: pong_storage_data_22 <= pong_storage_data_22 ^ input_data(899 % IN_WIDTH);
            default: pong_storage_data_22 <= pong_storage_data_22;
            endcase
        end
    end
end

logic ping_storage_data_23;
logic pong_storage_data_23;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            121 / IN_WIDTH: ping_storage_data_23 <= ping_storage_data_23 ^ input_data(121 % IN_WIDTH);
            238 / IN_WIDTH: ping_storage_data_23 <= ping_storage_data_23 ^ input_data(238 % IN_WIDTH);
            832 / IN_WIDTH: ping_storage_data_23 <= ping_storage_data_23 ^ input_data(832 % IN_WIDTH);
            900 / IN_WIDTH: ping_storage_data_23 <= ping_storage_data_23 ^ input_data(900 % IN_WIDTH);
            default: pong_storage_data_23 <= pong_storage_data_23;
            endcase
        end else begin
            case (input_count)
            121 / IN_WIDTH: pong_storage_data_23 <= pong_storage_data_23 ^ input_data(121 % IN_WIDTH);
            238 / IN_WIDTH: pong_storage_data_23 <= pong_storage_data_23 ^ input_data(238 % IN_WIDTH);
            832 / IN_WIDTH: pong_storage_data_23 <= pong_storage_data_23 ^ input_data(832 % IN_WIDTH);
            900 / IN_WIDTH: pong_storage_data_23 <= pong_storage_data_23 ^ input_data(900 % IN_WIDTH);
            default: pong_storage_data_23 <= pong_storage_data_23;
            endcase
        end
    end
end

logic ping_storage_data_24;
logic pong_storage_data_24;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            122 / IN_WIDTH: ping_storage_data_24 <= ping_storage_data_24 ^ input_data(122 % IN_WIDTH);
            239 / IN_WIDTH: ping_storage_data_24 <= ping_storage_data_24 ^ input_data(239 % IN_WIDTH);
            833 / IN_WIDTH: ping_storage_data_24 <= ping_storage_data_24 ^ input_data(833 % IN_WIDTH);
            901 / IN_WIDTH: ping_storage_data_24 <= ping_storage_data_24 ^ input_data(901 % IN_WIDTH);
            default: pong_storage_data_24 <= pong_storage_data_24;
            endcase
        end else begin
            case (input_count)
            122 / IN_WIDTH: pong_storage_data_24 <= pong_storage_data_24 ^ input_data(122 % IN_WIDTH);
            239 / IN_WIDTH: pong_storage_data_24 <= pong_storage_data_24 ^ input_data(239 % IN_WIDTH);
            833 / IN_WIDTH: pong_storage_data_24 <= pong_storage_data_24 ^ input_data(833 % IN_WIDTH);
            901 / IN_WIDTH: pong_storage_data_24 <= pong_storage_data_24 ^ input_data(901 % IN_WIDTH);
            default: pong_storage_data_24 <= pong_storage_data_24;
            endcase
        end
    end
end

logic ping_storage_data_25;
logic pong_storage_data_25;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            123 / IN_WIDTH: ping_storage_data_25 <= ping_storage_data_25 ^ input_data(123 % IN_WIDTH);
            240 / IN_WIDTH: ping_storage_data_25 <= ping_storage_data_25 ^ input_data(240 % IN_WIDTH);
            834 / IN_WIDTH: ping_storage_data_25 <= ping_storage_data_25 ^ input_data(834 % IN_WIDTH);
            902 / IN_WIDTH: ping_storage_data_25 <= ping_storage_data_25 ^ input_data(902 % IN_WIDTH);
            default: pong_storage_data_25 <= pong_storage_data_25;
            endcase
        end else begin
            case (input_count)
            123 / IN_WIDTH: pong_storage_data_25 <= pong_storage_data_25 ^ input_data(123 % IN_WIDTH);
            240 / IN_WIDTH: pong_storage_data_25 <= pong_storage_data_25 ^ input_data(240 % IN_WIDTH);
            834 / IN_WIDTH: pong_storage_data_25 <= pong_storage_data_25 ^ input_data(834 % IN_WIDTH);
            902 / IN_WIDTH: pong_storage_data_25 <= pong_storage_data_25 ^ input_data(902 % IN_WIDTH);
            default: pong_storage_data_25 <= pong_storage_data_25;
            endcase
        end
    end
end

logic ping_storage_data_26;
logic pong_storage_data_26;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            124 / IN_WIDTH: ping_storage_data_26 <= ping_storage_data_26 ^ input_data(124 % IN_WIDTH);
            241 / IN_WIDTH: ping_storage_data_26 <= ping_storage_data_26 ^ input_data(241 % IN_WIDTH);
            835 / IN_WIDTH: ping_storage_data_26 <= ping_storage_data_26 ^ input_data(835 % IN_WIDTH);
            903 / IN_WIDTH: ping_storage_data_26 <= ping_storage_data_26 ^ input_data(903 % IN_WIDTH);
            default: pong_storage_data_26 <= pong_storage_data_26;
            endcase
        end else begin
            case (input_count)
            124 / IN_WIDTH: pong_storage_data_26 <= pong_storage_data_26 ^ input_data(124 % IN_WIDTH);
            241 / IN_WIDTH: pong_storage_data_26 <= pong_storage_data_26 ^ input_data(241 % IN_WIDTH);
            835 / IN_WIDTH: pong_storage_data_26 <= pong_storage_data_26 ^ input_data(835 % IN_WIDTH);
            903 / IN_WIDTH: pong_storage_data_26 <= pong_storage_data_26 ^ input_data(903 % IN_WIDTH);
            default: pong_storage_data_26 <= pong_storage_data_26;
            endcase
        end
    end
end

logic ping_storage_data_27;
logic pong_storage_data_27;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            125 / IN_WIDTH: ping_storage_data_27 <= ping_storage_data_27 ^ input_data(125 % IN_WIDTH);
            242 / IN_WIDTH: ping_storage_data_27 <= ping_storage_data_27 ^ input_data(242 % IN_WIDTH);
            836 / IN_WIDTH: ping_storage_data_27 <= ping_storage_data_27 ^ input_data(836 % IN_WIDTH);
            904 / IN_WIDTH: ping_storage_data_27 <= ping_storage_data_27 ^ input_data(904 % IN_WIDTH);
            default: pong_storage_data_27 <= pong_storage_data_27;
            endcase
        end else begin
            case (input_count)
            125 / IN_WIDTH: pong_storage_data_27 <= pong_storage_data_27 ^ input_data(125 % IN_WIDTH);
            242 / IN_WIDTH: pong_storage_data_27 <= pong_storage_data_27 ^ input_data(242 % IN_WIDTH);
            836 / IN_WIDTH: pong_storage_data_27 <= pong_storage_data_27 ^ input_data(836 % IN_WIDTH);
            904 / IN_WIDTH: pong_storage_data_27 <= pong_storage_data_27 ^ input_data(904 % IN_WIDTH);
            default: pong_storage_data_27 <= pong_storage_data_27;
            endcase
        end
    end
end

logic ping_storage_data_28;
logic pong_storage_data_28;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            126 / IN_WIDTH: ping_storage_data_28 <= ping_storage_data_28 ^ input_data(126 % IN_WIDTH);
            243 / IN_WIDTH: ping_storage_data_28 <= ping_storage_data_28 ^ input_data(243 % IN_WIDTH);
            837 / IN_WIDTH: ping_storage_data_28 <= ping_storage_data_28 ^ input_data(837 % IN_WIDTH);
            905 / IN_WIDTH: ping_storage_data_28 <= ping_storage_data_28 ^ input_data(905 % IN_WIDTH);
            default: pong_storage_data_28 <= pong_storage_data_28;
            endcase
        end else begin
            case (input_count)
            126 / IN_WIDTH: pong_storage_data_28 <= pong_storage_data_28 ^ input_data(126 % IN_WIDTH);
            243 / IN_WIDTH: pong_storage_data_28 <= pong_storage_data_28 ^ input_data(243 % IN_WIDTH);
            837 / IN_WIDTH: pong_storage_data_28 <= pong_storage_data_28 ^ input_data(837 % IN_WIDTH);
            905 / IN_WIDTH: pong_storage_data_28 <= pong_storage_data_28 ^ input_data(905 % IN_WIDTH);
            default: pong_storage_data_28 <= pong_storage_data_28;
            endcase
        end
    end
end

logic ping_storage_data_29;
logic pong_storage_data_29;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            127 / IN_WIDTH: ping_storage_data_29 <= ping_storage_data_29 ^ input_data(127 % IN_WIDTH);
            244 / IN_WIDTH: ping_storage_data_29 <= ping_storage_data_29 ^ input_data(244 % IN_WIDTH);
            838 / IN_WIDTH: ping_storage_data_29 <= ping_storage_data_29 ^ input_data(838 % IN_WIDTH);
            906 / IN_WIDTH: ping_storage_data_29 <= ping_storage_data_29 ^ input_data(906 % IN_WIDTH);
            default: pong_storage_data_29 <= pong_storage_data_29;
            endcase
        end else begin
            case (input_count)
            127 / IN_WIDTH: pong_storage_data_29 <= pong_storage_data_29 ^ input_data(127 % IN_WIDTH);
            244 / IN_WIDTH: pong_storage_data_29 <= pong_storage_data_29 ^ input_data(244 % IN_WIDTH);
            838 / IN_WIDTH: pong_storage_data_29 <= pong_storage_data_29 ^ input_data(838 % IN_WIDTH);
            906 / IN_WIDTH: pong_storage_data_29 <= pong_storage_data_29 ^ input_data(906 % IN_WIDTH);
            default: pong_storage_data_29 <= pong_storage_data_29;
            endcase
        end
    end
end

logic ping_storage_data_30;
logic pong_storage_data_30;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            128 / IN_WIDTH: ping_storage_data_30 <= ping_storage_data_30 ^ input_data(128 % IN_WIDTH);
            245 / IN_WIDTH: ping_storage_data_30 <= ping_storage_data_30 ^ input_data(245 % IN_WIDTH);
            839 / IN_WIDTH: ping_storage_data_30 <= ping_storage_data_30 ^ input_data(839 % IN_WIDTH);
            907 / IN_WIDTH: ping_storage_data_30 <= ping_storage_data_30 ^ input_data(907 % IN_WIDTH);
            default: pong_storage_data_30 <= pong_storage_data_30;
            endcase
        end else begin
            case (input_count)
            128 / IN_WIDTH: pong_storage_data_30 <= pong_storage_data_30 ^ input_data(128 % IN_WIDTH);
            245 / IN_WIDTH: pong_storage_data_30 <= pong_storage_data_30 ^ input_data(245 % IN_WIDTH);
            839 / IN_WIDTH: pong_storage_data_30 <= pong_storage_data_30 ^ input_data(839 % IN_WIDTH);
            907 / IN_WIDTH: pong_storage_data_30 <= pong_storage_data_30 ^ input_data(907 % IN_WIDTH);
            default: pong_storage_data_30 <= pong_storage_data_30;
            endcase
        end
    end
end

logic ping_storage_data_31;
logic pong_storage_data_31;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            129 / IN_WIDTH: ping_storage_data_31 <= ping_storage_data_31 ^ input_data(129 % IN_WIDTH);
            246 / IN_WIDTH: ping_storage_data_31 <= ping_storage_data_31 ^ input_data(246 % IN_WIDTH);
            840 / IN_WIDTH: ping_storage_data_31 <= ping_storage_data_31 ^ input_data(840 % IN_WIDTH);
            908 / IN_WIDTH: ping_storage_data_31 <= ping_storage_data_31 ^ input_data(908 % IN_WIDTH);
            default: pong_storage_data_31 <= pong_storage_data_31;
            endcase
        end else begin
            case (input_count)
            129 / IN_WIDTH: pong_storage_data_31 <= pong_storage_data_31 ^ input_data(129 % IN_WIDTH);
            246 / IN_WIDTH: pong_storage_data_31 <= pong_storage_data_31 ^ input_data(246 % IN_WIDTH);
            840 / IN_WIDTH: pong_storage_data_31 <= pong_storage_data_31 ^ input_data(840 % IN_WIDTH);
            908 / IN_WIDTH: pong_storage_data_31 <= pong_storage_data_31 ^ input_data(908 % IN_WIDTH);
            default: pong_storage_data_31 <= pong_storage_data_31;
            endcase
        end
    end
end

logic ping_storage_data_32;
logic pong_storage_data_32;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            130 / IN_WIDTH: ping_storage_data_32 <= ping_storage_data_32 ^ input_data(130 % IN_WIDTH);
            247 / IN_WIDTH: ping_storage_data_32 <= ping_storage_data_32 ^ input_data(247 % IN_WIDTH);
            841 / IN_WIDTH: ping_storage_data_32 <= ping_storage_data_32 ^ input_data(841 % IN_WIDTH);
            909 / IN_WIDTH: ping_storage_data_32 <= ping_storage_data_32 ^ input_data(909 % IN_WIDTH);
            default: pong_storage_data_32 <= pong_storage_data_32;
            endcase
        end else begin
            case (input_count)
            130 / IN_WIDTH: pong_storage_data_32 <= pong_storage_data_32 ^ input_data(130 % IN_WIDTH);
            247 / IN_WIDTH: pong_storage_data_32 <= pong_storage_data_32 ^ input_data(247 % IN_WIDTH);
            841 / IN_WIDTH: pong_storage_data_32 <= pong_storage_data_32 ^ input_data(841 % IN_WIDTH);
            909 / IN_WIDTH: pong_storage_data_32 <= pong_storage_data_32 ^ input_data(909 % IN_WIDTH);
            default: pong_storage_data_32 <= pong_storage_data_32;
            endcase
        end
    end
end

logic ping_storage_data_33;
logic pong_storage_data_33;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            131 / IN_WIDTH: ping_storage_data_33 <= ping_storage_data_33 ^ input_data(131 % IN_WIDTH);
            248 / IN_WIDTH: ping_storage_data_33 <= ping_storage_data_33 ^ input_data(248 % IN_WIDTH);
            842 / IN_WIDTH: ping_storage_data_33 <= ping_storage_data_33 ^ input_data(842 % IN_WIDTH);
            910 / IN_WIDTH: ping_storage_data_33 <= ping_storage_data_33 ^ input_data(910 % IN_WIDTH);
            default: pong_storage_data_33 <= pong_storage_data_33;
            endcase
        end else begin
            case (input_count)
            131 / IN_WIDTH: pong_storage_data_33 <= pong_storage_data_33 ^ input_data(131 % IN_WIDTH);
            248 / IN_WIDTH: pong_storage_data_33 <= pong_storage_data_33 ^ input_data(248 % IN_WIDTH);
            842 / IN_WIDTH: pong_storage_data_33 <= pong_storage_data_33 ^ input_data(842 % IN_WIDTH);
            910 / IN_WIDTH: pong_storage_data_33 <= pong_storage_data_33 ^ input_data(910 % IN_WIDTH);
            default: pong_storage_data_33 <= pong_storage_data_33;
            endcase
        end
    end
end

logic ping_storage_data_34;
logic pong_storage_data_34;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            132 / IN_WIDTH: ping_storage_data_34 <= ping_storage_data_34 ^ input_data(132 % IN_WIDTH);
            249 / IN_WIDTH: ping_storage_data_34 <= ping_storage_data_34 ^ input_data(249 % IN_WIDTH);
            843 / IN_WIDTH: ping_storage_data_34 <= ping_storage_data_34 ^ input_data(843 % IN_WIDTH);
            911 / IN_WIDTH: ping_storage_data_34 <= ping_storage_data_34 ^ input_data(911 % IN_WIDTH);
            default: pong_storage_data_34 <= pong_storage_data_34;
            endcase
        end else begin
            case (input_count)
            132 / IN_WIDTH: pong_storage_data_34 <= pong_storage_data_34 ^ input_data(132 % IN_WIDTH);
            249 / IN_WIDTH: pong_storage_data_34 <= pong_storage_data_34 ^ input_data(249 % IN_WIDTH);
            843 / IN_WIDTH: pong_storage_data_34 <= pong_storage_data_34 ^ input_data(843 % IN_WIDTH);
            911 / IN_WIDTH: pong_storage_data_34 <= pong_storage_data_34 ^ input_data(911 % IN_WIDTH);
            default: pong_storage_data_34 <= pong_storage_data_34;
            endcase
        end
    end
end

logic ping_storage_data_35;
logic pong_storage_data_35;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            133 / IN_WIDTH: ping_storage_data_35 <= ping_storage_data_35 ^ input_data(133 % IN_WIDTH);
            250 / IN_WIDTH: ping_storage_data_35 <= ping_storage_data_35 ^ input_data(250 % IN_WIDTH);
            844 / IN_WIDTH: ping_storage_data_35 <= ping_storage_data_35 ^ input_data(844 % IN_WIDTH);
            912 / IN_WIDTH: ping_storage_data_35 <= ping_storage_data_35 ^ input_data(912 % IN_WIDTH);
            default: pong_storage_data_35 <= pong_storage_data_35;
            endcase
        end else begin
            case (input_count)
            133 / IN_WIDTH: pong_storage_data_35 <= pong_storage_data_35 ^ input_data(133 % IN_WIDTH);
            250 / IN_WIDTH: pong_storage_data_35 <= pong_storage_data_35 ^ input_data(250 % IN_WIDTH);
            844 / IN_WIDTH: pong_storage_data_35 <= pong_storage_data_35 ^ input_data(844 % IN_WIDTH);
            912 / IN_WIDTH: pong_storage_data_35 <= pong_storage_data_35 ^ input_data(912 % IN_WIDTH);
            default: pong_storage_data_35 <= pong_storage_data_35;
            endcase
        end
    end
end

logic ping_storage_data_36;
logic pong_storage_data_36;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            134 / IN_WIDTH: ping_storage_data_36 <= ping_storage_data_36 ^ input_data(134 % IN_WIDTH);
            251 / IN_WIDTH: ping_storage_data_36 <= ping_storage_data_36 ^ input_data(251 % IN_WIDTH);
            845 / IN_WIDTH: ping_storage_data_36 <= ping_storage_data_36 ^ input_data(845 % IN_WIDTH);
            913 / IN_WIDTH: ping_storage_data_36 <= ping_storage_data_36 ^ input_data(913 % IN_WIDTH);
            default: pong_storage_data_36 <= pong_storage_data_36;
            endcase
        end else begin
            case (input_count)
            134 / IN_WIDTH: pong_storage_data_36 <= pong_storage_data_36 ^ input_data(134 % IN_WIDTH);
            251 / IN_WIDTH: pong_storage_data_36 <= pong_storage_data_36 ^ input_data(251 % IN_WIDTH);
            845 / IN_WIDTH: pong_storage_data_36 <= pong_storage_data_36 ^ input_data(845 % IN_WIDTH);
            913 / IN_WIDTH: pong_storage_data_36 <= pong_storage_data_36 ^ input_data(913 % IN_WIDTH);
            default: pong_storage_data_36 <= pong_storage_data_36;
            endcase
        end
    end
end

logic ping_storage_data_37;
logic pong_storage_data_37;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            135 / IN_WIDTH: ping_storage_data_37 <= ping_storage_data_37 ^ input_data(135 % IN_WIDTH);
            252 / IN_WIDTH: ping_storage_data_37 <= ping_storage_data_37 ^ input_data(252 % IN_WIDTH);
            846 / IN_WIDTH: ping_storage_data_37 <= ping_storage_data_37 ^ input_data(846 % IN_WIDTH);
            914 / IN_WIDTH: ping_storage_data_37 <= ping_storage_data_37 ^ input_data(914 % IN_WIDTH);
            default: pong_storage_data_37 <= pong_storage_data_37;
            endcase
        end else begin
            case (input_count)
            135 / IN_WIDTH: pong_storage_data_37 <= pong_storage_data_37 ^ input_data(135 % IN_WIDTH);
            252 / IN_WIDTH: pong_storage_data_37 <= pong_storage_data_37 ^ input_data(252 % IN_WIDTH);
            846 / IN_WIDTH: pong_storage_data_37 <= pong_storage_data_37 ^ input_data(846 % IN_WIDTH);
            914 / IN_WIDTH: pong_storage_data_37 <= pong_storage_data_37 ^ input_data(914 % IN_WIDTH);
            default: pong_storage_data_37 <= pong_storage_data_37;
            endcase
        end
    end
end

logic ping_storage_data_38;
logic pong_storage_data_38;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            136 / IN_WIDTH: ping_storage_data_38 <= ping_storage_data_38 ^ input_data(136 % IN_WIDTH);
            253 / IN_WIDTH: ping_storage_data_38 <= ping_storage_data_38 ^ input_data(253 % IN_WIDTH);
            847 / IN_WIDTH: ping_storage_data_38 <= ping_storage_data_38 ^ input_data(847 % IN_WIDTH);
            915 / IN_WIDTH: ping_storage_data_38 <= ping_storage_data_38 ^ input_data(915 % IN_WIDTH);
            default: pong_storage_data_38 <= pong_storage_data_38;
            endcase
        end else begin
            case (input_count)
            136 / IN_WIDTH: pong_storage_data_38 <= pong_storage_data_38 ^ input_data(136 % IN_WIDTH);
            253 / IN_WIDTH: pong_storage_data_38 <= pong_storage_data_38 ^ input_data(253 % IN_WIDTH);
            847 / IN_WIDTH: pong_storage_data_38 <= pong_storage_data_38 ^ input_data(847 % IN_WIDTH);
            915 / IN_WIDTH: pong_storage_data_38 <= pong_storage_data_38 ^ input_data(915 % IN_WIDTH);
            default: pong_storage_data_38 <= pong_storage_data_38;
            endcase
        end
    end
end

logic ping_storage_data_39;
logic pong_storage_data_39;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            137 / IN_WIDTH: ping_storage_data_39 <= ping_storage_data_39 ^ input_data(137 % IN_WIDTH);
            254 / IN_WIDTH: ping_storage_data_39 <= ping_storage_data_39 ^ input_data(254 % IN_WIDTH);
            848 / IN_WIDTH: ping_storage_data_39 <= ping_storage_data_39 ^ input_data(848 % IN_WIDTH);
            916 / IN_WIDTH: ping_storage_data_39 <= ping_storage_data_39 ^ input_data(916 % IN_WIDTH);
            default: pong_storage_data_39 <= pong_storage_data_39;
            endcase
        end else begin
            case (input_count)
            137 / IN_WIDTH: pong_storage_data_39 <= pong_storage_data_39 ^ input_data(137 % IN_WIDTH);
            254 / IN_WIDTH: pong_storage_data_39 <= pong_storage_data_39 ^ input_data(254 % IN_WIDTH);
            848 / IN_WIDTH: pong_storage_data_39 <= pong_storage_data_39 ^ input_data(848 % IN_WIDTH);
            916 / IN_WIDTH: pong_storage_data_39 <= pong_storage_data_39 ^ input_data(916 % IN_WIDTH);
            default: pong_storage_data_39 <= pong_storage_data_39;
            endcase
        end
    end
end

logic ping_storage_data_40;
logic pong_storage_data_40;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            138 / IN_WIDTH: ping_storage_data_40 <= ping_storage_data_40 ^ input_data(138 % IN_WIDTH);
            255 / IN_WIDTH: ping_storage_data_40 <= ping_storage_data_40 ^ input_data(255 % IN_WIDTH);
            849 / IN_WIDTH: ping_storage_data_40 <= ping_storage_data_40 ^ input_data(849 % IN_WIDTH);
            917 / IN_WIDTH: ping_storage_data_40 <= ping_storage_data_40 ^ input_data(917 % IN_WIDTH);
            default: pong_storage_data_40 <= pong_storage_data_40;
            endcase
        end else begin
            case (input_count)
            138 / IN_WIDTH: pong_storage_data_40 <= pong_storage_data_40 ^ input_data(138 % IN_WIDTH);
            255 / IN_WIDTH: pong_storage_data_40 <= pong_storage_data_40 ^ input_data(255 % IN_WIDTH);
            849 / IN_WIDTH: pong_storage_data_40 <= pong_storage_data_40 ^ input_data(849 % IN_WIDTH);
            917 / IN_WIDTH: pong_storage_data_40 <= pong_storage_data_40 ^ input_data(917 % IN_WIDTH);
            default: pong_storage_data_40 <= pong_storage_data_40;
            endcase
        end
    end
end

logic ping_storage_data_41;
logic pong_storage_data_41;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            139 / IN_WIDTH: ping_storage_data_41 <= ping_storage_data_41 ^ input_data(139 % IN_WIDTH);
            256 / IN_WIDTH: ping_storage_data_41 <= ping_storage_data_41 ^ input_data(256 % IN_WIDTH);
            850 / IN_WIDTH: ping_storage_data_41 <= ping_storage_data_41 ^ input_data(850 % IN_WIDTH);
            918 / IN_WIDTH: ping_storage_data_41 <= ping_storage_data_41 ^ input_data(918 % IN_WIDTH);
            default: pong_storage_data_41 <= pong_storage_data_41;
            endcase
        end else begin
            case (input_count)
            139 / IN_WIDTH: pong_storage_data_41 <= pong_storage_data_41 ^ input_data(139 % IN_WIDTH);
            256 / IN_WIDTH: pong_storage_data_41 <= pong_storage_data_41 ^ input_data(256 % IN_WIDTH);
            850 / IN_WIDTH: pong_storage_data_41 <= pong_storage_data_41 ^ input_data(850 % IN_WIDTH);
            918 / IN_WIDTH: pong_storage_data_41 <= pong_storage_data_41 ^ input_data(918 % IN_WIDTH);
            default: pong_storage_data_41 <= pong_storage_data_41;
            endcase
        end
    end
end

logic ping_storage_data_42;
logic pong_storage_data_42;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            140 / IN_WIDTH: ping_storage_data_42 <= ping_storage_data_42 ^ input_data(140 % IN_WIDTH);
            257 / IN_WIDTH: ping_storage_data_42 <= ping_storage_data_42 ^ input_data(257 % IN_WIDTH);
            851 / IN_WIDTH: ping_storage_data_42 <= ping_storage_data_42 ^ input_data(851 % IN_WIDTH);
            919 / IN_WIDTH: ping_storage_data_42 <= ping_storage_data_42 ^ input_data(919 % IN_WIDTH);
            default: pong_storage_data_42 <= pong_storage_data_42;
            endcase
        end else begin
            case (input_count)
            140 / IN_WIDTH: pong_storage_data_42 <= pong_storage_data_42 ^ input_data(140 % IN_WIDTH);
            257 / IN_WIDTH: pong_storage_data_42 <= pong_storage_data_42 ^ input_data(257 % IN_WIDTH);
            851 / IN_WIDTH: pong_storage_data_42 <= pong_storage_data_42 ^ input_data(851 % IN_WIDTH);
            919 / IN_WIDTH: pong_storage_data_42 <= pong_storage_data_42 ^ input_data(919 % IN_WIDTH);
            default: pong_storage_data_42 <= pong_storage_data_42;
            endcase
        end
    end
end

logic ping_storage_data_43;
logic pong_storage_data_43;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            141 / IN_WIDTH: ping_storage_data_43 <= ping_storage_data_43 ^ input_data(141 % IN_WIDTH);
            258 / IN_WIDTH: ping_storage_data_43 <= ping_storage_data_43 ^ input_data(258 % IN_WIDTH);
            852 / IN_WIDTH: ping_storage_data_43 <= ping_storage_data_43 ^ input_data(852 % IN_WIDTH);
            920 / IN_WIDTH: ping_storage_data_43 <= ping_storage_data_43 ^ input_data(920 % IN_WIDTH);
            default: pong_storage_data_43 <= pong_storage_data_43;
            endcase
        end else begin
            case (input_count)
            141 / IN_WIDTH: pong_storage_data_43 <= pong_storage_data_43 ^ input_data(141 % IN_WIDTH);
            258 / IN_WIDTH: pong_storage_data_43 <= pong_storage_data_43 ^ input_data(258 % IN_WIDTH);
            852 / IN_WIDTH: pong_storage_data_43 <= pong_storage_data_43 ^ input_data(852 % IN_WIDTH);
            920 / IN_WIDTH: pong_storage_data_43 <= pong_storage_data_43 ^ input_data(920 % IN_WIDTH);
            default: pong_storage_data_43 <= pong_storage_data_43;
            endcase
        end
    end
end

logic ping_storage_data_44;
logic pong_storage_data_44;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            142 / IN_WIDTH: ping_storage_data_44 <= ping_storage_data_44 ^ input_data(142 % IN_WIDTH);
            259 / IN_WIDTH: ping_storage_data_44 <= ping_storage_data_44 ^ input_data(259 % IN_WIDTH);
            853 / IN_WIDTH: ping_storage_data_44 <= ping_storage_data_44 ^ input_data(853 % IN_WIDTH);
            921 / IN_WIDTH: ping_storage_data_44 <= ping_storage_data_44 ^ input_data(921 % IN_WIDTH);
            default: pong_storage_data_44 <= pong_storage_data_44;
            endcase
        end else begin
            case (input_count)
            142 / IN_WIDTH: pong_storage_data_44 <= pong_storage_data_44 ^ input_data(142 % IN_WIDTH);
            259 / IN_WIDTH: pong_storage_data_44 <= pong_storage_data_44 ^ input_data(259 % IN_WIDTH);
            853 / IN_WIDTH: pong_storage_data_44 <= pong_storage_data_44 ^ input_data(853 % IN_WIDTH);
            921 / IN_WIDTH: pong_storage_data_44 <= pong_storage_data_44 ^ input_data(921 % IN_WIDTH);
            default: pong_storage_data_44 <= pong_storage_data_44;
            endcase
        end
    end
end

logic ping_storage_data_45;
logic pong_storage_data_45;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            143 / IN_WIDTH: ping_storage_data_45 <= ping_storage_data_45 ^ input_data(143 % IN_WIDTH);
            260 / IN_WIDTH: ping_storage_data_45 <= ping_storage_data_45 ^ input_data(260 % IN_WIDTH);
            854 / IN_WIDTH: ping_storage_data_45 <= ping_storage_data_45 ^ input_data(854 % IN_WIDTH);
            922 / IN_WIDTH: ping_storage_data_45 <= ping_storage_data_45 ^ input_data(922 % IN_WIDTH);
            default: pong_storage_data_45 <= pong_storage_data_45;
            endcase
        end else begin
            case (input_count)
            143 / IN_WIDTH: pong_storage_data_45 <= pong_storage_data_45 ^ input_data(143 % IN_WIDTH);
            260 / IN_WIDTH: pong_storage_data_45 <= pong_storage_data_45 ^ input_data(260 % IN_WIDTH);
            854 / IN_WIDTH: pong_storage_data_45 <= pong_storage_data_45 ^ input_data(854 % IN_WIDTH);
            922 / IN_WIDTH: pong_storage_data_45 <= pong_storage_data_45 ^ input_data(922 % IN_WIDTH);
            default: pong_storage_data_45 <= pong_storage_data_45;
            endcase
        end
    end
end

logic ping_storage_data_46;
logic pong_storage_data_46;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            144 / IN_WIDTH: ping_storage_data_46 <= ping_storage_data_46 ^ input_data(144 % IN_WIDTH);
            261 / IN_WIDTH: ping_storage_data_46 <= ping_storage_data_46 ^ input_data(261 % IN_WIDTH);
            855 / IN_WIDTH: ping_storage_data_46 <= ping_storage_data_46 ^ input_data(855 % IN_WIDTH);
            923 / IN_WIDTH: ping_storage_data_46 <= ping_storage_data_46 ^ input_data(923 % IN_WIDTH);
            default: pong_storage_data_46 <= pong_storage_data_46;
            endcase
        end else begin
            case (input_count)
            144 / IN_WIDTH: pong_storage_data_46 <= pong_storage_data_46 ^ input_data(144 % IN_WIDTH);
            261 / IN_WIDTH: pong_storage_data_46 <= pong_storage_data_46 ^ input_data(261 % IN_WIDTH);
            855 / IN_WIDTH: pong_storage_data_46 <= pong_storage_data_46 ^ input_data(855 % IN_WIDTH);
            923 / IN_WIDTH: pong_storage_data_46 <= pong_storage_data_46 ^ input_data(923 % IN_WIDTH);
            default: pong_storage_data_46 <= pong_storage_data_46;
            endcase
        end
    end
end

logic ping_storage_data_47;
logic pong_storage_data_47;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            145 / IN_WIDTH: ping_storage_data_47 <= ping_storage_data_47 ^ input_data(145 % IN_WIDTH);
            262 / IN_WIDTH: ping_storage_data_47 <= ping_storage_data_47 ^ input_data(262 % IN_WIDTH);
            856 / IN_WIDTH: ping_storage_data_47 <= ping_storage_data_47 ^ input_data(856 % IN_WIDTH);
            924 / IN_WIDTH: ping_storage_data_47 <= ping_storage_data_47 ^ input_data(924 % IN_WIDTH);
            default: pong_storage_data_47 <= pong_storage_data_47;
            endcase
        end else begin
            case (input_count)
            145 / IN_WIDTH: pong_storage_data_47 <= pong_storage_data_47 ^ input_data(145 % IN_WIDTH);
            262 / IN_WIDTH: pong_storage_data_47 <= pong_storage_data_47 ^ input_data(262 % IN_WIDTH);
            856 / IN_WIDTH: pong_storage_data_47 <= pong_storage_data_47 ^ input_data(856 % IN_WIDTH);
            924 / IN_WIDTH: pong_storage_data_47 <= pong_storage_data_47 ^ input_data(924 % IN_WIDTH);
            default: pong_storage_data_47 <= pong_storage_data_47;
            endcase
        end
    end
end

logic ping_storage_data_48;
logic pong_storage_data_48;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            146 / IN_WIDTH: ping_storage_data_48 <= ping_storage_data_48 ^ input_data(146 % IN_WIDTH);
            263 / IN_WIDTH: ping_storage_data_48 <= ping_storage_data_48 ^ input_data(263 % IN_WIDTH);
            857 / IN_WIDTH: ping_storage_data_48 <= ping_storage_data_48 ^ input_data(857 % IN_WIDTH);
            925 / IN_WIDTH: ping_storage_data_48 <= ping_storage_data_48 ^ input_data(925 % IN_WIDTH);
            default: pong_storage_data_48 <= pong_storage_data_48;
            endcase
        end else begin
            case (input_count)
            146 / IN_WIDTH: pong_storage_data_48 <= pong_storage_data_48 ^ input_data(146 % IN_WIDTH);
            263 / IN_WIDTH: pong_storage_data_48 <= pong_storage_data_48 ^ input_data(263 % IN_WIDTH);
            857 / IN_WIDTH: pong_storage_data_48 <= pong_storage_data_48 ^ input_data(857 % IN_WIDTH);
            925 / IN_WIDTH: pong_storage_data_48 <= pong_storage_data_48 ^ input_data(925 % IN_WIDTH);
            default: pong_storage_data_48 <= pong_storage_data_48;
            endcase
        end
    end
end

logic ping_storage_data_49;
logic pong_storage_data_49;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            147 / IN_WIDTH: ping_storage_data_49 <= ping_storage_data_49 ^ input_data(147 % IN_WIDTH);
            264 / IN_WIDTH: ping_storage_data_49 <= ping_storage_data_49 ^ input_data(264 % IN_WIDTH);
            858 / IN_WIDTH: ping_storage_data_49 <= ping_storage_data_49 ^ input_data(858 % IN_WIDTH);
            926 / IN_WIDTH: ping_storage_data_49 <= ping_storage_data_49 ^ input_data(926 % IN_WIDTH);
            default: pong_storage_data_49 <= pong_storage_data_49;
            endcase
        end else begin
            case (input_count)
            147 / IN_WIDTH: pong_storage_data_49 <= pong_storage_data_49 ^ input_data(147 % IN_WIDTH);
            264 / IN_WIDTH: pong_storage_data_49 <= pong_storage_data_49 ^ input_data(264 % IN_WIDTH);
            858 / IN_WIDTH: pong_storage_data_49 <= pong_storage_data_49 ^ input_data(858 % IN_WIDTH);
            926 / IN_WIDTH: pong_storage_data_49 <= pong_storage_data_49 ^ input_data(926 % IN_WIDTH);
            default: pong_storage_data_49 <= pong_storage_data_49;
            endcase
        end
    end
end

logic ping_storage_data_50;
logic pong_storage_data_50;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            148 / IN_WIDTH: ping_storage_data_50 <= ping_storage_data_50 ^ input_data(148 % IN_WIDTH);
            265 / IN_WIDTH: ping_storage_data_50 <= ping_storage_data_50 ^ input_data(265 % IN_WIDTH);
            859 / IN_WIDTH: ping_storage_data_50 <= ping_storage_data_50 ^ input_data(859 % IN_WIDTH);
            927 / IN_WIDTH: ping_storage_data_50 <= ping_storage_data_50 ^ input_data(927 % IN_WIDTH);
            default: pong_storage_data_50 <= pong_storage_data_50;
            endcase
        end else begin
            case (input_count)
            148 / IN_WIDTH: pong_storage_data_50 <= pong_storage_data_50 ^ input_data(148 % IN_WIDTH);
            265 / IN_WIDTH: pong_storage_data_50 <= pong_storage_data_50 ^ input_data(265 % IN_WIDTH);
            859 / IN_WIDTH: pong_storage_data_50 <= pong_storage_data_50 ^ input_data(859 % IN_WIDTH);
            927 / IN_WIDTH: pong_storage_data_50 <= pong_storage_data_50 ^ input_data(927 % IN_WIDTH);
            default: pong_storage_data_50 <= pong_storage_data_50;
            endcase
        end
    end
end

logic ping_storage_data_51;
logic pong_storage_data_51;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            149 / IN_WIDTH: ping_storage_data_51 <= ping_storage_data_51 ^ input_data(149 % IN_WIDTH);
            266 / IN_WIDTH: ping_storage_data_51 <= ping_storage_data_51 ^ input_data(266 % IN_WIDTH);
            860 / IN_WIDTH: ping_storage_data_51 <= ping_storage_data_51 ^ input_data(860 % IN_WIDTH);
            928 / IN_WIDTH: ping_storage_data_51 <= ping_storage_data_51 ^ input_data(928 % IN_WIDTH);
            default: pong_storage_data_51 <= pong_storage_data_51;
            endcase
        end else begin
            case (input_count)
            149 / IN_WIDTH: pong_storage_data_51 <= pong_storage_data_51 ^ input_data(149 % IN_WIDTH);
            266 / IN_WIDTH: pong_storage_data_51 <= pong_storage_data_51 ^ input_data(266 % IN_WIDTH);
            860 / IN_WIDTH: pong_storage_data_51 <= pong_storage_data_51 ^ input_data(860 % IN_WIDTH);
            928 / IN_WIDTH: pong_storage_data_51 <= pong_storage_data_51 ^ input_data(928 % IN_WIDTH);
            default: pong_storage_data_51 <= pong_storage_data_51;
            endcase
        end
    end
end

logic ping_storage_data_52;
logic pong_storage_data_52;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            150 / IN_WIDTH: ping_storage_data_52 <= ping_storage_data_52 ^ input_data(150 % IN_WIDTH);
            267 / IN_WIDTH: ping_storage_data_52 <= ping_storage_data_52 ^ input_data(267 % IN_WIDTH);
            861 / IN_WIDTH: ping_storage_data_52 <= ping_storage_data_52 ^ input_data(861 % IN_WIDTH);
            929 / IN_WIDTH: ping_storage_data_52 <= ping_storage_data_52 ^ input_data(929 % IN_WIDTH);
            default: pong_storage_data_52 <= pong_storage_data_52;
            endcase
        end else begin
            case (input_count)
            150 / IN_WIDTH: pong_storage_data_52 <= pong_storage_data_52 ^ input_data(150 % IN_WIDTH);
            267 / IN_WIDTH: pong_storage_data_52 <= pong_storage_data_52 ^ input_data(267 % IN_WIDTH);
            861 / IN_WIDTH: pong_storage_data_52 <= pong_storage_data_52 ^ input_data(861 % IN_WIDTH);
            929 / IN_WIDTH: pong_storage_data_52 <= pong_storage_data_52 ^ input_data(929 % IN_WIDTH);
            default: pong_storage_data_52 <= pong_storage_data_52;
            endcase
        end
    end
end

logic ping_storage_data_53;
logic pong_storage_data_53;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            151 / IN_WIDTH: ping_storage_data_53 <= ping_storage_data_53 ^ input_data(151 % IN_WIDTH);
            268 / IN_WIDTH: ping_storage_data_53 <= ping_storage_data_53 ^ input_data(268 % IN_WIDTH);
            862 / IN_WIDTH: ping_storage_data_53 <= ping_storage_data_53 ^ input_data(862 % IN_WIDTH);
            930 / IN_WIDTH: ping_storage_data_53 <= ping_storage_data_53 ^ input_data(930 % IN_WIDTH);
            default: pong_storage_data_53 <= pong_storage_data_53;
            endcase
        end else begin
            case (input_count)
            151 / IN_WIDTH: pong_storage_data_53 <= pong_storage_data_53 ^ input_data(151 % IN_WIDTH);
            268 / IN_WIDTH: pong_storage_data_53 <= pong_storage_data_53 ^ input_data(268 % IN_WIDTH);
            862 / IN_WIDTH: pong_storage_data_53 <= pong_storage_data_53 ^ input_data(862 % IN_WIDTH);
            930 / IN_WIDTH: pong_storage_data_53 <= pong_storage_data_53 ^ input_data(930 % IN_WIDTH);
            default: pong_storage_data_53 <= pong_storage_data_53;
            endcase
        end
    end
end

logic ping_storage_data_54;
logic pong_storage_data_54;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            152 / IN_WIDTH: ping_storage_data_54 <= ping_storage_data_54 ^ input_data(152 % IN_WIDTH);
            269 / IN_WIDTH: ping_storage_data_54 <= ping_storage_data_54 ^ input_data(269 % IN_WIDTH);
            863 / IN_WIDTH: ping_storage_data_54 <= ping_storage_data_54 ^ input_data(863 % IN_WIDTH);
            931 / IN_WIDTH: ping_storage_data_54 <= ping_storage_data_54 ^ input_data(931 % IN_WIDTH);
            default: pong_storage_data_54 <= pong_storage_data_54;
            endcase
        end else begin
            case (input_count)
            152 / IN_WIDTH: pong_storage_data_54 <= pong_storage_data_54 ^ input_data(152 % IN_WIDTH);
            269 / IN_WIDTH: pong_storage_data_54 <= pong_storage_data_54 ^ input_data(269 % IN_WIDTH);
            863 / IN_WIDTH: pong_storage_data_54 <= pong_storage_data_54 ^ input_data(863 % IN_WIDTH);
            931 / IN_WIDTH: pong_storage_data_54 <= pong_storage_data_54 ^ input_data(931 % IN_WIDTH);
            default: pong_storage_data_54 <= pong_storage_data_54;
            endcase
        end
    end
end

logic ping_storage_data_55;
logic pong_storage_data_55;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            153 / IN_WIDTH: ping_storage_data_55 <= ping_storage_data_55 ^ input_data(153 % IN_WIDTH);
            270 / IN_WIDTH: ping_storage_data_55 <= ping_storage_data_55 ^ input_data(270 % IN_WIDTH);
            768 / IN_WIDTH: ping_storage_data_55 <= ping_storage_data_55 ^ input_data(768 % IN_WIDTH);
            932 / IN_WIDTH: ping_storage_data_55 <= ping_storage_data_55 ^ input_data(932 % IN_WIDTH);
            default: pong_storage_data_55 <= pong_storage_data_55;
            endcase
        end else begin
            case (input_count)
            153 / IN_WIDTH: pong_storage_data_55 <= pong_storage_data_55 ^ input_data(153 % IN_WIDTH);
            270 / IN_WIDTH: pong_storage_data_55 <= pong_storage_data_55 ^ input_data(270 % IN_WIDTH);
            768 / IN_WIDTH: pong_storage_data_55 <= pong_storage_data_55 ^ input_data(768 % IN_WIDTH);
            932 / IN_WIDTH: pong_storage_data_55 <= pong_storage_data_55 ^ input_data(932 % IN_WIDTH);
            default: pong_storage_data_55 <= pong_storage_data_55;
            endcase
        end
    end
end

logic ping_storage_data_56;
logic pong_storage_data_56;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            154 / IN_WIDTH: ping_storage_data_56 <= ping_storage_data_56 ^ input_data(154 % IN_WIDTH);
            271 / IN_WIDTH: ping_storage_data_56 <= ping_storage_data_56 ^ input_data(271 % IN_WIDTH);
            769 / IN_WIDTH: ping_storage_data_56 <= ping_storage_data_56 ^ input_data(769 % IN_WIDTH);
            933 / IN_WIDTH: ping_storage_data_56 <= ping_storage_data_56 ^ input_data(933 % IN_WIDTH);
            default: pong_storage_data_56 <= pong_storage_data_56;
            endcase
        end else begin
            case (input_count)
            154 / IN_WIDTH: pong_storage_data_56 <= pong_storage_data_56 ^ input_data(154 % IN_WIDTH);
            271 / IN_WIDTH: pong_storage_data_56 <= pong_storage_data_56 ^ input_data(271 % IN_WIDTH);
            769 / IN_WIDTH: pong_storage_data_56 <= pong_storage_data_56 ^ input_data(769 % IN_WIDTH);
            933 / IN_WIDTH: pong_storage_data_56 <= pong_storage_data_56 ^ input_data(933 % IN_WIDTH);
            default: pong_storage_data_56 <= pong_storage_data_56;
            endcase
        end
    end
end

logic ping_storage_data_57;
logic pong_storage_data_57;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            155 / IN_WIDTH: ping_storage_data_57 <= ping_storage_data_57 ^ input_data(155 % IN_WIDTH);
            272 / IN_WIDTH: ping_storage_data_57 <= ping_storage_data_57 ^ input_data(272 % IN_WIDTH);
            770 / IN_WIDTH: ping_storage_data_57 <= ping_storage_data_57 ^ input_data(770 % IN_WIDTH);
            934 / IN_WIDTH: ping_storage_data_57 <= ping_storage_data_57 ^ input_data(934 % IN_WIDTH);
            default: pong_storage_data_57 <= pong_storage_data_57;
            endcase
        end else begin
            case (input_count)
            155 / IN_WIDTH: pong_storage_data_57 <= pong_storage_data_57 ^ input_data(155 % IN_WIDTH);
            272 / IN_WIDTH: pong_storage_data_57 <= pong_storage_data_57 ^ input_data(272 % IN_WIDTH);
            770 / IN_WIDTH: pong_storage_data_57 <= pong_storage_data_57 ^ input_data(770 % IN_WIDTH);
            934 / IN_WIDTH: pong_storage_data_57 <= pong_storage_data_57 ^ input_data(934 % IN_WIDTH);
            default: pong_storage_data_57 <= pong_storage_data_57;
            endcase
        end
    end
end

logic ping_storage_data_58;
logic pong_storage_data_58;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            156 / IN_WIDTH: ping_storage_data_58 <= ping_storage_data_58 ^ input_data(156 % IN_WIDTH);
            273 / IN_WIDTH: ping_storage_data_58 <= ping_storage_data_58 ^ input_data(273 % IN_WIDTH);
            771 / IN_WIDTH: ping_storage_data_58 <= ping_storage_data_58 ^ input_data(771 % IN_WIDTH);
            935 / IN_WIDTH: ping_storage_data_58 <= ping_storage_data_58 ^ input_data(935 % IN_WIDTH);
            default: pong_storage_data_58 <= pong_storage_data_58;
            endcase
        end else begin
            case (input_count)
            156 / IN_WIDTH: pong_storage_data_58 <= pong_storage_data_58 ^ input_data(156 % IN_WIDTH);
            273 / IN_WIDTH: pong_storage_data_58 <= pong_storage_data_58 ^ input_data(273 % IN_WIDTH);
            771 / IN_WIDTH: pong_storage_data_58 <= pong_storage_data_58 ^ input_data(771 % IN_WIDTH);
            935 / IN_WIDTH: pong_storage_data_58 <= pong_storage_data_58 ^ input_data(935 % IN_WIDTH);
            default: pong_storage_data_58 <= pong_storage_data_58;
            endcase
        end
    end
end

logic ping_storage_data_59;
logic pong_storage_data_59;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            157 / IN_WIDTH: ping_storage_data_59 <= ping_storage_data_59 ^ input_data(157 % IN_WIDTH);
            274 / IN_WIDTH: ping_storage_data_59 <= ping_storage_data_59 ^ input_data(274 % IN_WIDTH);
            772 / IN_WIDTH: ping_storage_data_59 <= ping_storage_data_59 ^ input_data(772 % IN_WIDTH);
            936 / IN_WIDTH: ping_storage_data_59 <= ping_storage_data_59 ^ input_data(936 % IN_WIDTH);
            default: pong_storage_data_59 <= pong_storage_data_59;
            endcase
        end else begin
            case (input_count)
            157 / IN_WIDTH: pong_storage_data_59 <= pong_storage_data_59 ^ input_data(157 % IN_WIDTH);
            274 / IN_WIDTH: pong_storage_data_59 <= pong_storage_data_59 ^ input_data(274 % IN_WIDTH);
            772 / IN_WIDTH: pong_storage_data_59 <= pong_storage_data_59 ^ input_data(772 % IN_WIDTH);
            936 / IN_WIDTH: pong_storage_data_59 <= pong_storage_data_59 ^ input_data(936 % IN_WIDTH);
            default: pong_storage_data_59 <= pong_storage_data_59;
            endcase
        end
    end
end

logic ping_storage_data_60;
logic pong_storage_data_60;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            158 / IN_WIDTH: ping_storage_data_60 <= ping_storage_data_60 ^ input_data(158 % IN_WIDTH);
            275 / IN_WIDTH: ping_storage_data_60 <= ping_storage_data_60 ^ input_data(275 % IN_WIDTH);
            773 / IN_WIDTH: ping_storage_data_60 <= ping_storage_data_60 ^ input_data(773 % IN_WIDTH);
            937 / IN_WIDTH: ping_storage_data_60 <= ping_storage_data_60 ^ input_data(937 % IN_WIDTH);
            default: pong_storage_data_60 <= pong_storage_data_60;
            endcase
        end else begin
            case (input_count)
            158 / IN_WIDTH: pong_storage_data_60 <= pong_storage_data_60 ^ input_data(158 % IN_WIDTH);
            275 / IN_WIDTH: pong_storage_data_60 <= pong_storage_data_60 ^ input_data(275 % IN_WIDTH);
            773 / IN_WIDTH: pong_storage_data_60 <= pong_storage_data_60 ^ input_data(773 % IN_WIDTH);
            937 / IN_WIDTH: pong_storage_data_60 <= pong_storage_data_60 ^ input_data(937 % IN_WIDTH);
            default: pong_storage_data_60 <= pong_storage_data_60;
            endcase
        end
    end
end

logic ping_storage_data_61;
logic pong_storage_data_61;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            159 / IN_WIDTH: ping_storage_data_61 <= ping_storage_data_61 ^ input_data(159 % IN_WIDTH);
            276 / IN_WIDTH: ping_storage_data_61 <= ping_storage_data_61 ^ input_data(276 % IN_WIDTH);
            774 / IN_WIDTH: ping_storage_data_61 <= ping_storage_data_61 ^ input_data(774 % IN_WIDTH);
            938 / IN_WIDTH: ping_storage_data_61 <= ping_storage_data_61 ^ input_data(938 % IN_WIDTH);
            default: pong_storage_data_61 <= pong_storage_data_61;
            endcase
        end else begin
            case (input_count)
            159 / IN_WIDTH: pong_storage_data_61 <= pong_storage_data_61 ^ input_data(159 % IN_WIDTH);
            276 / IN_WIDTH: pong_storage_data_61 <= pong_storage_data_61 ^ input_data(276 % IN_WIDTH);
            774 / IN_WIDTH: pong_storage_data_61 <= pong_storage_data_61 ^ input_data(774 % IN_WIDTH);
            938 / IN_WIDTH: pong_storage_data_61 <= pong_storage_data_61 ^ input_data(938 % IN_WIDTH);
            default: pong_storage_data_61 <= pong_storage_data_61;
            endcase
        end
    end
end

logic ping_storage_data_62;
logic pong_storage_data_62;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            160 / IN_WIDTH: ping_storage_data_62 <= ping_storage_data_62 ^ input_data(160 % IN_WIDTH);
            277 / IN_WIDTH: ping_storage_data_62 <= ping_storage_data_62 ^ input_data(277 % IN_WIDTH);
            775 / IN_WIDTH: ping_storage_data_62 <= ping_storage_data_62 ^ input_data(775 % IN_WIDTH);
            939 / IN_WIDTH: ping_storage_data_62 <= ping_storage_data_62 ^ input_data(939 % IN_WIDTH);
            default: pong_storage_data_62 <= pong_storage_data_62;
            endcase
        end else begin
            case (input_count)
            160 / IN_WIDTH: pong_storage_data_62 <= pong_storage_data_62 ^ input_data(160 % IN_WIDTH);
            277 / IN_WIDTH: pong_storage_data_62 <= pong_storage_data_62 ^ input_data(277 % IN_WIDTH);
            775 / IN_WIDTH: pong_storage_data_62 <= pong_storage_data_62 ^ input_data(775 % IN_WIDTH);
            939 / IN_WIDTH: pong_storage_data_62 <= pong_storage_data_62 ^ input_data(939 % IN_WIDTH);
            default: pong_storage_data_62 <= pong_storage_data_62;
            endcase
        end
    end
end

logic ping_storage_data_63;
logic pong_storage_data_63;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            161 / IN_WIDTH: ping_storage_data_63 <= ping_storage_data_63 ^ input_data(161 % IN_WIDTH);
            278 / IN_WIDTH: ping_storage_data_63 <= ping_storage_data_63 ^ input_data(278 % IN_WIDTH);
            776 / IN_WIDTH: ping_storage_data_63 <= ping_storage_data_63 ^ input_data(776 % IN_WIDTH);
            940 / IN_WIDTH: ping_storage_data_63 <= ping_storage_data_63 ^ input_data(940 % IN_WIDTH);
            default: pong_storage_data_63 <= pong_storage_data_63;
            endcase
        end else begin
            case (input_count)
            161 / IN_WIDTH: pong_storage_data_63 <= pong_storage_data_63 ^ input_data(161 % IN_WIDTH);
            278 / IN_WIDTH: pong_storage_data_63 <= pong_storage_data_63 ^ input_data(278 % IN_WIDTH);
            776 / IN_WIDTH: pong_storage_data_63 <= pong_storage_data_63 ^ input_data(776 % IN_WIDTH);
            940 / IN_WIDTH: pong_storage_data_63 <= pong_storage_data_63 ^ input_data(940 % IN_WIDTH);
            default: pong_storage_data_63 <= pong_storage_data_63;
            endcase
        end
    end
end

logic ping_storage_data_64;
logic pong_storage_data_64;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            162 / IN_WIDTH: ping_storage_data_64 <= ping_storage_data_64 ^ input_data(162 % IN_WIDTH);
            279 / IN_WIDTH: ping_storage_data_64 <= ping_storage_data_64 ^ input_data(279 % IN_WIDTH);
            777 / IN_WIDTH: ping_storage_data_64 <= ping_storage_data_64 ^ input_data(777 % IN_WIDTH);
            941 / IN_WIDTH: ping_storage_data_64 <= ping_storage_data_64 ^ input_data(941 % IN_WIDTH);
            default: pong_storage_data_64 <= pong_storage_data_64;
            endcase
        end else begin
            case (input_count)
            162 / IN_WIDTH: pong_storage_data_64 <= pong_storage_data_64 ^ input_data(162 % IN_WIDTH);
            279 / IN_WIDTH: pong_storage_data_64 <= pong_storage_data_64 ^ input_data(279 % IN_WIDTH);
            777 / IN_WIDTH: pong_storage_data_64 <= pong_storage_data_64 ^ input_data(777 % IN_WIDTH);
            941 / IN_WIDTH: pong_storage_data_64 <= pong_storage_data_64 ^ input_data(941 % IN_WIDTH);
            default: pong_storage_data_64 <= pong_storage_data_64;
            endcase
        end
    end
end

logic ping_storage_data_65;
logic pong_storage_data_65;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            163 / IN_WIDTH: ping_storage_data_65 <= ping_storage_data_65 ^ input_data(163 % IN_WIDTH);
            280 / IN_WIDTH: ping_storage_data_65 <= ping_storage_data_65 ^ input_data(280 % IN_WIDTH);
            778 / IN_WIDTH: ping_storage_data_65 <= ping_storage_data_65 ^ input_data(778 % IN_WIDTH);
            942 / IN_WIDTH: ping_storage_data_65 <= ping_storage_data_65 ^ input_data(942 % IN_WIDTH);
            default: pong_storage_data_65 <= pong_storage_data_65;
            endcase
        end else begin
            case (input_count)
            163 / IN_WIDTH: pong_storage_data_65 <= pong_storage_data_65 ^ input_data(163 % IN_WIDTH);
            280 / IN_WIDTH: pong_storage_data_65 <= pong_storage_data_65 ^ input_data(280 % IN_WIDTH);
            778 / IN_WIDTH: pong_storage_data_65 <= pong_storage_data_65 ^ input_data(778 % IN_WIDTH);
            942 / IN_WIDTH: pong_storage_data_65 <= pong_storage_data_65 ^ input_data(942 % IN_WIDTH);
            default: pong_storage_data_65 <= pong_storage_data_65;
            endcase
        end
    end
end

logic ping_storage_data_66;
logic pong_storage_data_66;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            164 / IN_WIDTH: ping_storage_data_66 <= ping_storage_data_66 ^ input_data(164 % IN_WIDTH);
            281 / IN_WIDTH: ping_storage_data_66 <= ping_storage_data_66 ^ input_data(281 % IN_WIDTH);
            779 / IN_WIDTH: ping_storage_data_66 <= ping_storage_data_66 ^ input_data(779 % IN_WIDTH);
            943 / IN_WIDTH: ping_storage_data_66 <= ping_storage_data_66 ^ input_data(943 % IN_WIDTH);
            default: pong_storage_data_66 <= pong_storage_data_66;
            endcase
        end else begin
            case (input_count)
            164 / IN_WIDTH: pong_storage_data_66 <= pong_storage_data_66 ^ input_data(164 % IN_WIDTH);
            281 / IN_WIDTH: pong_storage_data_66 <= pong_storage_data_66 ^ input_data(281 % IN_WIDTH);
            779 / IN_WIDTH: pong_storage_data_66 <= pong_storage_data_66 ^ input_data(779 % IN_WIDTH);
            943 / IN_WIDTH: pong_storage_data_66 <= pong_storage_data_66 ^ input_data(943 % IN_WIDTH);
            default: pong_storage_data_66 <= pong_storage_data_66;
            endcase
        end
    end
end

logic ping_storage_data_67;
logic pong_storage_data_67;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            165 / IN_WIDTH: ping_storage_data_67 <= ping_storage_data_67 ^ input_data(165 % IN_WIDTH);
            282 / IN_WIDTH: ping_storage_data_67 <= ping_storage_data_67 ^ input_data(282 % IN_WIDTH);
            780 / IN_WIDTH: ping_storage_data_67 <= ping_storage_data_67 ^ input_data(780 % IN_WIDTH);
            944 / IN_WIDTH: ping_storage_data_67 <= ping_storage_data_67 ^ input_data(944 % IN_WIDTH);
            default: pong_storage_data_67 <= pong_storage_data_67;
            endcase
        end else begin
            case (input_count)
            165 / IN_WIDTH: pong_storage_data_67 <= pong_storage_data_67 ^ input_data(165 % IN_WIDTH);
            282 / IN_WIDTH: pong_storage_data_67 <= pong_storage_data_67 ^ input_data(282 % IN_WIDTH);
            780 / IN_WIDTH: pong_storage_data_67 <= pong_storage_data_67 ^ input_data(780 % IN_WIDTH);
            944 / IN_WIDTH: pong_storage_data_67 <= pong_storage_data_67 ^ input_data(944 % IN_WIDTH);
            default: pong_storage_data_67 <= pong_storage_data_67;
            endcase
        end
    end
end

logic ping_storage_data_68;
logic pong_storage_data_68;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            166 / IN_WIDTH: ping_storage_data_68 <= ping_storage_data_68 ^ input_data(166 % IN_WIDTH);
            283 / IN_WIDTH: ping_storage_data_68 <= ping_storage_data_68 ^ input_data(283 % IN_WIDTH);
            781 / IN_WIDTH: ping_storage_data_68 <= ping_storage_data_68 ^ input_data(781 % IN_WIDTH);
            945 / IN_WIDTH: ping_storage_data_68 <= ping_storage_data_68 ^ input_data(945 % IN_WIDTH);
            default: pong_storage_data_68 <= pong_storage_data_68;
            endcase
        end else begin
            case (input_count)
            166 / IN_WIDTH: pong_storage_data_68 <= pong_storage_data_68 ^ input_data(166 % IN_WIDTH);
            283 / IN_WIDTH: pong_storage_data_68 <= pong_storage_data_68 ^ input_data(283 % IN_WIDTH);
            781 / IN_WIDTH: pong_storage_data_68 <= pong_storage_data_68 ^ input_data(781 % IN_WIDTH);
            945 / IN_WIDTH: pong_storage_data_68 <= pong_storage_data_68 ^ input_data(945 % IN_WIDTH);
            default: pong_storage_data_68 <= pong_storage_data_68;
            endcase
        end
    end
end

logic ping_storage_data_69;
logic pong_storage_data_69;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            167 / IN_WIDTH: ping_storage_data_69 <= ping_storage_data_69 ^ input_data(167 % IN_WIDTH);
            284 / IN_WIDTH: ping_storage_data_69 <= ping_storage_data_69 ^ input_data(284 % IN_WIDTH);
            782 / IN_WIDTH: ping_storage_data_69 <= ping_storage_data_69 ^ input_data(782 % IN_WIDTH);
            946 / IN_WIDTH: ping_storage_data_69 <= ping_storage_data_69 ^ input_data(946 % IN_WIDTH);
            default: pong_storage_data_69 <= pong_storage_data_69;
            endcase
        end else begin
            case (input_count)
            167 / IN_WIDTH: pong_storage_data_69 <= pong_storage_data_69 ^ input_data(167 % IN_WIDTH);
            284 / IN_WIDTH: pong_storage_data_69 <= pong_storage_data_69 ^ input_data(284 % IN_WIDTH);
            782 / IN_WIDTH: pong_storage_data_69 <= pong_storage_data_69 ^ input_data(782 % IN_WIDTH);
            946 / IN_WIDTH: pong_storage_data_69 <= pong_storage_data_69 ^ input_data(946 % IN_WIDTH);
            default: pong_storage_data_69 <= pong_storage_data_69;
            endcase
        end
    end
end

logic ping_storage_data_70;
logic pong_storage_data_70;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            168 / IN_WIDTH: ping_storage_data_70 <= ping_storage_data_70 ^ input_data(168 % IN_WIDTH);
            285 / IN_WIDTH: ping_storage_data_70 <= ping_storage_data_70 ^ input_data(285 % IN_WIDTH);
            783 / IN_WIDTH: ping_storage_data_70 <= ping_storage_data_70 ^ input_data(783 % IN_WIDTH);
            947 / IN_WIDTH: ping_storage_data_70 <= ping_storage_data_70 ^ input_data(947 % IN_WIDTH);
            default: pong_storage_data_70 <= pong_storage_data_70;
            endcase
        end else begin
            case (input_count)
            168 / IN_WIDTH: pong_storage_data_70 <= pong_storage_data_70 ^ input_data(168 % IN_WIDTH);
            285 / IN_WIDTH: pong_storage_data_70 <= pong_storage_data_70 ^ input_data(285 % IN_WIDTH);
            783 / IN_WIDTH: pong_storage_data_70 <= pong_storage_data_70 ^ input_data(783 % IN_WIDTH);
            947 / IN_WIDTH: pong_storage_data_70 <= pong_storage_data_70 ^ input_data(947 % IN_WIDTH);
            default: pong_storage_data_70 <= pong_storage_data_70;
            endcase
        end
    end
end

logic ping_storage_data_71;
logic pong_storage_data_71;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            169 / IN_WIDTH: ping_storage_data_71 <= ping_storage_data_71 ^ input_data(169 % IN_WIDTH);
            286 / IN_WIDTH: ping_storage_data_71 <= ping_storage_data_71 ^ input_data(286 % IN_WIDTH);
            784 / IN_WIDTH: ping_storage_data_71 <= ping_storage_data_71 ^ input_data(784 % IN_WIDTH);
            948 / IN_WIDTH: ping_storage_data_71 <= ping_storage_data_71 ^ input_data(948 % IN_WIDTH);
            default: pong_storage_data_71 <= pong_storage_data_71;
            endcase
        end else begin
            case (input_count)
            169 / IN_WIDTH: pong_storage_data_71 <= pong_storage_data_71 ^ input_data(169 % IN_WIDTH);
            286 / IN_WIDTH: pong_storage_data_71 <= pong_storage_data_71 ^ input_data(286 % IN_WIDTH);
            784 / IN_WIDTH: pong_storage_data_71 <= pong_storage_data_71 ^ input_data(784 % IN_WIDTH);
            948 / IN_WIDTH: pong_storage_data_71 <= pong_storage_data_71 ^ input_data(948 % IN_WIDTH);
            default: pong_storage_data_71 <= pong_storage_data_71;
            endcase
        end
    end
end

logic ping_storage_data_72;
logic pong_storage_data_72;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            170 / IN_WIDTH: ping_storage_data_72 <= ping_storage_data_72 ^ input_data(170 % IN_WIDTH);
            287 / IN_WIDTH: ping_storage_data_72 <= ping_storage_data_72 ^ input_data(287 % IN_WIDTH);
            785 / IN_WIDTH: ping_storage_data_72 <= ping_storage_data_72 ^ input_data(785 % IN_WIDTH);
            949 / IN_WIDTH: ping_storage_data_72 <= ping_storage_data_72 ^ input_data(949 % IN_WIDTH);
            default: pong_storage_data_72 <= pong_storage_data_72;
            endcase
        end else begin
            case (input_count)
            170 / IN_WIDTH: pong_storage_data_72 <= pong_storage_data_72 ^ input_data(170 % IN_WIDTH);
            287 / IN_WIDTH: pong_storage_data_72 <= pong_storage_data_72 ^ input_data(287 % IN_WIDTH);
            785 / IN_WIDTH: pong_storage_data_72 <= pong_storage_data_72 ^ input_data(785 % IN_WIDTH);
            949 / IN_WIDTH: pong_storage_data_72 <= pong_storage_data_72 ^ input_data(949 % IN_WIDTH);
            default: pong_storage_data_72 <= pong_storage_data_72;
            endcase
        end
    end
end

logic ping_storage_data_73;
logic pong_storage_data_73;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            171 / IN_WIDTH: ping_storage_data_73 <= ping_storage_data_73 ^ input_data(171 % IN_WIDTH);
            192 / IN_WIDTH: ping_storage_data_73 <= ping_storage_data_73 ^ input_data(192 % IN_WIDTH);
            786 / IN_WIDTH: ping_storage_data_73 <= ping_storage_data_73 ^ input_data(786 % IN_WIDTH);
            950 / IN_WIDTH: ping_storage_data_73 <= ping_storage_data_73 ^ input_data(950 % IN_WIDTH);
            default: pong_storage_data_73 <= pong_storage_data_73;
            endcase
        end else begin
            case (input_count)
            171 / IN_WIDTH: pong_storage_data_73 <= pong_storage_data_73 ^ input_data(171 % IN_WIDTH);
            192 / IN_WIDTH: pong_storage_data_73 <= pong_storage_data_73 ^ input_data(192 % IN_WIDTH);
            786 / IN_WIDTH: pong_storage_data_73 <= pong_storage_data_73 ^ input_data(786 % IN_WIDTH);
            950 / IN_WIDTH: pong_storage_data_73 <= pong_storage_data_73 ^ input_data(950 % IN_WIDTH);
            default: pong_storage_data_73 <= pong_storage_data_73;
            endcase
        end
    end
end

logic ping_storage_data_74;
logic pong_storage_data_74;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            172 / IN_WIDTH: ping_storage_data_74 <= ping_storage_data_74 ^ input_data(172 % IN_WIDTH);
            193 / IN_WIDTH: ping_storage_data_74 <= ping_storage_data_74 ^ input_data(193 % IN_WIDTH);
            787 / IN_WIDTH: ping_storage_data_74 <= ping_storage_data_74 ^ input_data(787 % IN_WIDTH);
            951 / IN_WIDTH: ping_storage_data_74 <= ping_storage_data_74 ^ input_data(951 % IN_WIDTH);
            default: pong_storage_data_74 <= pong_storage_data_74;
            endcase
        end else begin
            case (input_count)
            172 / IN_WIDTH: pong_storage_data_74 <= pong_storage_data_74 ^ input_data(172 % IN_WIDTH);
            193 / IN_WIDTH: pong_storage_data_74 <= pong_storage_data_74 ^ input_data(193 % IN_WIDTH);
            787 / IN_WIDTH: pong_storage_data_74 <= pong_storage_data_74 ^ input_data(787 % IN_WIDTH);
            951 / IN_WIDTH: pong_storage_data_74 <= pong_storage_data_74 ^ input_data(951 % IN_WIDTH);
            default: pong_storage_data_74 <= pong_storage_data_74;
            endcase
        end
    end
end

logic ping_storage_data_75;
logic pong_storage_data_75;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            173 / IN_WIDTH: ping_storage_data_75 <= ping_storage_data_75 ^ input_data(173 % IN_WIDTH);
            194 / IN_WIDTH: ping_storage_data_75 <= ping_storage_data_75 ^ input_data(194 % IN_WIDTH);
            788 / IN_WIDTH: ping_storage_data_75 <= ping_storage_data_75 ^ input_data(788 % IN_WIDTH);
            952 / IN_WIDTH: ping_storage_data_75 <= ping_storage_data_75 ^ input_data(952 % IN_WIDTH);
            default: pong_storage_data_75 <= pong_storage_data_75;
            endcase
        end else begin
            case (input_count)
            173 / IN_WIDTH: pong_storage_data_75 <= pong_storage_data_75 ^ input_data(173 % IN_WIDTH);
            194 / IN_WIDTH: pong_storage_data_75 <= pong_storage_data_75 ^ input_data(194 % IN_WIDTH);
            788 / IN_WIDTH: pong_storage_data_75 <= pong_storage_data_75 ^ input_data(788 % IN_WIDTH);
            952 / IN_WIDTH: pong_storage_data_75 <= pong_storage_data_75 ^ input_data(952 % IN_WIDTH);
            default: pong_storage_data_75 <= pong_storage_data_75;
            endcase
        end
    end
end

logic ping_storage_data_76;
logic pong_storage_data_76;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            174 / IN_WIDTH: ping_storage_data_76 <= ping_storage_data_76 ^ input_data(174 % IN_WIDTH);
            195 / IN_WIDTH: ping_storage_data_76 <= ping_storage_data_76 ^ input_data(195 % IN_WIDTH);
            789 / IN_WIDTH: ping_storage_data_76 <= ping_storage_data_76 ^ input_data(789 % IN_WIDTH);
            953 / IN_WIDTH: ping_storage_data_76 <= ping_storage_data_76 ^ input_data(953 % IN_WIDTH);
            default: pong_storage_data_76 <= pong_storage_data_76;
            endcase
        end else begin
            case (input_count)
            174 / IN_WIDTH: pong_storage_data_76 <= pong_storage_data_76 ^ input_data(174 % IN_WIDTH);
            195 / IN_WIDTH: pong_storage_data_76 <= pong_storage_data_76 ^ input_data(195 % IN_WIDTH);
            789 / IN_WIDTH: pong_storage_data_76 <= pong_storage_data_76 ^ input_data(789 % IN_WIDTH);
            953 / IN_WIDTH: pong_storage_data_76 <= pong_storage_data_76 ^ input_data(953 % IN_WIDTH);
            default: pong_storage_data_76 <= pong_storage_data_76;
            endcase
        end
    end
end

logic ping_storage_data_77;
logic pong_storage_data_77;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            175 / IN_WIDTH: ping_storage_data_77 <= ping_storage_data_77 ^ input_data(175 % IN_WIDTH);
            196 / IN_WIDTH: ping_storage_data_77 <= ping_storage_data_77 ^ input_data(196 % IN_WIDTH);
            790 / IN_WIDTH: ping_storage_data_77 <= ping_storage_data_77 ^ input_data(790 % IN_WIDTH);
            954 / IN_WIDTH: ping_storage_data_77 <= ping_storage_data_77 ^ input_data(954 % IN_WIDTH);
            default: pong_storage_data_77 <= pong_storage_data_77;
            endcase
        end else begin
            case (input_count)
            175 / IN_WIDTH: pong_storage_data_77 <= pong_storage_data_77 ^ input_data(175 % IN_WIDTH);
            196 / IN_WIDTH: pong_storage_data_77 <= pong_storage_data_77 ^ input_data(196 % IN_WIDTH);
            790 / IN_WIDTH: pong_storage_data_77 <= pong_storage_data_77 ^ input_data(790 % IN_WIDTH);
            954 / IN_WIDTH: pong_storage_data_77 <= pong_storage_data_77 ^ input_data(954 % IN_WIDTH);
            default: pong_storage_data_77 <= pong_storage_data_77;
            endcase
        end
    end
end

logic ping_storage_data_78;
logic pong_storage_data_78;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            176 / IN_WIDTH: ping_storage_data_78 <= ping_storage_data_78 ^ input_data(176 % IN_WIDTH);
            197 / IN_WIDTH: ping_storage_data_78 <= ping_storage_data_78 ^ input_data(197 % IN_WIDTH);
            791 / IN_WIDTH: ping_storage_data_78 <= ping_storage_data_78 ^ input_data(791 % IN_WIDTH);
            955 / IN_WIDTH: ping_storage_data_78 <= ping_storage_data_78 ^ input_data(955 % IN_WIDTH);
            default: pong_storage_data_78 <= pong_storage_data_78;
            endcase
        end else begin
            case (input_count)
            176 / IN_WIDTH: pong_storage_data_78 <= pong_storage_data_78 ^ input_data(176 % IN_WIDTH);
            197 / IN_WIDTH: pong_storage_data_78 <= pong_storage_data_78 ^ input_data(197 % IN_WIDTH);
            791 / IN_WIDTH: pong_storage_data_78 <= pong_storage_data_78 ^ input_data(791 % IN_WIDTH);
            955 / IN_WIDTH: pong_storage_data_78 <= pong_storage_data_78 ^ input_data(955 % IN_WIDTH);
            default: pong_storage_data_78 <= pong_storage_data_78;
            endcase
        end
    end
end

logic ping_storage_data_79;
logic pong_storage_data_79;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            177 / IN_WIDTH: ping_storage_data_79 <= ping_storage_data_79 ^ input_data(177 % IN_WIDTH);
            198 / IN_WIDTH: ping_storage_data_79 <= ping_storage_data_79 ^ input_data(198 % IN_WIDTH);
            792 / IN_WIDTH: ping_storage_data_79 <= ping_storage_data_79 ^ input_data(792 % IN_WIDTH);
            956 / IN_WIDTH: ping_storage_data_79 <= ping_storage_data_79 ^ input_data(956 % IN_WIDTH);
            default: pong_storage_data_79 <= pong_storage_data_79;
            endcase
        end else begin
            case (input_count)
            177 / IN_WIDTH: pong_storage_data_79 <= pong_storage_data_79 ^ input_data(177 % IN_WIDTH);
            198 / IN_WIDTH: pong_storage_data_79 <= pong_storage_data_79 ^ input_data(198 % IN_WIDTH);
            792 / IN_WIDTH: pong_storage_data_79 <= pong_storage_data_79 ^ input_data(792 % IN_WIDTH);
            956 / IN_WIDTH: pong_storage_data_79 <= pong_storage_data_79 ^ input_data(956 % IN_WIDTH);
            default: pong_storage_data_79 <= pong_storage_data_79;
            endcase
        end
    end
end

logic ping_storage_data_80;
logic pong_storage_data_80;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            178 / IN_WIDTH: ping_storage_data_80 <= ping_storage_data_80 ^ input_data(178 % IN_WIDTH);
            199 / IN_WIDTH: ping_storage_data_80 <= ping_storage_data_80 ^ input_data(199 % IN_WIDTH);
            793 / IN_WIDTH: ping_storage_data_80 <= ping_storage_data_80 ^ input_data(793 % IN_WIDTH);
            957 / IN_WIDTH: ping_storage_data_80 <= ping_storage_data_80 ^ input_data(957 % IN_WIDTH);
            default: pong_storage_data_80 <= pong_storage_data_80;
            endcase
        end else begin
            case (input_count)
            178 / IN_WIDTH: pong_storage_data_80 <= pong_storage_data_80 ^ input_data(178 % IN_WIDTH);
            199 / IN_WIDTH: pong_storage_data_80 <= pong_storage_data_80 ^ input_data(199 % IN_WIDTH);
            793 / IN_WIDTH: pong_storage_data_80 <= pong_storage_data_80 ^ input_data(793 % IN_WIDTH);
            957 / IN_WIDTH: pong_storage_data_80 <= pong_storage_data_80 ^ input_data(957 % IN_WIDTH);
            default: pong_storage_data_80 <= pong_storage_data_80;
            endcase
        end
    end
end

logic ping_storage_data_81;
logic pong_storage_data_81;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            179 / IN_WIDTH: ping_storage_data_81 <= ping_storage_data_81 ^ input_data(179 % IN_WIDTH);
            200 / IN_WIDTH: ping_storage_data_81 <= ping_storage_data_81 ^ input_data(200 % IN_WIDTH);
            794 / IN_WIDTH: ping_storage_data_81 <= ping_storage_data_81 ^ input_data(794 % IN_WIDTH);
            958 / IN_WIDTH: ping_storage_data_81 <= ping_storage_data_81 ^ input_data(958 % IN_WIDTH);
            default: pong_storage_data_81 <= pong_storage_data_81;
            endcase
        end else begin
            case (input_count)
            179 / IN_WIDTH: pong_storage_data_81 <= pong_storage_data_81 ^ input_data(179 % IN_WIDTH);
            200 / IN_WIDTH: pong_storage_data_81 <= pong_storage_data_81 ^ input_data(200 % IN_WIDTH);
            794 / IN_WIDTH: pong_storage_data_81 <= pong_storage_data_81 ^ input_data(794 % IN_WIDTH);
            958 / IN_WIDTH: pong_storage_data_81 <= pong_storage_data_81 ^ input_data(958 % IN_WIDTH);
            default: pong_storage_data_81 <= pong_storage_data_81;
            endcase
        end
    end
end

logic ping_storage_data_82;
logic pong_storage_data_82;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            180 / IN_WIDTH: ping_storage_data_82 <= ping_storage_data_82 ^ input_data(180 % IN_WIDTH);
            201 / IN_WIDTH: ping_storage_data_82 <= ping_storage_data_82 ^ input_data(201 % IN_WIDTH);
            795 / IN_WIDTH: ping_storage_data_82 <= ping_storage_data_82 ^ input_data(795 % IN_WIDTH);
            959 / IN_WIDTH: ping_storage_data_82 <= ping_storage_data_82 ^ input_data(959 % IN_WIDTH);
            default: pong_storage_data_82 <= pong_storage_data_82;
            endcase
        end else begin
            case (input_count)
            180 / IN_WIDTH: pong_storage_data_82 <= pong_storage_data_82 ^ input_data(180 % IN_WIDTH);
            201 / IN_WIDTH: pong_storage_data_82 <= pong_storage_data_82 ^ input_data(201 % IN_WIDTH);
            795 / IN_WIDTH: pong_storage_data_82 <= pong_storage_data_82 ^ input_data(795 % IN_WIDTH);
            959 / IN_WIDTH: pong_storage_data_82 <= pong_storage_data_82 ^ input_data(959 % IN_WIDTH);
            default: pong_storage_data_82 <= pong_storage_data_82;
            endcase
        end
    end
end

logic ping_storage_data_83;
logic pong_storage_data_83;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            181 / IN_WIDTH: ping_storage_data_83 <= ping_storage_data_83 ^ input_data(181 % IN_WIDTH);
            202 / IN_WIDTH: ping_storage_data_83 <= ping_storage_data_83 ^ input_data(202 % IN_WIDTH);
            796 / IN_WIDTH: ping_storage_data_83 <= ping_storage_data_83 ^ input_data(796 % IN_WIDTH);
            864 / IN_WIDTH: ping_storage_data_83 <= ping_storage_data_83 ^ input_data(864 % IN_WIDTH);
            default: pong_storage_data_83 <= pong_storage_data_83;
            endcase
        end else begin
            case (input_count)
            181 / IN_WIDTH: pong_storage_data_83 <= pong_storage_data_83 ^ input_data(181 % IN_WIDTH);
            202 / IN_WIDTH: pong_storage_data_83 <= pong_storage_data_83 ^ input_data(202 % IN_WIDTH);
            796 / IN_WIDTH: pong_storage_data_83 <= pong_storage_data_83 ^ input_data(796 % IN_WIDTH);
            864 / IN_WIDTH: pong_storage_data_83 <= pong_storage_data_83 ^ input_data(864 % IN_WIDTH);
            default: pong_storage_data_83 <= pong_storage_data_83;
            endcase
        end
    end
end

logic ping_storage_data_84;
logic pong_storage_data_84;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            182 / IN_WIDTH: ping_storage_data_84 <= ping_storage_data_84 ^ input_data(182 % IN_WIDTH);
            203 / IN_WIDTH: ping_storage_data_84 <= ping_storage_data_84 ^ input_data(203 % IN_WIDTH);
            797 / IN_WIDTH: ping_storage_data_84 <= ping_storage_data_84 ^ input_data(797 % IN_WIDTH);
            865 / IN_WIDTH: ping_storage_data_84 <= ping_storage_data_84 ^ input_data(865 % IN_WIDTH);
            default: pong_storage_data_84 <= pong_storage_data_84;
            endcase
        end else begin
            case (input_count)
            182 / IN_WIDTH: pong_storage_data_84 <= pong_storage_data_84 ^ input_data(182 % IN_WIDTH);
            203 / IN_WIDTH: pong_storage_data_84 <= pong_storage_data_84 ^ input_data(203 % IN_WIDTH);
            797 / IN_WIDTH: pong_storage_data_84 <= pong_storage_data_84 ^ input_data(797 % IN_WIDTH);
            865 / IN_WIDTH: pong_storage_data_84 <= pong_storage_data_84 ^ input_data(865 % IN_WIDTH);
            default: pong_storage_data_84 <= pong_storage_data_84;
            endcase
        end
    end
end

logic ping_storage_data_85;
logic pong_storage_data_85;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            183 / IN_WIDTH: ping_storage_data_85 <= ping_storage_data_85 ^ input_data(183 % IN_WIDTH);
            204 / IN_WIDTH: ping_storage_data_85 <= ping_storage_data_85 ^ input_data(204 % IN_WIDTH);
            798 / IN_WIDTH: ping_storage_data_85 <= ping_storage_data_85 ^ input_data(798 % IN_WIDTH);
            866 / IN_WIDTH: ping_storage_data_85 <= ping_storage_data_85 ^ input_data(866 % IN_WIDTH);
            default: pong_storage_data_85 <= pong_storage_data_85;
            endcase
        end else begin
            case (input_count)
            183 / IN_WIDTH: pong_storage_data_85 <= pong_storage_data_85 ^ input_data(183 % IN_WIDTH);
            204 / IN_WIDTH: pong_storage_data_85 <= pong_storage_data_85 ^ input_data(204 % IN_WIDTH);
            798 / IN_WIDTH: pong_storage_data_85 <= pong_storage_data_85 ^ input_data(798 % IN_WIDTH);
            866 / IN_WIDTH: pong_storage_data_85 <= pong_storage_data_85 ^ input_data(866 % IN_WIDTH);
            default: pong_storage_data_85 <= pong_storage_data_85;
            endcase
        end
    end
end

logic ping_storage_data_86;
logic pong_storage_data_86;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            184 / IN_WIDTH: ping_storage_data_86 <= ping_storage_data_86 ^ input_data(184 % IN_WIDTH);
            205 / IN_WIDTH: ping_storage_data_86 <= ping_storage_data_86 ^ input_data(205 % IN_WIDTH);
            799 / IN_WIDTH: ping_storage_data_86 <= ping_storage_data_86 ^ input_data(799 % IN_WIDTH);
            867 / IN_WIDTH: ping_storage_data_86 <= ping_storage_data_86 ^ input_data(867 % IN_WIDTH);
            default: pong_storage_data_86 <= pong_storage_data_86;
            endcase
        end else begin
            case (input_count)
            184 / IN_WIDTH: pong_storage_data_86 <= pong_storage_data_86 ^ input_data(184 % IN_WIDTH);
            205 / IN_WIDTH: pong_storage_data_86 <= pong_storage_data_86 ^ input_data(205 % IN_WIDTH);
            799 / IN_WIDTH: pong_storage_data_86 <= pong_storage_data_86 ^ input_data(799 % IN_WIDTH);
            867 / IN_WIDTH: pong_storage_data_86 <= pong_storage_data_86 ^ input_data(867 % IN_WIDTH);
            default: pong_storage_data_86 <= pong_storage_data_86;
            endcase
        end
    end
end

logic ping_storage_data_87;
logic pong_storage_data_87;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            185 / IN_WIDTH: ping_storage_data_87 <= ping_storage_data_87 ^ input_data(185 % IN_WIDTH);
            206 / IN_WIDTH: ping_storage_data_87 <= ping_storage_data_87 ^ input_data(206 % IN_WIDTH);
            800 / IN_WIDTH: ping_storage_data_87 <= ping_storage_data_87 ^ input_data(800 % IN_WIDTH);
            868 / IN_WIDTH: ping_storage_data_87 <= ping_storage_data_87 ^ input_data(868 % IN_WIDTH);
            default: pong_storage_data_87 <= pong_storage_data_87;
            endcase
        end else begin
            case (input_count)
            185 / IN_WIDTH: pong_storage_data_87 <= pong_storage_data_87 ^ input_data(185 % IN_WIDTH);
            206 / IN_WIDTH: pong_storage_data_87 <= pong_storage_data_87 ^ input_data(206 % IN_WIDTH);
            800 / IN_WIDTH: pong_storage_data_87 <= pong_storage_data_87 ^ input_data(800 % IN_WIDTH);
            868 / IN_WIDTH: pong_storage_data_87 <= pong_storage_data_87 ^ input_data(868 % IN_WIDTH);
            default: pong_storage_data_87 <= pong_storage_data_87;
            endcase
        end
    end
end

logic ping_storage_data_88;
logic pong_storage_data_88;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            186 / IN_WIDTH: ping_storage_data_88 <= ping_storage_data_88 ^ input_data(186 % IN_WIDTH);
            207 / IN_WIDTH: ping_storage_data_88 <= ping_storage_data_88 ^ input_data(207 % IN_WIDTH);
            801 / IN_WIDTH: ping_storage_data_88 <= ping_storage_data_88 ^ input_data(801 % IN_WIDTH);
            869 / IN_WIDTH: ping_storage_data_88 <= ping_storage_data_88 ^ input_data(869 % IN_WIDTH);
            default: pong_storage_data_88 <= pong_storage_data_88;
            endcase
        end else begin
            case (input_count)
            186 / IN_WIDTH: pong_storage_data_88 <= pong_storage_data_88 ^ input_data(186 % IN_WIDTH);
            207 / IN_WIDTH: pong_storage_data_88 <= pong_storage_data_88 ^ input_data(207 % IN_WIDTH);
            801 / IN_WIDTH: pong_storage_data_88 <= pong_storage_data_88 ^ input_data(801 % IN_WIDTH);
            869 / IN_WIDTH: pong_storage_data_88 <= pong_storage_data_88 ^ input_data(869 % IN_WIDTH);
            default: pong_storage_data_88 <= pong_storage_data_88;
            endcase
        end
    end
end

logic ping_storage_data_89;
logic pong_storage_data_89;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            187 / IN_WIDTH: ping_storage_data_89 <= ping_storage_data_89 ^ input_data(187 % IN_WIDTH);
            208 / IN_WIDTH: ping_storage_data_89 <= ping_storage_data_89 ^ input_data(208 % IN_WIDTH);
            802 / IN_WIDTH: ping_storage_data_89 <= ping_storage_data_89 ^ input_data(802 % IN_WIDTH);
            870 / IN_WIDTH: ping_storage_data_89 <= ping_storage_data_89 ^ input_data(870 % IN_WIDTH);
            default: pong_storage_data_89 <= pong_storage_data_89;
            endcase
        end else begin
            case (input_count)
            187 / IN_WIDTH: pong_storage_data_89 <= pong_storage_data_89 ^ input_data(187 % IN_WIDTH);
            208 / IN_WIDTH: pong_storage_data_89 <= pong_storage_data_89 ^ input_data(208 % IN_WIDTH);
            802 / IN_WIDTH: pong_storage_data_89 <= pong_storage_data_89 ^ input_data(802 % IN_WIDTH);
            870 / IN_WIDTH: pong_storage_data_89 <= pong_storage_data_89 ^ input_data(870 % IN_WIDTH);
            default: pong_storage_data_89 <= pong_storage_data_89;
            endcase
        end
    end
end

logic ping_storage_data_90;
logic pong_storage_data_90;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            188 / IN_WIDTH: ping_storage_data_90 <= ping_storage_data_90 ^ input_data(188 % IN_WIDTH);
            209 / IN_WIDTH: ping_storage_data_90 <= ping_storage_data_90 ^ input_data(209 % IN_WIDTH);
            803 / IN_WIDTH: ping_storage_data_90 <= ping_storage_data_90 ^ input_data(803 % IN_WIDTH);
            871 / IN_WIDTH: ping_storage_data_90 <= ping_storage_data_90 ^ input_data(871 % IN_WIDTH);
            default: pong_storage_data_90 <= pong_storage_data_90;
            endcase
        end else begin
            case (input_count)
            188 / IN_WIDTH: pong_storage_data_90 <= pong_storage_data_90 ^ input_data(188 % IN_WIDTH);
            209 / IN_WIDTH: pong_storage_data_90 <= pong_storage_data_90 ^ input_data(209 % IN_WIDTH);
            803 / IN_WIDTH: pong_storage_data_90 <= pong_storage_data_90 ^ input_data(803 % IN_WIDTH);
            871 / IN_WIDTH: pong_storage_data_90 <= pong_storage_data_90 ^ input_data(871 % IN_WIDTH);
            default: pong_storage_data_90 <= pong_storage_data_90;
            endcase
        end
    end
end

logic ping_storage_data_91;
logic pong_storage_data_91;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            189 / IN_WIDTH: ping_storage_data_91 <= ping_storage_data_91 ^ input_data(189 % IN_WIDTH);
            210 / IN_WIDTH: ping_storage_data_91 <= ping_storage_data_91 ^ input_data(210 % IN_WIDTH);
            804 / IN_WIDTH: ping_storage_data_91 <= ping_storage_data_91 ^ input_data(804 % IN_WIDTH);
            872 / IN_WIDTH: ping_storage_data_91 <= ping_storage_data_91 ^ input_data(872 % IN_WIDTH);
            default: pong_storage_data_91 <= pong_storage_data_91;
            endcase
        end else begin
            case (input_count)
            189 / IN_WIDTH: pong_storage_data_91 <= pong_storage_data_91 ^ input_data(189 % IN_WIDTH);
            210 / IN_WIDTH: pong_storage_data_91 <= pong_storage_data_91 ^ input_data(210 % IN_WIDTH);
            804 / IN_WIDTH: pong_storage_data_91 <= pong_storage_data_91 ^ input_data(804 % IN_WIDTH);
            872 / IN_WIDTH: pong_storage_data_91 <= pong_storage_data_91 ^ input_data(872 % IN_WIDTH);
            default: pong_storage_data_91 <= pong_storage_data_91;
            endcase
        end
    end
end

logic ping_storage_data_92;
logic pong_storage_data_92;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            190 / IN_WIDTH: ping_storage_data_92 <= ping_storage_data_92 ^ input_data(190 % IN_WIDTH);
            211 / IN_WIDTH: ping_storage_data_92 <= ping_storage_data_92 ^ input_data(211 % IN_WIDTH);
            805 / IN_WIDTH: ping_storage_data_92 <= ping_storage_data_92 ^ input_data(805 % IN_WIDTH);
            873 / IN_WIDTH: ping_storage_data_92 <= ping_storage_data_92 ^ input_data(873 % IN_WIDTH);
            default: pong_storage_data_92 <= pong_storage_data_92;
            endcase
        end else begin
            case (input_count)
            190 / IN_WIDTH: pong_storage_data_92 <= pong_storage_data_92 ^ input_data(190 % IN_WIDTH);
            211 / IN_WIDTH: pong_storage_data_92 <= pong_storage_data_92 ^ input_data(211 % IN_WIDTH);
            805 / IN_WIDTH: pong_storage_data_92 <= pong_storage_data_92 ^ input_data(805 % IN_WIDTH);
            873 / IN_WIDTH: pong_storage_data_92 <= pong_storage_data_92 ^ input_data(873 % IN_WIDTH);
            default: pong_storage_data_92 <= pong_storage_data_92;
            endcase
        end
    end
end

logic ping_storage_data_93;
logic pong_storage_data_93;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            191 / IN_WIDTH: ping_storage_data_93 <= ping_storage_data_93 ^ input_data(191 % IN_WIDTH);
            212 / IN_WIDTH: ping_storage_data_93 <= ping_storage_data_93 ^ input_data(212 % IN_WIDTH);
            806 / IN_WIDTH: ping_storage_data_93 <= ping_storage_data_93 ^ input_data(806 % IN_WIDTH);
            874 / IN_WIDTH: ping_storage_data_93 <= ping_storage_data_93 ^ input_data(874 % IN_WIDTH);
            default: pong_storage_data_93 <= pong_storage_data_93;
            endcase
        end else begin
            case (input_count)
            191 / IN_WIDTH: pong_storage_data_93 <= pong_storage_data_93 ^ input_data(191 % IN_WIDTH);
            212 / IN_WIDTH: pong_storage_data_93 <= pong_storage_data_93 ^ input_data(212 % IN_WIDTH);
            806 / IN_WIDTH: pong_storage_data_93 <= pong_storage_data_93 ^ input_data(806 % IN_WIDTH);
            874 / IN_WIDTH: pong_storage_data_93 <= pong_storage_data_93 ^ input_data(874 % IN_WIDTH);
            default: pong_storage_data_93 <= pong_storage_data_93;
            endcase
        end
    end
end

logic ping_storage_data_94;
logic pong_storage_data_94;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            96 / IN_WIDTH: ping_storage_data_94 <= ping_storage_data_94 ^ input_data(96 % IN_WIDTH);
            213 / IN_WIDTH: ping_storage_data_94 <= ping_storage_data_94 ^ input_data(213 % IN_WIDTH);
            807 / IN_WIDTH: ping_storage_data_94 <= ping_storage_data_94 ^ input_data(807 % IN_WIDTH);
            875 / IN_WIDTH: ping_storage_data_94 <= ping_storage_data_94 ^ input_data(875 % IN_WIDTH);
            default: pong_storage_data_94 <= pong_storage_data_94;
            endcase
        end else begin
            case (input_count)
            96 / IN_WIDTH: pong_storage_data_94 <= pong_storage_data_94 ^ input_data(96 % IN_WIDTH);
            213 / IN_WIDTH: pong_storage_data_94 <= pong_storage_data_94 ^ input_data(213 % IN_WIDTH);
            807 / IN_WIDTH: pong_storage_data_94 <= pong_storage_data_94 ^ input_data(807 % IN_WIDTH);
            875 / IN_WIDTH: pong_storage_data_94 <= pong_storage_data_94 ^ input_data(875 % IN_WIDTH);
            default: pong_storage_data_94 <= pong_storage_data_94;
            endcase
        end
    end
end

logic ping_storage_data_95;
logic pong_storage_data_95;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            97 / IN_WIDTH: ping_storage_data_95 <= ping_storage_data_95 ^ input_data(97 % IN_WIDTH);
            214 / IN_WIDTH: ping_storage_data_95 <= ping_storage_data_95 ^ input_data(214 % IN_WIDTH);
            808 / IN_WIDTH: ping_storage_data_95 <= ping_storage_data_95 ^ input_data(808 % IN_WIDTH);
            876 / IN_WIDTH: ping_storage_data_95 <= ping_storage_data_95 ^ input_data(876 % IN_WIDTH);
            default: pong_storage_data_95 <= pong_storage_data_95;
            endcase
        end else begin
            case (input_count)
            97 / IN_WIDTH: pong_storage_data_95 <= pong_storage_data_95 ^ input_data(97 % IN_WIDTH);
            214 / IN_WIDTH: pong_storage_data_95 <= pong_storage_data_95 ^ input_data(214 % IN_WIDTH);
            808 / IN_WIDTH: pong_storage_data_95 <= pong_storage_data_95 ^ input_data(808 % IN_WIDTH);
            876 / IN_WIDTH: pong_storage_data_95 <= pong_storage_data_95 ^ input_data(876 % IN_WIDTH);
            default: pong_storage_data_95 <= pong_storage_data_95;
            endcase
        end
    end
end

logic ping_storage_data_96;
logic pong_storage_data_96;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            165 / IN_WIDTH: ping_storage_data_96 <= ping_storage_data_96 ^ input_data(165 % IN_WIDTH);
            554 / IN_WIDTH: ping_storage_data_96 <= ping_storage_data_96 ^ input_data(554 % IN_WIDTH);
            593 / IN_WIDTH: ping_storage_data_96 <= ping_storage_data_96 ^ input_data(593 % IN_WIDTH);
            759 / IN_WIDTH: ping_storage_data_96 <= ping_storage_data_96 ^ input_data(759 % IN_WIDTH);
            1140 / IN_WIDTH: ping_storage_data_96 <= ping_storage_data_96 ^ input_data(1140 % IN_WIDTH);
            default: pong_storage_data_96 <= pong_storage_data_96;
            endcase
        end else begin
            case (input_count)
            165 / IN_WIDTH: pong_storage_data_96 <= pong_storage_data_96 ^ input_data(165 % IN_WIDTH);
            554 / IN_WIDTH: pong_storage_data_96 <= pong_storage_data_96 ^ input_data(554 % IN_WIDTH);
            593 / IN_WIDTH: pong_storage_data_96 <= pong_storage_data_96 ^ input_data(593 % IN_WIDTH);
            759 / IN_WIDTH: pong_storage_data_96 <= pong_storage_data_96 ^ input_data(759 % IN_WIDTH);
            1140 / IN_WIDTH: pong_storage_data_96 <= pong_storage_data_96 ^ input_data(1140 % IN_WIDTH);
            default: pong_storage_data_96 <= pong_storage_data_96;
            endcase
        end
    end
end

logic ping_storage_data_97;
logic pong_storage_data_97;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            166 / IN_WIDTH: ping_storage_data_97 <= ping_storage_data_97 ^ input_data(166 % IN_WIDTH);
            555 / IN_WIDTH: ping_storage_data_97 <= ping_storage_data_97 ^ input_data(555 % IN_WIDTH);
            594 / IN_WIDTH: ping_storage_data_97 <= ping_storage_data_97 ^ input_data(594 % IN_WIDTH);
            760 / IN_WIDTH: ping_storage_data_97 <= ping_storage_data_97 ^ input_data(760 % IN_WIDTH);
            1141 / IN_WIDTH: ping_storage_data_97 <= ping_storage_data_97 ^ input_data(1141 % IN_WIDTH);
            default: pong_storage_data_97 <= pong_storage_data_97;
            endcase
        end else begin
            case (input_count)
            166 / IN_WIDTH: pong_storage_data_97 <= pong_storage_data_97 ^ input_data(166 % IN_WIDTH);
            555 / IN_WIDTH: pong_storage_data_97 <= pong_storage_data_97 ^ input_data(555 % IN_WIDTH);
            594 / IN_WIDTH: pong_storage_data_97 <= pong_storage_data_97 ^ input_data(594 % IN_WIDTH);
            760 / IN_WIDTH: pong_storage_data_97 <= pong_storage_data_97 ^ input_data(760 % IN_WIDTH);
            1141 / IN_WIDTH: pong_storage_data_97 <= pong_storage_data_97 ^ input_data(1141 % IN_WIDTH);
            default: pong_storage_data_97 <= pong_storage_data_97;
            endcase
        end
    end
end

logic ping_storage_data_98;
logic pong_storage_data_98;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            167 / IN_WIDTH: ping_storage_data_98 <= ping_storage_data_98 ^ input_data(167 % IN_WIDTH);
            556 / IN_WIDTH: ping_storage_data_98 <= ping_storage_data_98 ^ input_data(556 % IN_WIDTH);
            595 / IN_WIDTH: ping_storage_data_98 <= ping_storage_data_98 ^ input_data(595 % IN_WIDTH);
            761 / IN_WIDTH: ping_storage_data_98 <= ping_storage_data_98 ^ input_data(761 % IN_WIDTH);
            1142 / IN_WIDTH: ping_storage_data_98 <= ping_storage_data_98 ^ input_data(1142 % IN_WIDTH);
            default: pong_storage_data_98 <= pong_storage_data_98;
            endcase
        end else begin
            case (input_count)
            167 / IN_WIDTH: pong_storage_data_98 <= pong_storage_data_98 ^ input_data(167 % IN_WIDTH);
            556 / IN_WIDTH: pong_storage_data_98 <= pong_storage_data_98 ^ input_data(556 % IN_WIDTH);
            595 / IN_WIDTH: pong_storage_data_98 <= pong_storage_data_98 ^ input_data(595 % IN_WIDTH);
            761 / IN_WIDTH: pong_storage_data_98 <= pong_storage_data_98 ^ input_data(761 % IN_WIDTH);
            1142 / IN_WIDTH: pong_storage_data_98 <= pong_storage_data_98 ^ input_data(1142 % IN_WIDTH);
            default: pong_storage_data_98 <= pong_storage_data_98;
            endcase
        end
    end
end

logic ping_storage_data_99;
logic pong_storage_data_99;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            168 / IN_WIDTH: ping_storage_data_99 <= ping_storage_data_99 ^ input_data(168 % IN_WIDTH);
            557 / IN_WIDTH: ping_storage_data_99 <= ping_storage_data_99 ^ input_data(557 % IN_WIDTH);
            596 / IN_WIDTH: ping_storage_data_99 <= ping_storage_data_99 ^ input_data(596 % IN_WIDTH);
            762 / IN_WIDTH: ping_storage_data_99 <= ping_storage_data_99 ^ input_data(762 % IN_WIDTH);
            1143 / IN_WIDTH: ping_storage_data_99 <= ping_storage_data_99 ^ input_data(1143 % IN_WIDTH);
            default: pong_storage_data_99 <= pong_storage_data_99;
            endcase
        end else begin
            case (input_count)
            168 / IN_WIDTH: pong_storage_data_99 <= pong_storage_data_99 ^ input_data(168 % IN_WIDTH);
            557 / IN_WIDTH: pong_storage_data_99 <= pong_storage_data_99 ^ input_data(557 % IN_WIDTH);
            596 / IN_WIDTH: pong_storage_data_99 <= pong_storage_data_99 ^ input_data(596 % IN_WIDTH);
            762 / IN_WIDTH: pong_storage_data_99 <= pong_storage_data_99 ^ input_data(762 % IN_WIDTH);
            1143 / IN_WIDTH: pong_storage_data_99 <= pong_storage_data_99 ^ input_data(1143 % IN_WIDTH);
            default: pong_storage_data_99 <= pong_storage_data_99;
            endcase
        end
    end
end

logic ping_storage_data_100;
logic pong_storage_data_100;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            169 / IN_WIDTH: ping_storage_data_100 <= ping_storage_data_100 ^ input_data(169 % IN_WIDTH);
            558 / IN_WIDTH: ping_storage_data_100 <= ping_storage_data_100 ^ input_data(558 % IN_WIDTH);
            597 / IN_WIDTH: ping_storage_data_100 <= ping_storage_data_100 ^ input_data(597 % IN_WIDTH);
            763 / IN_WIDTH: ping_storage_data_100 <= ping_storage_data_100 ^ input_data(763 % IN_WIDTH);
            1144 / IN_WIDTH: ping_storage_data_100 <= ping_storage_data_100 ^ input_data(1144 % IN_WIDTH);
            default: pong_storage_data_100 <= pong_storage_data_100;
            endcase
        end else begin
            case (input_count)
            169 / IN_WIDTH: pong_storage_data_100 <= pong_storage_data_100 ^ input_data(169 % IN_WIDTH);
            558 / IN_WIDTH: pong_storage_data_100 <= pong_storage_data_100 ^ input_data(558 % IN_WIDTH);
            597 / IN_WIDTH: pong_storage_data_100 <= pong_storage_data_100 ^ input_data(597 % IN_WIDTH);
            763 / IN_WIDTH: pong_storage_data_100 <= pong_storage_data_100 ^ input_data(763 % IN_WIDTH);
            1144 / IN_WIDTH: pong_storage_data_100 <= pong_storage_data_100 ^ input_data(1144 % IN_WIDTH);
            default: pong_storage_data_100 <= pong_storage_data_100;
            endcase
        end
    end
end

logic ping_storage_data_101;
logic pong_storage_data_101;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            170 / IN_WIDTH: ping_storage_data_101 <= ping_storage_data_101 ^ input_data(170 % IN_WIDTH);
            559 / IN_WIDTH: ping_storage_data_101 <= ping_storage_data_101 ^ input_data(559 % IN_WIDTH);
            598 / IN_WIDTH: ping_storage_data_101 <= ping_storage_data_101 ^ input_data(598 % IN_WIDTH);
            764 / IN_WIDTH: ping_storage_data_101 <= ping_storage_data_101 ^ input_data(764 % IN_WIDTH);
            1145 / IN_WIDTH: ping_storage_data_101 <= ping_storage_data_101 ^ input_data(1145 % IN_WIDTH);
            default: pong_storage_data_101 <= pong_storage_data_101;
            endcase
        end else begin
            case (input_count)
            170 / IN_WIDTH: pong_storage_data_101 <= pong_storage_data_101 ^ input_data(170 % IN_WIDTH);
            559 / IN_WIDTH: pong_storage_data_101 <= pong_storage_data_101 ^ input_data(559 % IN_WIDTH);
            598 / IN_WIDTH: pong_storage_data_101 <= pong_storage_data_101 ^ input_data(598 % IN_WIDTH);
            764 / IN_WIDTH: pong_storage_data_101 <= pong_storage_data_101 ^ input_data(764 % IN_WIDTH);
            1145 / IN_WIDTH: pong_storage_data_101 <= pong_storage_data_101 ^ input_data(1145 % IN_WIDTH);
            default: pong_storage_data_101 <= pong_storage_data_101;
            endcase
        end
    end
end

logic ping_storage_data_102;
logic pong_storage_data_102;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            171 / IN_WIDTH: ping_storage_data_102 <= ping_storage_data_102 ^ input_data(171 % IN_WIDTH);
            560 / IN_WIDTH: ping_storage_data_102 <= ping_storage_data_102 ^ input_data(560 % IN_WIDTH);
            599 / IN_WIDTH: ping_storage_data_102 <= ping_storage_data_102 ^ input_data(599 % IN_WIDTH);
            765 / IN_WIDTH: ping_storage_data_102 <= ping_storage_data_102 ^ input_data(765 % IN_WIDTH);
            1146 / IN_WIDTH: ping_storage_data_102 <= ping_storage_data_102 ^ input_data(1146 % IN_WIDTH);
            default: pong_storage_data_102 <= pong_storage_data_102;
            endcase
        end else begin
            case (input_count)
            171 / IN_WIDTH: pong_storage_data_102 <= pong_storage_data_102 ^ input_data(171 % IN_WIDTH);
            560 / IN_WIDTH: pong_storage_data_102 <= pong_storage_data_102 ^ input_data(560 % IN_WIDTH);
            599 / IN_WIDTH: pong_storage_data_102 <= pong_storage_data_102 ^ input_data(599 % IN_WIDTH);
            765 / IN_WIDTH: pong_storage_data_102 <= pong_storage_data_102 ^ input_data(765 % IN_WIDTH);
            1146 / IN_WIDTH: pong_storage_data_102 <= pong_storage_data_102 ^ input_data(1146 % IN_WIDTH);
            default: pong_storage_data_102 <= pong_storage_data_102;
            endcase
        end
    end
end

logic ping_storage_data_103;
logic pong_storage_data_103;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            172 / IN_WIDTH: ping_storage_data_103 <= ping_storage_data_103 ^ input_data(172 % IN_WIDTH);
            561 / IN_WIDTH: ping_storage_data_103 <= ping_storage_data_103 ^ input_data(561 % IN_WIDTH);
            600 / IN_WIDTH: ping_storage_data_103 <= ping_storage_data_103 ^ input_data(600 % IN_WIDTH);
            766 / IN_WIDTH: ping_storage_data_103 <= ping_storage_data_103 ^ input_data(766 % IN_WIDTH);
            1147 / IN_WIDTH: ping_storage_data_103 <= ping_storage_data_103 ^ input_data(1147 % IN_WIDTH);
            default: pong_storage_data_103 <= pong_storage_data_103;
            endcase
        end else begin
            case (input_count)
            172 / IN_WIDTH: pong_storage_data_103 <= pong_storage_data_103 ^ input_data(172 % IN_WIDTH);
            561 / IN_WIDTH: pong_storage_data_103 <= pong_storage_data_103 ^ input_data(561 % IN_WIDTH);
            600 / IN_WIDTH: pong_storage_data_103 <= pong_storage_data_103 ^ input_data(600 % IN_WIDTH);
            766 / IN_WIDTH: pong_storage_data_103 <= pong_storage_data_103 ^ input_data(766 % IN_WIDTH);
            1147 / IN_WIDTH: pong_storage_data_103 <= pong_storage_data_103 ^ input_data(1147 % IN_WIDTH);
            default: pong_storage_data_103 <= pong_storage_data_103;
            endcase
        end
    end
end

logic ping_storage_data_104;
logic pong_storage_data_104;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            173 / IN_WIDTH: ping_storage_data_104 <= ping_storage_data_104 ^ input_data(173 % IN_WIDTH);
            562 / IN_WIDTH: ping_storage_data_104 <= ping_storage_data_104 ^ input_data(562 % IN_WIDTH);
            601 / IN_WIDTH: ping_storage_data_104 <= ping_storage_data_104 ^ input_data(601 % IN_WIDTH);
            767 / IN_WIDTH: ping_storage_data_104 <= ping_storage_data_104 ^ input_data(767 % IN_WIDTH);
            1148 / IN_WIDTH: ping_storage_data_104 <= ping_storage_data_104 ^ input_data(1148 % IN_WIDTH);
            default: pong_storage_data_104 <= pong_storage_data_104;
            endcase
        end else begin
            case (input_count)
            173 / IN_WIDTH: pong_storage_data_104 <= pong_storage_data_104 ^ input_data(173 % IN_WIDTH);
            562 / IN_WIDTH: pong_storage_data_104 <= pong_storage_data_104 ^ input_data(562 % IN_WIDTH);
            601 / IN_WIDTH: pong_storage_data_104 <= pong_storage_data_104 ^ input_data(601 % IN_WIDTH);
            767 / IN_WIDTH: pong_storage_data_104 <= pong_storage_data_104 ^ input_data(767 % IN_WIDTH);
            1148 / IN_WIDTH: pong_storage_data_104 <= pong_storage_data_104 ^ input_data(1148 % IN_WIDTH);
            default: pong_storage_data_104 <= pong_storage_data_104;
            endcase
        end
    end
end

logic ping_storage_data_105;
logic pong_storage_data_105;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            174 / IN_WIDTH: ping_storage_data_105 <= ping_storage_data_105 ^ input_data(174 % IN_WIDTH);
            563 / IN_WIDTH: ping_storage_data_105 <= ping_storage_data_105 ^ input_data(563 % IN_WIDTH);
            602 / IN_WIDTH: ping_storage_data_105 <= ping_storage_data_105 ^ input_data(602 % IN_WIDTH);
            672 / IN_WIDTH: ping_storage_data_105 <= ping_storage_data_105 ^ input_data(672 % IN_WIDTH);
            1149 / IN_WIDTH: ping_storage_data_105 <= ping_storage_data_105 ^ input_data(1149 % IN_WIDTH);
            default: pong_storage_data_105 <= pong_storage_data_105;
            endcase
        end else begin
            case (input_count)
            174 / IN_WIDTH: pong_storage_data_105 <= pong_storage_data_105 ^ input_data(174 % IN_WIDTH);
            563 / IN_WIDTH: pong_storage_data_105 <= pong_storage_data_105 ^ input_data(563 % IN_WIDTH);
            602 / IN_WIDTH: pong_storage_data_105 <= pong_storage_data_105 ^ input_data(602 % IN_WIDTH);
            672 / IN_WIDTH: pong_storage_data_105 <= pong_storage_data_105 ^ input_data(672 % IN_WIDTH);
            1149 / IN_WIDTH: pong_storage_data_105 <= pong_storage_data_105 ^ input_data(1149 % IN_WIDTH);
            default: pong_storage_data_105 <= pong_storage_data_105;
            endcase
        end
    end
end

logic ping_storage_data_106;
logic pong_storage_data_106;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            175 / IN_WIDTH: ping_storage_data_106 <= ping_storage_data_106 ^ input_data(175 % IN_WIDTH);
            564 / IN_WIDTH: ping_storage_data_106 <= ping_storage_data_106 ^ input_data(564 % IN_WIDTH);
            603 / IN_WIDTH: ping_storage_data_106 <= ping_storage_data_106 ^ input_data(603 % IN_WIDTH);
            673 / IN_WIDTH: ping_storage_data_106 <= ping_storage_data_106 ^ input_data(673 % IN_WIDTH);
            1150 / IN_WIDTH: ping_storage_data_106 <= ping_storage_data_106 ^ input_data(1150 % IN_WIDTH);
            default: pong_storage_data_106 <= pong_storage_data_106;
            endcase
        end else begin
            case (input_count)
            175 / IN_WIDTH: pong_storage_data_106 <= pong_storage_data_106 ^ input_data(175 % IN_WIDTH);
            564 / IN_WIDTH: pong_storage_data_106 <= pong_storage_data_106 ^ input_data(564 % IN_WIDTH);
            603 / IN_WIDTH: pong_storage_data_106 <= pong_storage_data_106 ^ input_data(603 % IN_WIDTH);
            673 / IN_WIDTH: pong_storage_data_106 <= pong_storage_data_106 ^ input_data(673 % IN_WIDTH);
            1150 / IN_WIDTH: pong_storage_data_106 <= pong_storage_data_106 ^ input_data(1150 % IN_WIDTH);
            default: pong_storage_data_106 <= pong_storage_data_106;
            endcase
        end
    end
end

logic ping_storage_data_107;
logic pong_storage_data_107;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            176 / IN_WIDTH: ping_storage_data_107 <= ping_storage_data_107 ^ input_data(176 % IN_WIDTH);
            565 / IN_WIDTH: ping_storage_data_107 <= ping_storage_data_107 ^ input_data(565 % IN_WIDTH);
            604 / IN_WIDTH: ping_storage_data_107 <= ping_storage_data_107 ^ input_data(604 % IN_WIDTH);
            674 / IN_WIDTH: ping_storage_data_107 <= ping_storage_data_107 ^ input_data(674 % IN_WIDTH);
            1151 / IN_WIDTH: ping_storage_data_107 <= ping_storage_data_107 ^ input_data(1151 % IN_WIDTH);
            default: pong_storage_data_107 <= pong_storage_data_107;
            endcase
        end else begin
            case (input_count)
            176 / IN_WIDTH: pong_storage_data_107 <= pong_storage_data_107 ^ input_data(176 % IN_WIDTH);
            565 / IN_WIDTH: pong_storage_data_107 <= pong_storage_data_107 ^ input_data(565 % IN_WIDTH);
            604 / IN_WIDTH: pong_storage_data_107 <= pong_storage_data_107 ^ input_data(604 % IN_WIDTH);
            674 / IN_WIDTH: pong_storage_data_107 <= pong_storage_data_107 ^ input_data(674 % IN_WIDTH);
            1151 / IN_WIDTH: pong_storage_data_107 <= pong_storage_data_107 ^ input_data(1151 % IN_WIDTH);
            default: pong_storage_data_107 <= pong_storage_data_107;
            endcase
        end
    end
end

logic ping_storage_data_108;
logic pong_storage_data_108;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            177 / IN_WIDTH: ping_storage_data_108 <= ping_storage_data_108 ^ input_data(177 % IN_WIDTH);
            566 / IN_WIDTH: ping_storage_data_108 <= ping_storage_data_108 ^ input_data(566 % IN_WIDTH);
            605 / IN_WIDTH: ping_storage_data_108 <= ping_storage_data_108 ^ input_data(605 % IN_WIDTH);
            675 / IN_WIDTH: ping_storage_data_108 <= ping_storage_data_108 ^ input_data(675 % IN_WIDTH);
            1056 / IN_WIDTH: ping_storage_data_108 <= ping_storage_data_108 ^ input_data(1056 % IN_WIDTH);
            default: pong_storage_data_108 <= pong_storage_data_108;
            endcase
        end else begin
            case (input_count)
            177 / IN_WIDTH: pong_storage_data_108 <= pong_storage_data_108 ^ input_data(177 % IN_WIDTH);
            566 / IN_WIDTH: pong_storage_data_108 <= pong_storage_data_108 ^ input_data(566 % IN_WIDTH);
            605 / IN_WIDTH: pong_storage_data_108 <= pong_storage_data_108 ^ input_data(605 % IN_WIDTH);
            675 / IN_WIDTH: pong_storage_data_108 <= pong_storage_data_108 ^ input_data(675 % IN_WIDTH);
            1056 / IN_WIDTH: pong_storage_data_108 <= pong_storage_data_108 ^ input_data(1056 % IN_WIDTH);
            default: pong_storage_data_108 <= pong_storage_data_108;
            endcase
        end
    end
end

logic ping_storage_data_109;
logic pong_storage_data_109;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            178 / IN_WIDTH: ping_storage_data_109 <= ping_storage_data_109 ^ input_data(178 % IN_WIDTH);
            567 / IN_WIDTH: ping_storage_data_109 <= ping_storage_data_109 ^ input_data(567 % IN_WIDTH);
            606 / IN_WIDTH: ping_storage_data_109 <= ping_storage_data_109 ^ input_data(606 % IN_WIDTH);
            676 / IN_WIDTH: ping_storage_data_109 <= ping_storage_data_109 ^ input_data(676 % IN_WIDTH);
            1057 / IN_WIDTH: ping_storage_data_109 <= ping_storage_data_109 ^ input_data(1057 % IN_WIDTH);
            default: pong_storage_data_109 <= pong_storage_data_109;
            endcase
        end else begin
            case (input_count)
            178 / IN_WIDTH: pong_storage_data_109 <= pong_storage_data_109 ^ input_data(178 % IN_WIDTH);
            567 / IN_WIDTH: pong_storage_data_109 <= pong_storage_data_109 ^ input_data(567 % IN_WIDTH);
            606 / IN_WIDTH: pong_storage_data_109 <= pong_storage_data_109 ^ input_data(606 % IN_WIDTH);
            676 / IN_WIDTH: pong_storage_data_109 <= pong_storage_data_109 ^ input_data(676 % IN_WIDTH);
            1057 / IN_WIDTH: pong_storage_data_109 <= pong_storage_data_109 ^ input_data(1057 % IN_WIDTH);
            default: pong_storage_data_109 <= pong_storage_data_109;
            endcase
        end
    end
end

logic ping_storage_data_110;
logic pong_storage_data_110;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            179 / IN_WIDTH: ping_storage_data_110 <= ping_storage_data_110 ^ input_data(179 % IN_WIDTH);
            568 / IN_WIDTH: ping_storage_data_110 <= ping_storage_data_110 ^ input_data(568 % IN_WIDTH);
            607 / IN_WIDTH: ping_storage_data_110 <= ping_storage_data_110 ^ input_data(607 % IN_WIDTH);
            677 / IN_WIDTH: ping_storage_data_110 <= ping_storage_data_110 ^ input_data(677 % IN_WIDTH);
            1058 / IN_WIDTH: ping_storage_data_110 <= ping_storage_data_110 ^ input_data(1058 % IN_WIDTH);
            default: pong_storage_data_110 <= pong_storage_data_110;
            endcase
        end else begin
            case (input_count)
            179 / IN_WIDTH: pong_storage_data_110 <= pong_storage_data_110 ^ input_data(179 % IN_WIDTH);
            568 / IN_WIDTH: pong_storage_data_110 <= pong_storage_data_110 ^ input_data(568 % IN_WIDTH);
            607 / IN_WIDTH: pong_storage_data_110 <= pong_storage_data_110 ^ input_data(607 % IN_WIDTH);
            677 / IN_WIDTH: pong_storage_data_110 <= pong_storage_data_110 ^ input_data(677 % IN_WIDTH);
            1058 / IN_WIDTH: pong_storage_data_110 <= pong_storage_data_110 ^ input_data(1058 % IN_WIDTH);
            default: pong_storage_data_110 <= pong_storage_data_110;
            endcase
        end
    end
end

logic ping_storage_data_111;
logic pong_storage_data_111;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            180 / IN_WIDTH: ping_storage_data_111 <= ping_storage_data_111 ^ input_data(180 % IN_WIDTH);
            569 / IN_WIDTH: ping_storage_data_111 <= ping_storage_data_111 ^ input_data(569 % IN_WIDTH);
            608 / IN_WIDTH: ping_storage_data_111 <= ping_storage_data_111 ^ input_data(608 % IN_WIDTH);
            678 / IN_WIDTH: ping_storage_data_111 <= ping_storage_data_111 ^ input_data(678 % IN_WIDTH);
            1059 / IN_WIDTH: ping_storage_data_111 <= ping_storage_data_111 ^ input_data(1059 % IN_WIDTH);
            default: pong_storage_data_111 <= pong_storage_data_111;
            endcase
        end else begin
            case (input_count)
            180 / IN_WIDTH: pong_storage_data_111 <= pong_storage_data_111 ^ input_data(180 % IN_WIDTH);
            569 / IN_WIDTH: pong_storage_data_111 <= pong_storage_data_111 ^ input_data(569 % IN_WIDTH);
            608 / IN_WIDTH: pong_storage_data_111 <= pong_storage_data_111 ^ input_data(608 % IN_WIDTH);
            678 / IN_WIDTH: pong_storage_data_111 <= pong_storage_data_111 ^ input_data(678 % IN_WIDTH);
            1059 / IN_WIDTH: pong_storage_data_111 <= pong_storage_data_111 ^ input_data(1059 % IN_WIDTH);
            default: pong_storage_data_111 <= pong_storage_data_111;
            endcase
        end
    end
end

logic ping_storage_data_112;
logic pong_storage_data_112;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            181 / IN_WIDTH: ping_storage_data_112 <= ping_storage_data_112 ^ input_data(181 % IN_WIDTH);
            570 / IN_WIDTH: ping_storage_data_112 <= ping_storage_data_112 ^ input_data(570 % IN_WIDTH);
            609 / IN_WIDTH: ping_storage_data_112 <= ping_storage_data_112 ^ input_data(609 % IN_WIDTH);
            679 / IN_WIDTH: ping_storage_data_112 <= ping_storage_data_112 ^ input_data(679 % IN_WIDTH);
            1060 / IN_WIDTH: ping_storage_data_112 <= ping_storage_data_112 ^ input_data(1060 % IN_WIDTH);
            default: pong_storage_data_112 <= pong_storage_data_112;
            endcase
        end else begin
            case (input_count)
            181 / IN_WIDTH: pong_storage_data_112 <= pong_storage_data_112 ^ input_data(181 % IN_WIDTH);
            570 / IN_WIDTH: pong_storage_data_112 <= pong_storage_data_112 ^ input_data(570 % IN_WIDTH);
            609 / IN_WIDTH: pong_storage_data_112 <= pong_storage_data_112 ^ input_data(609 % IN_WIDTH);
            679 / IN_WIDTH: pong_storage_data_112 <= pong_storage_data_112 ^ input_data(679 % IN_WIDTH);
            1060 / IN_WIDTH: pong_storage_data_112 <= pong_storage_data_112 ^ input_data(1060 % IN_WIDTH);
            default: pong_storage_data_112 <= pong_storage_data_112;
            endcase
        end
    end
end

logic ping_storage_data_113;
logic pong_storage_data_113;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            182 / IN_WIDTH: ping_storage_data_113 <= ping_storage_data_113 ^ input_data(182 % IN_WIDTH);
            571 / IN_WIDTH: ping_storage_data_113 <= ping_storage_data_113 ^ input_data(571 % IN_WIDTH);
            610 / IN_WIDTH: ping_storage_data_113 <= ping_storage_data_113 ^ input_data(610 % IN_WIDTH);
            680 / IN_WIDTH: ping_storage_data_113 <= ping_storage_data_113 ^ input_data(680 % IN_WIDTH);
            1061 / IN_WIDTH: ping_storage_data_113 <= ping_storage_data_113 ^ input_data(1061 % IN_WIDTH);
            default: pong_storage_data_113 <= pong_storage_data_113;
            endcase
        end else begin
            case (input_count)
            182 / IN_WIDTH: pong_storage_data_113 <= pong_storage_data_113 ^ input_data(182 % IN_WIDTH);
            571 / IN_WIDTH: pong_storage_data_113 <= pong_storage_data_113 ^ input_data(571 % IN_WIDTH);
            610 / IN_WIDTH: pong_storage_data_113 <= pong_storage_data_113 ^ input_data(610 % IN_WIDTH);
            680 / IN_WIDTH: pong_storage_data_113 <= pong_storage_data_113 ^ input_data(680 % IN_WIDTH);
            1061 / IN_WIDTH: pong_storage_data_113 <= pong_storage_data_113 ^ input_data(1061 % IN_WIDTH);
            default: pong_storage_data_113 <= pong_storage_data_113;
            endcase
        end
    end
end

logic ping_storage_data_114;
logic pong_storage_data_114;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            183 / IN_WIDTH: ping_storage_data_114 <= ping_storage_data_114 ^ input_data(183 % IN_WIDTH);
            572 / IN_WIDTH: ping_storage_data_114 <= ping_storage_data_114 ^ input_data(572 % IN_WIDTH);
            611 / IN_WIDTH: ping_storage_data_114 <= ping_storage_data_114 ^ input_data(611 % IN_WIDTH);
            681 / IN_WIDTH: ping_storage_data_114 <= ping_storage_data_114 ^ input_data(681 % IN_WIDTH);
            1062 / IN_WIDTH: ping_storage_data_114 <= ping_storage_data_114 ^ input_data(1062 % IN_WIDTH);
            default: pong_storage_data_114 <= pong_storage_data_114;
            endcase
        end else begin
            case (input_count)
            183 / IN_WIDTH: pong_storage_data_114 <= pong_storage_data_114 ^ input_data(183 % IN_WIDTH);
            572 / IN_WIDTH: pong_storage_data_114 <= pong_storage_data_114 ^ input_data(572 % IN_WIDTH);
            611 / IN_WIDTH: pong_storage_data_114 <= pong_storage_data_114 ^ input_data(611 % IN_WIDTH);
            681 / IN_WIDTH: pong_storage_data_114 <= pong_storage_data_114 ^ input_data(681 % IN_WIDTH);
            1062 / IN_WIDTH: pong_storage_data_114 <= pong_storage_data_114 ^ input_data(1062 % IN_WIDTH);
            default: pong_storage_data_114 <= pong_storage_data_114;
            endcase
        end
    end
end

logic ping_storage_data_115;
logic pong_storage_data_115;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            184 / IN_WIDTH: ping_storage_data_115 <= ping_storage_data_115 ^ input_data(184 % IN_WIDTH);
            573 / IN_WIDTH: ping_storage_data_115 <= ping_storage_data_115 ^ input_data(573 % IN_WIDTH);
            612 / IN_WIDTH: ping_storage_data_115 <= ping_storage_data_115 ^ input_data(612 % IN_WIDTH);
            682 / IN_WIDTH: ping_storage_data_115 <= ping_storage_data_115 ^ input_data(682 % IN_WIDTH);
            1063 / IN_WIDTH: ping_storage_data_115 <= ping_storage_data_115 ^ input_data(1063 % IN_WIDTH);
            default: pong_storage_data_115 <= pong_storage_data_115;
            endcase
        end else begin
            case (input_count)
            184 / IN_WIDTH: pong_storage_data_115 <= pong_storage_data_115 ^ input_data(184 % IN_WIDTH);
            573 / IN_WIDTH: pong_storage_data_115 <= pong_storage_data_115 ^ input_data(573 % IN_WIDTH);
            612 / IN_WIDTH: pong_storage_data_115 <= pong_storage_data_115 ^ input_data(612 % IN_WIDTH);
            682 / IN_WIDTH: pong_storage_data_115 <= pong_storage_data_115 ^ input_data(682 % IN_WIDTH);
            1063 / IN_WIDTH: pong_storage_data_115 <= pong_storage_data_115 ^ input_data(1063 % IN_WIDTH);
            default: pong_storage_data_115 <= pong_storage_data_115;
            endcase
        end
    end
end

logic ping_storage_data_116;
logic pong_storage_data_116;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            185 / IN_WIDTH: ping_storage_data_116 <= ping_storage_data_116 ^ input_data(185 % IN_WIDTH);
            574 / IN_WIDTH: ping_storage_data_116 <= ping_storage_data_116 ^ input_data(574 % IN_WIDTH);
            613 / IN_WIDTH: ping_storage_data_116 <= ping_storage_data_116 ^ input_data(613 % IN_WIDTH);
            683 / IN_WIDTH: ping_storage_data_116 <= ping_storage_data_116 ^ input_data(683 % IN_WIDTH);
            1064 / IN_WIDTH: ping_storage_data_116 <= ping_storage_data_116 ^ input_data(1064 % IN_WIDTH);
            default: pong_storage_data_116 <= pong_storage_data_116;
            endcase
        end else begin
            case (input_count)
            185 / IN_WIDTH: pong_storage_data_116 <= pong_storage_data_116 ^ input_data(185 % IN_WIDTH);
            574 / IN_WIDTH: pong_storage_data_116 <= pong_storage_data_116 ^ input_data(574 % IN_WIDTH);
            613 / IN_WIDTH: pong_storage_data_116 <= pong_storage_data_116 ^ input_data(613 % IN_WIDTH);
            683 / IN_WIDTH: pong_storage_data_116 <= pong_storage_data_116 ^ input_data(683 % IN_WIDTH);
            1064 / IN_WIDTH: pong_storage_data_116 <= pong_storage_data_116 ^ input_data(1064 % IN_WIDTH);
            default: pong_storage_data_116 <= pong_storage_data_116;
            endcase
        end
    end
end

logic ping_storage_data_117;
logic pong_storage_data_117;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            186 / IN_WIDTH: ping_storage_data_117 <= ping_storage_data_117 ^ input_data(186 % IN_WIDTH);
            575 / IN_WIDTH: ping_storage_data_117 <= ping_storage_data_117 ^ input_data(575 % IN_WIDTH);
            614 / IN_WIDTH: ping_storage_data_117 <= ping_storage_data_117 ^ input_data(614 % IN_WIDTH);
            684 / IN_WIDTH: ping_storage_data_117 <= ping_storage_data_117 ^ input_data(684 % IN_WIDTH);
            1065 / IN_WIDTH: ping_storage_data_117 <= ping_storage_data_117 ^ input_data(1065 % IN_WIDTH);
            default: pong_storage_data_117 <= pong_storage_data_117;
            endcase
        end else begin
            case (input_count)
            186 / IN_WIDTH: pong_storage_data_117 <= pong_storage_data_117 ^ input_data(186 % IN_WIDTH);
            575 / IN_WIDTH: pong_storage_data_117 <= pong_storage_data_117 ^ input_data(575 % IN_WIDTH);
            614 / IN_WIDTH: pong_storage_data_117 <= pong_storage_data_117 ^ input_data(614 % IN_WIDTH);
            684 / IN_WIDTH: pong_storage_data_117 <= pong_storage_data_117 ^ input_data(684 % IN_WIDTH);
            1065 / IN_WIDTH: pong_storage_data_117 <= pong_storage_data_117 ^ input_data(1065 % IN_WIDTH);
            default: pong_storage_data_117 <= pong_storage_data_117;
            endcase
        end
    end
end

logic ping_storage_data_118;
logic pong_storage_data_118;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            187 / IN_WIDTH: ping_storage_data_118 <= ping_storage_data_118 ^ input_data(187 % IN_WIDTH);
            480 / IN_WIDTH: ping_storage_data_118 <= ping_storage_data_118 ^ input_data(480 % IN_WIDTH);
            615 / IN_WIDTH: ping_storage_data_118 <= ping_storage_data_118 ^ input_data(615 % IN_WIDTH);
            685 / IN_WIDTH: ping_storage_data_118 <= ping_storage_data_118 ^ input_data(685 % IN_WIDTH);
            1066 / IN_WIDTH: ping_storage_data_118 <= ping_storage_data_118 ^ input_data(1066 % IN_WIDTH);
            default: pong_storage_data_118 <= pong_storage_data_118;
            endcase
        end else begin
            case (input_count)
            187 / IN_WIDTH: pong_storage_data_118 <= pong_storage_data_118 ^ input_data(187 % IN_WIDTH);
            480 / IN_WIDTH: pong_storage_data_118 <= pong_storage_data_118 ^ input_data(480 % IN_WIDTH);
            615 / IN_WIDTH: pong_storage_data_118 <= pong_storage_data_118 ^ input_data(615 % IN_WIDTH);
            685 / IN_WIDTH: pong_storage_data_118 <= pong_storage_data_118 ^ input_data(685 % IN_WIDTH);
            1066 / IN_WIDTH: pong_storage_data_118 <= pong_storage_data_118 ^ input_data(1066 % IN_WIDTH);
            default: pong_storage_data_118 <= pong_storage_data_118;
            endcase
        end
    end
end

logic ping_storage_data_119;
logic pong_storage_data_119;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            188 / IN_WIDTH: ping_storage_data_119 <= ping_storage_data_119 ^ input_data(188 % IN_WIDTH);
            481 / IN_WIDTH: ping_storage_data_119 <= ping_storage_data_119 ^ input_data(481 % IN_WIDTH);
            616 / IN_WIDTH: ping_storage_data_119 <= ping_storage_data_119 ^ input_data(616 % IN_WIDTH);
            686 / IN_WIDTH: ping_storage_data_119 <= ping_storage_data_119 ^ input_data(686 % IN_WIDTH);
            1067 / IN_WIDTH: ping_storage_data_119 <= ping_storage_data_119 ^ input_data(1067 % IN_WIDTH);
            default: pong_storage_data_119 <= pong_storage_data_119;
            endcase
        end else begin
            case (input_count)
            188 / IN_WIDTH: pong_storage_data_119 <= pong_storage_data_119 ^ input_data(188 % IN_WIDTH);
            481 / IN_WIDTH: pong_storage_data_119 <= pong_storage_data_119 ^ input_data(481 % IN_WIDTH);
            616 / IN_WIDTH: pong_storage_data_119 <= pong_storage_data_119 ^ input_data(616 % IN_WIDTH);
            686 / IN_WIDTH: pong_storage_data_119 <= pong_storage_data_119 ^ input_data(686 % IN_WIDTH);
            1067 / IN_WIDTH: pong_storage_data_119 <= pong_storage_data_119 ^ input_data(1067 % IN_WIDTH);
            default: pong_storage_data_119 <= pong_storage_data_119;
            endcase
        end
    end
end

logic ping_storage_data_120;
logic pong_storage_data_120;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            189 / IN_WIDTH: ping_storage_data_120 <= ping_storage_data_120 ^ input_data(189 % IN_WIDTH);
            482 / IN_WIDTH: ping_storage_data_120 <= ping_storage_data_120 ^ input_data(482 % IN_WIDTH);
            617 / IN_WIDTH: ping_storage_data_120 <= ping_storage_data_120 ^ input_data(617 % IN_WIDTH);
            687 / IN_WIDTH: ping_storage_data_120 <= ping_storage_data_120 ^ input_data(687 % IN_WIDTH);
            1068 / IN_WIDTH: ping_storage_data_120 <= ping_storage_data_120 ^ input_data(1068 % IN_WIDTH);
            default: pong_storage_data_120 <= pong_storage_data_120;
            endcase
        end else begin
            case (input_count)
            189 / IN_WIDTH: pong_storage_data_120 <= pong_storage_data_120 ^ input_data(189 % IN_WIDTH);
            482 / IN_WIDTH: pong_storage_data_120 <= pong_storage_data_120 ^ input_data(482 % IN_WIDTH);
            617 / IN_WIDTH: pong_storage_data_120 <= pong_storage_data_120 ^ input_data(617 % IN_WIDTH);
            687 / IN_WIDTH: pong_storage_data_120 <= pong_storage_data_120 ^ input_data(687 % IN_WIDTH);
            1068 / IN_WIDTH: pong_storage_data_120 <= pong_storage_data_120 ^ input_data(1068 % IN_WIDTH);
            default: pong_storage_data_120 <= pong_storage_data_120;
            endcase
        end
    end
end

logic ping_storage_data_121;
logic pong_storage_data_121;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            190 / IN_WIDTH: ping_storage_data_121 <= ping_storage_data_121 ^ input_data(190 % IN_WIDTH);
            483 / IN_WIDTH: ping_storage_data_121 <= ping_storage_data_121 ^ input_data(483 % IN_WIDTH);
            618 / IN_WIDTH: ping_storage_data_121 <= ping_storage_data_121 ^ input_data(618 % IN_WIDTH);
            688 / IN_WIDTH: ping_storage_data_121 <= ping_storage_data_121 ^ input_data(688 % IN_WIDTH);
            1069 / IN_WIDTH: ping_storage_data_121 <= ping_storage_data_121 ^ input_data(1069 % IN_WIDTH);
            default: pong_storage_data_121 <= pong_storage_data_121;
            endcase
        end else begin
            case (input_count)
            190 / IN_WIDTH: pong_storage_data_121 <= pong_storage_data_121 ^ input_data(190 % IN_WIDTH);
            483 / IN_WIDTH: pong_storage_data_121 <= pong_storage_data_121 ^ input_data(483 % IN_WIDTH);
            618 / IN_WIDTH: pong_storage_data_121 <= pong_storage_data_121 ^ input_data(618 % IN_WIDTH);
            688 / IN_WIDTH: pong_storage_data_121 <= pong_storage_data_121 ^ input_data(688 % IN_WIDTH);
            1069 / IN_WIDTH: pong_storage_data_121 <= pong_storage_data_121 ^ input_data(1069 % IN_WIDTH);
            default: pong_storage_data_121 <= pong_storage_data_121;
            endcase
        end
    end
end

logic ping_storage_data_122;
logic pong_storage_data_122;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            191 / IN_WIDTH: ping_storage_data_122 <= ping_storage_data_122 ^ input_data(191 % IN_WIDTH);
            484 / IN_WIDTH: ping_storage_data_122 <= ping_storage_data_122 ^ input_data(484 % IN_WIDTH);
            619 / IN_WIDTH: ping_storage_data_122 <= ping_storage_data_122 ^ input_data(619 % IN_WIDTH);
            689 / IN_WIDTH: ping_storage_data_122 <= ping_storage_data_122 ^ input_data(689 % IN_WIDTH);
            1070 / IN_WIDTH: ping_storage_data_122 <= ping_storage_data_122 ^ input_data(1070 % IN_WIDTH);
            default: pong_storage_data_122 <= pong_storage_data_122;
            endcase
        end else begin
            case (input_count)
            191 / IN_WIDTH: pong_storage_data_122 <= pong_storage_data_122 ^ input_data(191 % IN_WIDTH);
            484 / IN_WIDTH: pong_storage_data_122 <= pong_storage_data_122 ^ input_data(484 % IN_WIDTH);
            619 / IN_WIDTH: pong_storage_data_122 <= pong_storage_data_122 ^ input_data(619 % IN_WIDTH);
            689 / IN_WIDTH: pong_storage_data_122 <= pong_storage_data_122 ^ input_data(689 % IN_WIDTH);
            1070 / IN_WIDTH: pong_storage_data_122 <= pong_storage_data_122 ^ input_data(1070 % IN_WIDTH);
            default: pong_storage_data_122 <= pong_storage_data_122;
            endcase
        end
    end
end

logic ping_storage_data_123;
logic pong_storage_data_123;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            96 / IN_WIDTH: ping_storage_data_123 <= ping_storage_data_123 ^ input_data(96 % IN_WIDTH);
            485 / IN_WIDTH: ping_storage_data_123 <= ping_storage_data_123 ^ input_data(485 % IN_WIDTH);
            620 / IN_WIDTH: ping_storage_data_123 <= ping_storage_data_123 ^ input_data(620 % IN_WIDTH);
            690 / IN_WIDTH: ping_storage_data_123 <= ping_storage_data_123 ^ input_data(690 % IN_WIDTH);
            1071 / IN_WIDTH: ping_storage_data_123 <= ping_storage_data_123 ^ input_data(1071 % IN_WIDTH);
            default: pong_storage_data_123 <= pong_storage_data_123;
            endcase
        end else begin
            case (input_count)
            96 / IN_WIDTH: pong_storage_data_123 <= pong_storage_data_123 ^ input_data(96 % IN_WIDTH);
            485 / IN_WIDTH: pong_storage_data_123 <= pong_storage_data_123 ^ input_data(485 % IN_WIDTH);
            620 / IN_WIDTH: pong_storage_data_123 <= pong_storage_data_123 ^ input_data(620 % IN_WIDTH);
            690 / IN_WIDTH: pong_storage_data_123 <= pong_storage_data_123 ^ input_data(690 % IN_WIDTH);
            1071 / IN_WIDTH: pong_storage_data_123 <= pong_storage_data_123 ^ input_data(1071 % IN_WIDTH);
            default: pong_storage_data_123 <= pong_storage_data_123;
            endcase
        end
    end
end

logic ping_storage_data_124;
logic pong_storage_data_124;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            97 / IN_WIDTH: ping_storage_data_124 <= ping_storage_data_124 ^ input_data(97 % IN_WIDTH);
            486 / IN_WIDTH: ping_storage_data_124 <= ping_storage_data_124 ^ input_data(486 % IN_WIDTH);
            621 / IN_WIDTH: ping_storage_data_124 <= ping_storage_data_124 ^ input_data(621 % IN_WIDTH);
            691 / IN_WIDTH: ping_storage_data_124 <= ping_storage_data_124 ^ input_data(691 % IN_WIDTH);
            1072 / IN_WIDTH: ping_storage_data_124 <= ping_storage_data_124 ^ input_data(1072 % IN_WIDTH);
            default: pong_storage_data_124 <= pong_storage_data_124;
            endcase
        end else begin
            case (input_count)
            97 / IN_WIDTH: pong_storage_data_124 <= pong_storage_data_124 ^ input_data(97 % IN_WIDTH);
            486 / IN_WIDTH: pong_storage_data_124 <= pong_storage_data_124 ^ input_data(486 % IN_WIDTH);
            621 / IN_WIDTH: pong_storage_data_124 <= pong_storage_data_124 ^ input_data(621 % IN_WIDTH);
            691 / IN_WIDTH: pong_storage_data_124 <= pong_storage_data_124 ^ input_data(691 % IN_WIDTH);
            1072 / IN_WIDTH: pong_storage_data_124 <= pong_storage_data_124 ^ input_data(1072 % IN_WIDTH);
            default: pong_storage_data_124 <= pong_storage_data_124;
            endcase
        end
    end
end

logic ping_storage_data_125;
logic pong_storage_data_125;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            98 / IN_WIDTH: ping_storage_data_125 <= ping_storage_data_125 ^ input_data(98 % IN_WIDTH);
            487 / IN_WIDTH: ping_storage_data_125 <= ping_storage_data_125 ^ input_data(487 % IN_WIDTH);
            622 / IN_WIDTH: ping_storage_data_125 <= ping_storage_data_125 ^ input_data(622 % IN_WIDTH);
            692 / IN_WIDTH: ping_storage_data_125 <= ping_storage_data_125 ^ input_data(692 % IN_WIDTH);
            1073 / IN_WIDTH: ping_storage_data_125 <= ping_storage_data_125 ^ input_data(1073 % IN_WIDTH);
            default: pong_storage_data_125 <= pong_storage_data_125;
            endcase
        end else begin
            case (input_count)
            98 / IN_WIDTH: pong_storage_data_125 <= pong_storage_data_125 ^ input_data(98 % IN_WIDTH);
            487 / IN_WIDTH: pong_storage_data_125 <= pong_storage_data_125 ^ input_data(487 % IN_WIDTH);
            622 / IN_WIDTH: pong_storage_data_125 <= pong_storage_data_125 ^ input_data(622 % IN_WIDTH);
            692 / IN_WIDTH: pong_storage_data_125 <= pong_storage_data_125 ^ input_data(692 % IN_WIDTH);
            1073 / IN_WIDTH: pong_storage_data_125 <= pong_storage_data_125 ^ input_data(1073 % IN_WIDTH);
            default: pong_storage_data_125 <= pong_storage_data_125;
            endcase
        end
    end
end

logic ping_storage_data_126;
logic pong_storage_data_126;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            99 / IN_WIDTH: ping_storage_data_126 <= ping_storage_data_126 ^ input_data(99 % IN_WIDTH);
            488 / IN_WIDTH: ping_storage_data_126 <= ping_storage_data_126 ^ input_data(488 % IN_WIDTH);
            623 / IN_WIDTH: ping_storage_data_126 <= ping_storage_data_126 ^ input_data(623 % IN_WIDTH);
            693 / IN_WIDTH: ping_storage_data_126 <= ping_storage_data_126 ^ input_data(693 % IN_WIDTH);
            1074 / IN_WIDTH: ping_storage_data_126 <= ping_storage_data_126 ^ input_data(1074 % IN_WIDTH);
            default: pong_storage_data_126 <= pong_storage_data_126;
            endcase
        end else begin
            case (input_count)
            99 / IN_WIDTH: pong_storage_data_126 <= pong_storage_data_126 ^ input_data(99 % IN_WIDTH);
            488 / IN_WIDTH: pong_storage_data_126 <= pong_storage_data_126 ^ input_data(488 % IN_WIDTH);
            623 / IN_WIDTH: pong_storage_data_126 <= pong_storage_data_126 ^ input_data(623 % IN_WIDTH);
            693 / IN_WIDTH: pong_storage_data_126 <= pong_storage_data_126 ^ input_data(693 % IN_WIDTH);
            1074 / IN_WIDTH: pong_storage_data_126 <= pong_storage_data_126 ^ input_data(1074 % IN_WIDTH);
            default: pong_storage_data_126 <= pong_storage_data_126;
            endcase
        end
    end
end

logic ping_storage_data_127;
logic pong_storage_data_127;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            100 / IN_WIDTH: ping_storage_data_127 <= ping_storage_data_127 ^ input_data(100 % IN_WIDTH);
            489 / IN_WIDTH: ping_storage_data_127 <= ping_storage_data_127 ^ input_data(489 % IN_WIDTH);
            624 / IN_WIDTH: ping_storage_data_127 <= ping_storage_data_127 ^ input_data(624 % IN_WIDTH);
            694 / IN_WIDTH: ping_storage_data_127 <= ping_storage_data_127 ^ input_data(694 % IN_WIDTH);
            1075 / IN_WIDTH: ping_storage_data_127 <= ping_storage_data_127 ^ input_data(1075 % IN_WIDTH);
            default: pong_storage_data_127 <= pong_storage_data_127;
            endcase
        end else begin
            case (input_count)
            100 / IN_WIDTH: pong_storage_data_127 <= pong_storage_data_127 ^ input_data(100 % IN_WIDTH);
            489 / IN_WIDTH: pong_storage_data_127 <= pong_storage_data_127 ^ input_data(489 % IN_WIDTH);
            624 / IN_WIDTH: pong_storage_data_127 <= pong_storage_data_127 ^ input_data(624 % IN_WIDTH);
            694 / IN_WIDTH: pong_storage_data_127 <= pong_storage_data_127 ^ input_data(694 % IN_WIDTH);
            1075 / IN_WIDTH: pong_storage_data_127 <= pong_storage_data_127 ^ input_data(1075 % IN_WIDTH);
            default: pong_storage_data_127 <= pong_storage_data_127;
            endcase
        end
    end
end

logic ping_storage_data_128;
logic pong_storage_data_128;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            101 / IN_WIDTH: ping_storage_data_128 <= ping_storage_data_128 ^ input_data(101 % IN_WIDTH);
            490 / IN_WIDTH: ping_storage_data_128 <= ping_storage_data_128 ^ input_data(490 % IN_WIDTH);
            625 / IN_WIDTH: ping_storage_data_128 <= ping_storage_data_128 ^ input_data(625 % IN_WIDTH);
            695 / IN_WIDTH: ping_storage_data_128 <= ping_storage_data_128 ^ input_data(695 % IN_WIDTH);
            1076 / IN_WIDTH: ping_storage_data_128 <= ping_storage_data_128 ^ input_data(1076 % IN_WIDTH);
            default: pong_storage_data_128 <= pong_storage_data_128;
            endcase
        end else begin
            case (input_count)
            101 / IN_WIDTH: pong_storage_data_128 <= pong_storage_data_128 ^ input_data(101 % IN_WIDTH);
            490 / IN_WIDTH: pong_storage_data_128 <= pong_storage_data_128 ^ input_data(490 % IN_WIDTH);
            625 / IN_WIDTH: pong_storage_data_128 <= pong_storage_data_128 ^ input_data(625 % IN_WIDTH);
            695 / IN_WIDTH: pong_storage_data_128 <= pong_storage_data_128 ^ input_data(695 % IN_WIDTH);
            1076 / IN_WIDTH: pong_storage_data_128 <= pong_storage_data_128 ^ input_data(1076 % IN_WIDTH);
            default: pong_storage_data_128 <= pong_storage_data_128;
            endcase
        end
    end
end

logic ping_storage_data_129;
logic pong_storage_data_129;

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin
            case (input_count)
            102 / IN_WIDTH: ping_storage_data_129 <= ping_storage_data_129 ^ input_data(102 % IN_WIDTH);
            491 / IN_WIDTH: ping_storage_data_129 <= ping_storage_data_129 ^ input_data(491 % IN_WIDTH);
            626 / IN_WIDTH: ping_storage_data_129 <= ping_storage_data_129 ^ input_data(626 % IN_WIDTH);
            696 / IN_WIDTH: ping_storage_data_129 <= ping_storage_data_129 ^ input_data(696 % IN_WIDTH);
            default: pong_storage_data_129 <= pong_storage_data_129;
            endcase
        end else begin
            case (input_count)
            102 / IN_WIDTH: pong_storage_data_129 <= pong_storage_data_129 ^ input_data(102 % IN_WIDTH);
            491 / IN_WIDTH: pong_storage_data_129 <= pong_storage_data_129 ^ input_data(491 % IN_WIDTH);
            626 / IN_WIDTH: pong_storage_data_129 <= pong_storage_data_129 ^ input_data(626 % IN_WIDTH);
            696 / IN_WIDTH: pong_storage_data_129 <= pong_storage_data_129 ^ input_data(696 % IN_WIDTH);
            default: pong_storage_data_129 <= pong_storage_data_129;
            endcase
        end
    end
end


endmodule: sparse_mult

`default_nettype wire
