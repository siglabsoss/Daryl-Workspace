// Generated from template on 01/12/2017.
//
// Edited: 01/12/2017 by Daryl
//         * Removed output_count (and all dependencies)
`timescale 1ps / 1ps

`default_nettype none

module ldpc_sparse_mult_by_C #(
    parameter integer IN_WIDTH = 8,  // SHOULD BE A POWER OF 2
    parameter integer OUT_WIDTH = 96  // SHOULD BE A POWER OF 2
) (
    input  wire logic [IN_WIDTH-1:0]    i_input_data,
    input  wire logic                   i_input_valid,
    output      logic                   o_input_ready,
    output      logic [OUT_WIDTH-1:0]   o_output_data,
    output      logic                   o_output_valid,
    input  wire logic                   i_output_ready,
    input  wire logic                   i_clock,
    input  wire logic                   i_reset
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
logic       last_cycle_out;
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
        o_output_data = {
            ping_storage_data_95,
            ping_storage_data_94,
            ping_storage_data_93,
            ping_storage_data_92,
            ping_storage_data_91,
            ping_storage_data_90,
            ping_storage_data_89,
            ping_storage_data_88,
            ping_storage_data_87,
            ping_storage_data_86,
            ping_storage_data_85,
            ping_storage_data_84,
            ping_storage_data_83,
            ping_storage_data_82,
            ping_storage_data_81,
            ping_storage_data_80,
            ping_storage_data_79,
            ping_storage_data_78,
            ping_storage_data_77,
            ping_storage_data_76,
            ping_storage_data_75,
            ping_storage_data_74,
            ping_storage_data_73,
            ping_storage_data_72,
            ping_storage_data_71,
            ping_storage_data_70,
            ping_storage_data_69,
            ping_storage_data_68,
            ping_storage_data_67,
            ping_storage_data_66,
            ping_storage_data_65,
            ping_storage_data_64,
            ping_storage_data_63,
            ping_storage_data_62,
            ping_storage_data_61,
            ping_storage_data_60,
            ping_storage_data_59,
            ping_storage_data_58,
            ping_storage_data_57,
            ping_storage_data_56,
            ping_storage_data_55,
            ping_storage_data_54,
            ping_storage_data_53,
            ping_storage_data_52,
            ping_storage_data_51,
            ping_storage_data_50,
            ping_storage_data_49,
            ping_storage_data_48,
            ping_storage_data_47,
            ping_storage_data_46,
            ping_storage_data_45,
            ping_storage_data_44,
            ping_storage_data_43,
            ping_storage_data_42,
            ping_storage_data_41,
            ping_storage_data_40,
            ping_storage_data_39,
            ping_storage_data_38,
            ping_storage_data_37,
            ping_storage_data_36,
            ping_storage_data_35,
            ping_storage_data_34,
            ping_storage_data_33,
            ping_storage_data_32,
            ping_storage_data_31,
            ping_storage_data_30,
            ping_storage_data_29,
            ping_storage_data_28,
            ping_storage_data_27,
            ping_storage_data_26,
            ping_storage_data_25,
            ping_storage_data_24,
            ping_storage_data_23,
            ping_storage_data_22,
            ping_storage_data_21,
            ping_storage_data_20,
            ping_storage_data_19,
            ping_storage_data_18,
            ping_storage_data_17,
            ping_storage_data_16,
            ping_storage_data_15,
            ping_storage_data_14,
            ping_storage_data_13,
            ping_storage_data_12,
            ping_storage_data_11,
            ping_storage_data_10,
            ping_storage_data_9,
            ping_storage_data_8,
            ping_storage_data_7,
            ping_storage_data_6,
            ping_storage_data_5,
            ping_storage_data_4,
            ping_storage_data_3,
            ping_storage_data_2,
            ping_storage_data_1,
            ping_storage_data_0
        };
        o_output_valid = 1'b1;
    end
    ST_PONG: begin
        if (i_output_ready == 1'b1) begin
            next_readout_state = ping_is_full ? ST_PING : ST_WAIT_FOR_PING;
        end else begin
            next_readout_state = ST_PONG;
        end
        o_output_data = {
            pong_storage_data_95,
            pong_storage_data_94,
            pong_storage_data_93,
            pong_storage_data_92,
            pong_storage_data_91,
            pong_storage_data_90,
            pong_storage_data_89,
            pong_storage_data_88,
            pong_storage_data_87,
            pong_storage_data_86,
            pong_storage_data_85,
            pong_storage_data_84,
            pong_storage_data_83,
            pong_storage_data_82,
            pong_storage_data_81,
            pong_storage_data_80,
            pong_storage_data_79,
            pong_storage_data_78,
            pong_storage_data_77,
            pong_storage_data_76,
            pong_storage_data_75,
            pong_storage_data_74,
            pong_storage_data_73,
            pong_storage_data_72,
            pong_storage_data_71,
            pong_storage_data_70,
            pong_storage_data_69,
            pong_storage_data_68,
            pong_storage_data_67,
            pong_storage_data_66,
            pong_storage_data_65,
            pong_storage_data_64,
            pong_storage_data_63,
            pong_storage_data_62,
            pong_storage_data_61,
            pong_storage_data_60,
            pong_storage_data_59,
            pong_storage_data_58,
            pong_storage_data_57,
            pong_storage_data_56,
            pong_storage_data_55,
            pong_storage_data_54,
            pong_storage_data_53,
            pong_storage_data_52,
            pong_storage_data_51,
            pong_storage_data_50,
            pong_storage_data_49,
            pong_storage_data_48,
            pong_storage_data_47,
            pong_storage_data_46,
            pong_storage_data_45,
            pong_storage_data_44,
            pong_storage_data_43,
            pong_storage_data_42,
            pong_storage_data_41,
            pong_storage_data_40,
            pong_storage_data_39,
            pong_storage_data_38,
            pong_storage_data_37,
            pong_storage_data_36,
            pong_storage_data_35,
            pong_storage_data_34,
            pong_storage_data_33,
            pong_storage_data_32,
            pong_storage_data_31,
            pong_storage_data_30,
            pong_storage_data_29,
            pong_storage_data_28,
            pong_storage_data_27,
            pong_storage_data_26,
            pong_storage_data_25,
            pong_storage_data_24,
            pong_storage_data_23,
            pong_storage_data_22,
            pong_storage_data_21,
            pong_storage_data_20,
            pong_storage_data_19,
            pong_storage_data_18,
            pong_storage_data_17,
            pong_storage_data_16,
            pong_storage_data_15,
            pong_storage_data_14,
            pong_storage_data_13,
            pong_storage_data_12,
            pong_storage_data_11,
            pong_storage_data_10,
            pong_storage_data_9,
            pong_storage_data_8,
            pong_storage_data_7,
            pong_storage_data_6,
            pong_storage_data_5,
            pong_storage_data_4,
            pong_storage_data_3,
            pong_storage_data_2,
            pong_storage_data_1,
            pong_storage_data_0
        };
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

logic ping_storage_data_0;
logic pong_storage_data_0;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_0 <= 1'b0;
        pong_storage_data_0 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                53 / IN_WIDTH: ping_storage_data_0 <= i_input_data[53 % IN_WIDTH];
                510 / IN_WIDTH: ping_storage_data_0 <= ping_storage_data_0 ^ i_input_data[510 % IN_WIDTH];
                727 / IN_WIDTH: ping_storage_data_0 <= ping_storage_data_0 ^ i_input_data[727 % IN_WIDTH];
                1126 / IN_WIDTH: ping_storage_data_0 <= ping_storage_data_0 ^ i_input_data[1126 % IN_WIDTH];
                default: ping_storage_data_0 <= ping_storage_data_0;
                endcase
            end else begin
                ping_storage_data_0 <= ping_storage_data_0;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                53 / IN_WIDTH: pong_storage_data_0 <= i_input_data[53 % IN_WIDTH];
                510 / IN_WIDTH: pong_storage_data_0 <= pong_storage_data_0 ^ i_input_data[510 % IN_WIDTH];
                727 / IN_WIDTH: pong_storage_data_0 <= pong_storage_data_0 ^ i_input_data[727 % IN_WIDTH];
                1126 / IN_WIDTH: pong_storage_data_0 <= pong_storage_data_0 ^ i_input_data[1126 % IN_WIDTH];
                default: pong_storage_data_0 <= pong_storage_data_0;
                endcase
            end
        end
    end
end

logic ping_storage_data_1;
logic pong_storage_data_1;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_1 <= 1'b0;
        pong_storage_data_1 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                54 / IN_WIDTH: ping_storage_data_1 <= i_input_data[54 % IN_WIDTH];
                511 / IN_WIDTH: ping_storage_data_1 <= ping_storage_data_1 ^ i_input_data[511 % IN_WIDTH];
                728 / IN_WIDTH: ping_storage_data_1 <= ping_storage_data_1 ^ i_input_data[728 % IN_WIDTH];
                1127 / IN_WIDTH: ping_storage_data_1 <= ping_storage_data_1 ^ i_input_data[1127 % IN_WIDTH];
                default: ping_storage_data_1 <= ping_storage_data_1;
                endcase
            end else begin
                ping_storage_data_1 <= ping_storage_data_1;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                54 / IN_WIDTH: pong_storage_data_1 <= i_input_data[54 % IN_WIDTH];
                511 / IN_WIDTH: pong_storage_data_1 <= pong_storage_data_1 ^ i_input_data[511 % IN_WIDTH];
                728 / IN_WIDTH: pong_storage_data_1 <= pong_storage_data_1 ^ i_input_data[728 % IN_WIDTH];
                1127 / IN_WIDTH: pong_storage_data_1 <= pong_storage_data_1 ^ i_input_data[1127 % IN_WIDTH];
                default: pong_storage_data_1 <= pong_storage_data_1;
                endcase
            end
        end
    end
end

logic ping_storage_data_2;
logic pong_storage_data_2;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_2 <= 1'b0;
        pong_storage_data_2 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                55 / IN_WIDTH: ping_storage_data_2 <= i_input_data[55 % IN_WIDTH];
                512 / IN_WIDTH: ping_storage_data_2 <= ping_storage_data_2 ^ i_input_data[512 % IN_WIDTH];
                729 / IN_WIDTH: ping_storage_data_2 <= ping_storage_data_2 ^ i_input_data[729 % IN_WIDTH];
                1128 / IN_WIDTH: ping_storage_data_2 <= ping_storage_data_2 ^ i_input_data[1128 % IN_WIDTH];
                default: ping_storage_data_2 <= ping_storage_data_2;
                endcase
            end else begin
                ping_storage_data_2 <= ping_storage_data_2;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                55 / IN_WIDTH: pong_storage_data_2 <= i_input_data[55 % IN_WIDTH];
                512 / IN_WIDTH: pong_storage_data_2 <= pong_storage_data_2 ^ i_input_data[512 % IN_WIDTH];
                729 / IN_WIDTH: pong_storage_data_2 <= pong_storage_data_2 ^ i_input_data[729 % IN_WIDTH];
                1128 / IN_WIDTH: pong_storage_data_2 <= pong_storage_data_2 ^ i_input_data[1128 % IN_WIDTH];
                default: pong_storage_data_2 <= pong_storage_data_2;
                endcase
            end
        end
    end
end

logic ping_storage_data_3;
logic pong_storage_data_3;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_3 <= 1'b0;
        pong_storage_data_3 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                56 / IN_WIDTH: ping_storage_data_3 <= i_input_data[56 % IN_WIDTH];
                513 / IN_WIDTH: ping_storage_data_3 <= ping_storage_data_3 ^ i_input_data[513 % IN_WIDTH];
                730 / IN_WIDTH: ping_storage_data_3 <= ping_storage_data_3 ^ i_input_data[730 % IN_WIDTH];
                1129 / IN_WIDTH: ping_storage_data_3 <= ping_storage_data_3 ^ i_input_data[1129 % IN_WIDTH];
                default: ping_storage_data_3 <= ping_storage_data_3;
                endcase
            end else begin
                ping_storage_data_3 <= ping_storage_data_3;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                56 / IN_WIDTH: pong_storage_data_3 <= i_input_data[56 % IN_WIDTH];
                513 / IN_WIDTH: pong_storage_data_3 <= pong_storage_data_3 ^ i_input_data[513 % IN_WIDTH];
                730 / IN_WIDTH: pong_storage_data_3 <= pong_storage_data_3 ^ i_input_data[730 % IN_WIDTH];
                1129 / IN_WIDTH: pong_storage_data_3 <= pong_storage_data_3 ^ i_input_data[1129 % IN_WIDTH];
                default: pong_storage_data_3 <= pong_storage_data_3;
                endcase
            end
        end
    end
end

logic ping_storage_data_4;
logic pong_storage_data_4;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_4 <= 1'b0;
        pong_storage_data_4 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                57 / IN_WIDTH: ping_storage_data_4 <= i_input_data[57 % IN_WIDTH];
                514 / IN_WIDTH: ping_storage_data_4 <= ping_storage_data_4 ^ i_input_data[514 % IN_WIDTH];
                731 / IN_WIDTH: ping_storage_data_4 <= ping_storage_data_4 ^ i_input_data[731 % IN_WIDTH];
                1130 / IN_WIDTH: ping_storage_data_4 <= ping_storage_data_4 ^ i_input_data[1130 % IN_WIDTH];
                default: ping_storage_data_4 <= ping_storage_data_4;
                endcase
            end else begin
                ping_storage_data_4 <= ping_storage_data_4;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                57 / IN_WIDTH: pong_storage_data_4 <= i_input_data[57 % IN_WIDTH];
                514 / IN_WIDTH: pong_storage_data_4 <= pong_storage_data_4 ^ i_input_data[514 % IN_WIDTH];
                731 / IN_WIDTH: pong_storage_data_4 <= pong_storage_data_4 ^ i_input_data[731 % IN_WIDTH];
                1130 / IN_WIDTH: pong_storage_data_4 <= pong_storage_data_4 ^ i_input_data[1130 % IN_WIDTH];
                default: pong_storage_data_4 <= pong_storage_data_4;
                endcase
            end
        end
    end
end

logic ping_storage_data_5;
logic pong_storage_data_5;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_5 <= 1'b0;
        pong_storage_data_5 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                58 / IN_WIDTH: ping_storage_data_5 <= i_input_data[58 % IN_WIDTH];
                515 / IN_WIDTH: ping_storage_data_5 <= ping_storage_data_5 ^ i_input_data[515 % IN_WIDTH];
                732 / IN_WIDTH: ping_storage_data_5 <= ping_storage_data_5 ^ i_input_data[732 % IN_WIDTH];
                1131 / IN_WIDTH: ping_storage_data_5 <= ping_storage_data_5 ^ i_input_data[1131 % IN_WIDTH];
                default: ping_storage_data_5 <= ping_storage_data_5;
                endcase
            end else begin
                ping_storage_data_5 <= ping_storage_data_5;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                58 / IN_WIDTH: pong_storage_data_5 <= i_input_data[58 % IN_WIDTH];
                515 / IN_WIDTH: pong_storage_data_5 <= pong_storage_data_5 ^ i_input_data[515 % IN_WIDTH];
                732 / IN_WIDTH: pong_storage_data_5 <= pong_storage_data_5 ^ i_input_data[732 % IN_WIDTH];
                1131 / IN_WIDTH: pong_storage_data_5 <= pong_storage_data_5 ^ i_input_data[1131 % IN_WIDTH];
                default: pong_storage_data_5 <= pong_storage_data_5;
                endcase
            end
        end
    end
end

logic ping_storage_data_6;
logic pong_storage_data_6;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_6 <= 1'b0;
        pong_storage_data_6 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                59 / IN_WIDTH: ping_storage_data_6 <= i_input_data[59 % IN_WIDTH];
                516 / IN_WIDTH: ping_storage_data_6 <= ping_storage_data_6 ^ i_input_data[516 % IN_WIDTH];
                733 / IN_WIDTH: ping_storage_data_6 <= ping_storage_data_6 ^ i_input_data[733 % IN_WIDTH];
                1132 / IN_WIDTH: ping_storage_data_6 <= ping_storage_data_6 ^ i_input_data[1132 % IN_WIDTH];
                default: ping_storage_data_6 <= ping_storage_data_6;
                endcase
            end else begin
                ping_storage_data_6 <= ping_storage_data_6;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                59 / IN_WIDTH: pong_storage_data_6 <= i_input_data[59 % IN_WIDTH];
                516 / IN_WIDTH: pong_storage_data_6 <= pong_storage_data_6 ^ i_input_data[516 % IN_WIDTH];
                733 / IN_WIDTH: pong_storage_data_6 <= pong_storage_data_6 ^ i_input_data[733 % IN_WIDTH];
                1132 / IN_WIDTH: pong_storage_data_6 <= pong_storage_data_6 ^ i_input_data[1132 % IN_WIDTH];
                default: pong_storage_data_6 <= pong_storage_data_6;
                endcase
            end
        end
    end
end

logic ping_storage_data_7;
logic pong_storage_data_7;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_7 <= 1'b0;
        pong_storage_data_7 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                60 / IN_WIDTH: ping_storage_data_7 <= i_input_data[60 % IN_WIDTH];
                517 / IN_WIDTH: ping_storage_data_7 <= ping_storage_data_7 ^ i_input_data[517 % IN_WIDTH];
                734 / IN_WIDTH: ping_storage_data_7 <= ping_storage_data_7 ^ i_input_data[734 % IN_WIDTH];
                1133 / IN_WIDTH: ping_storage_data_7 <= ping_storage_data_7 ^ i_input_data[1133 % IN_WIDTH];
                default: ping_storage_data_7 <= ping_storage_data_7;
                endcase
            end else begin
                ping_storage_data_7 <= ping_storage_data_7;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                60 / IN_WIDTH: pong_storage_data_7 <= i_input_data[60 % IN_WIDTH];
                517 / IN_WIDTH: pong_storage_data_7 <= pong_storage_data_7 ^ i_input_data[517 % IN_WIDTH];
                734 / IN_WIDTH: pong_storage_data_7 <= pong_storage_data_7 ^ i_input_data[734 % IN_WIDTH];
                1133 / IN_WIDTH: pong_storage_data_7 <= pong_storage_data_7 ^ i_input_data[1133 % IN_WIDTH];
                default: pong_storage_data_7 <= pong_storage_data_7;
                endcase
            end
        end
    end
end

logic ping_storage_data_8;
logic pong_storage_data_8;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_8 <= 1'b0;
        pong_storage_data_8 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                61 / IN_WIDTH: ping_storage_data_8 <= i_input_data[61 % IN_WIDTH];
                518 / IN_WIDTH: ping_storage_data_8 <= ping_storage_data_8 ^ i_input_data[518 % IN_WIDTH];
                735 / IN_WIDTH: ping_storage_data_8 <= ping_storage_data_8 ^ i_input_data[735 % IN_WIDTH];
                1134 / IN_WIDTH: ping_storage_data_8 <= ping_storage_data_8 ^ i_input_data[1134 % IN_WIDTH];
                default: ping_storage_data_8 <= ping_storage_data_8;
                endcase
            end else begin
                ping_storage_data_8 <= ping_storage_data_8;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                61 / IN_WIDTH: pong_storage_data_8 <= i_input_data[61 % IN_WIDTH];
                518 / IN_WIDTH: pong_storage_data_8 <= pong_storage_data_8 ^ i_input_data[518 % IN_WIDTH];
                735 / IN_WIDTH: pong_storage_data_8 <= pong_storage_data_8 ^ i_input_data[735 % IN_WIDTH];
                1134 / IN_WIDTH: pong_storage_data_8 <= pong_storage_data_8 ^ i_input_data[1134 % IN_WIDTH];
                default: pong_storage_data_8 <= pong_storage_data_8;
                endcase
            end
        end
    end
end

logic ping_storage_data_9;
logic pong_storage_data_9;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_9 <= 1'b0;
        pong_storage_data_9 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                62 / IN_WIDTH: ping_storage_data_9 <= i_input_data[62 % IN_WIDTH];
                519 / IN_WIDTH: ping_storage_data_9 <= ping_storage_data_9 ^ i_input_data[519 % IN_WIDTH];
                736 / IN_WIDTH: ping_storage_data_9 <= ping_storage_data_9 ^ i_input_data[736 % IN_WIDTH];
                1135 / IN_WIDTH: ping_storage_data_9 <= ping_storage_data_9 ^ i_input_data[1135 % IN_WIDTH];
                default: ping_storage_data_9 <= ping_storage_data_9;
                endcase
            end else begin
                ping_storage_data_9 <= ping_storage_data_9;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                62 / IN_WIDTH: pong_storage_data_9 <= i_input_data[62 % IN_WIDTH];
                519 / IN_WIDTH: pong_storage_data_9 <= pong_storage_data_9 ^ i_input_data[519 % IN_WIDTH];
                736 / IN_WIDTH: pong_storage_data_9 <= pong_storage_data_9 ^ i_input_data[736 % IN_WIDTH];
                1135 / IN_WIDTH: pong_storage_data_9 <= pong_storage_data_9 ^ i_input_data[1135 % IN_WIDTH];
                default: pong_storage_data_9 <= pong_storage_data_9;
                endcase
            end
        end
    end
end

logic ping_storage_data_10;
logic pong_storage_data_10;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_10 <= 1'b0;
        pong_storage_data_10 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                63 / IN_WIDTH: ping_storage_data_10 <= i_input_data[63 % IN_WIDTH];
                520 / IN_WIDTH: ping_storage_data_10 <= ping_storage_data_10 ^ i_input_data[520 % IN_WIDTH];
                737 / IN_WIDTH: ping_storage_data_10 <= ping_storage_data_10 ^ i_input_data[737 % IN_WIDTH];
                1136 / IN_WIDTH: ping_storage_data_10 <= ping_storage_data_10 ^ i_input_data[1136 % IN_WIDTH];
                default: ping_storage_data_10 <= ping_storage_data_10;
                endcase
            end else begin
                ping_storage_data_10 <= ping_storage_data_10;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                63 / IN_WIDTH: pong_storage_data_10 <= i_input_data[63 % IN_WIDTH];
                520 / IN_WIDTH: pong_storage_data_10 <= pong_storage_data_10 ^ i_input_data[520 % IN_WIDTH];
                737 / IN_WIDTH: pong_storage_data_10 <= pong_storage_data_10 ^ i_input_data[737 % IN_WIDTH];
                1136 / IN_WIDTH: pong_storage_data_10 <= pong_storage_data_10 ^ i_input_data[1136 % IN_WIDTH];
                default: pong_storage_data_10 <= pong_storage_data_10;
                endcase
            end
        end
    end
end

logic ping_storage_data_11;
logic pong_storage_data_11;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_11 <= 1'b0;
        pong_storage_data_11 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                64 / IN_WIDTH: ping_storage_data_11 <= i_input_data[64 % IN_WIDTH];
                521 / IN_WIDTH: ping_storage_data_11 <= ping_storage_data_11 ^ i_input_data[521 % IN_WIDTH];
                738 / IN_WIDTH: ping_storage_data_11 <= ping_storage_data_11 ^ i_input_data[738 % IN_WIDTH];
                1137 / IN_WIDTH: ping_storage_data_11 <= ping_storage_data_11 ^ i_input_data[1137 % IN_WIDTH];
                default: ping_storage_data_11 <= ping_storage_data_11;
                endcase
            end else begin
                ping_storage_data_11 <= ping_storage_data_11;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                64 / IN_WIDTH: pong_storage_data_11 <= i_input_data[64 % IN_WIDTH];
                521 / IN_WIDTH: pong_storage_data_11 <= pong_storage_data_11 ^ i_input_data[521 % IN_WIDTH];
                738 / IN_WIDTH: pong_storage_data_11 <= pong_storage_data_11 ^ i_input_data[738 % IN_WIDTH];
                1137 / IN_WIDTH: pong_storage_data_11 <= pong_storage_data_11 ^ i_input_data[1137 % IN_WIDTH];
                default: pong_storage_data_11 <= pong_storage_data_11;
                endcase
            end
        end
    end
end

logic ping_storage_data_12;
logic pong_storage_data_12;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_12 <= 1'b0;
        pong_storage_data_12 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                65 / IN_WIDTH: ping_storage_data_12 <= i_input_data[65 % IN_WIDTH];
                522 / IN_WIDTH: ping_storage_data_12 <= ping_storage_data_12 ^ i_input_data[522 % IN_WIDTH];
                739 / IN_WIDTH: ping_storage_data_12 <= ping_storage_data_12 ^ i_input_data[739 % IN_WIDTH];
                1138 / IN_WIDTH: ping_storage_data_12 <= ping_storage_data_12 ^ i_input_data[1138 % IN_WIDTH];
                default: ping_storage_data_12 <= ping_storage_data_12;
                endcase
            end else begin
                ping_storage_data_12 <= ping_storage_data_12;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                65 / IN_WIDTH: pong_storage_data_12 <= i_input_data[65 % IN_WIDTH];
                522 / IN_WIDTH: pong_storage_data_12 <= pong_storage_data_12 ^ i_input_data[522 % IN_WIDTH];
                739 / IN_WIDTH: pong_storage_data_12 <= pong_storage_data_12 ^ i_input_data[739 % IN_WIDTH];
                1138 / IN_WIDTH: pong_storage_data_12 <= pong_storage_data_12 ^ i_input_data[1138 % IN_WIDTH];
                default: pong_storage_data_12 <= pong_storage_data_12;
                endcase
            end
        end
    end
end

logic ping_storage_data_13;
logic pong_storage_data_13;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_13 <= 1'b0;
        pong_storage_data_13 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                66 / IN_WIDTH: ping_storage_data_13 <= i_input_data[66 % IN_WIDTH];
                523 / IN_WIDTH: ping_storage_data_13 <= ping_storage_data_13 ^ i_input_data[523 % IN_WIDTH];
                740 / IN_WIDTH: ping_storage_data_13 <= ping_storage_data_13 ^ i_input_data[740 % IN_WIDTH];
                1139 / IN_WIDTH: ping_storage_data_13 <= ping_storage_data_13 ^ i_input_data[1139 % IN_WIDTH];
                default: ping_storage_data_13 <= ping_storage_data_13;
                endcase
            end else begin
                ping_storage_data_13 <= ping_storage_data_13;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                66 / IN_WIDTH: pong_storage_data_13 <= i_input_data[66 % IN_WIDTH];
                523 / IN_WIDTH: pong_storage_data_13 <= pong_storage_data_13 ^ i_input_data[523 % IN_WIDTH];
                740 / IN_WIDTH: pong_storage_data_13 <= pong_storage_data_13 ^ i_input_data[740 % IN_WIDTH];
                1139 / IN_WIDTH: pong_storage_data_13 <= pong_storage_data_13 ^ i_input_data[1139 % IN_WIDTH];
                default: pong_storage_data_13 <= pong_storage_data_13;
                endcase
            end
        end
    end
end

logic ping_storage_data_14;
logic pong_storage_data_14;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_14 <= 1'b0;
        pong_storage_data_14 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                67 / IN_WIDTH: ping_storage_data_14 <= i_input_data[67 % IN_WIDTH];
                524 / IN_WIDTH: ping_storage_data_14 <= ping_storage_data_14 ^ i_input_data[524 % IN_WIDTH];
                741 / IN_WIDTH: ping_storage_data_14 <= ping_storage_data_14 ^ i_input_data[741 % IN_WIDTH];
                1140 / IN_WIDTH: ping_storage_data_14 <= ping_storage_data_14 ^ i_input_data[1140 % IN_WIDTH];
                default: ping_storage_data_14 <= ping_storage_data_14;
                endcase
            end else begin
                ping_storage_data_14 <= ping_storage_data_14;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                67 / IN_WIDTH: pong_storage_data_14 <= i_input_data[67 % IN_WIDTH];
                524 / IN_WIDTH: pong_storage_data_14 <= pong_storage_data_14 ^ i_input_data[524 % IN_WIDTH];
                741 / IN_WIDTH: pong_storage_data_14 <= pong_storage_data_14 ^ i_input_data[741 % IN_WIDTH];
                1140 / IN_WIDTH: pong_storage_data_14 <= pong_storage_data_14 ^ i_input_data[1140 % IN_WIDTH];
                default: pong_storage_data_14 <= pong_storage_data_14;
                endcase
            end
        end
    end
end

logic ping_storage_data_15;
logic pong_storage_data_15;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_15 <= 1'b0;
        pong_storage_data_15 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                68 / IN_WIDTH: ping_storage_data_15 <= i_input_data[68 % IN_WIDTH];
                525 / IN_WIDTH: ping_storage_data_15 <= ping_storage_data_15 ^ i_input_data[525 % IN_WIDTH];
                742 / IN_WIDTH: ping_storage_data_15 <= ping_storage_data_15 ^ i_input_data[742 % IN_WIDTH];
                1141 / IN_WIDTH: ping_storage_data_15 <= ping_storage_data_15 ^ i_input_data[1141 % IN_WIDTH];
                default: ping_storage_data_15 <= ping_storage_data_15;
                endcase
            end else begin
                ping_storage_data_15 <= ping_storage_data_15;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                68 / IN_WIDTH: pong_storage_data_15 <= i_input_data[68 % IN_WIDTH];
                525 / IN_WIDTH: pong_storage_data_15 <= pong_storage_data_15 ^ i_input_data[525 % IN_WIDTH];
                742 / IN_WIDTH: pong_storage_data_15 <= pong_storage_data_15 ^ i_input_data[742 % IN_WIDTH];
                1141 / IN_WIDTH: pong_storage_data_15 <= pong_storage_data_15 ^ i_input_data[1141 % IN_WIDTH];
                default: pong_storage_data_15 <= pong_storage_data_15;
                endcase
            end
        end
    end
end

logic ping_storage_data_16;
logic pong_storage_data_16;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_16 <= 1'b0;
        pong_storage_data_16 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                69 / IN_WIDTH: ping_storage_data_16 <= i_input_data[69 % IN_WIDTH];
                526 / IN_WIDTH: ping_storage_data_16 <= ping_storage_data_16 ^ i_input_data[526 % IN_WIDTH];
                743 / IN_WIDTH: ping_storage_data_16 <= ping_storage_data_16 ^ i_input_data[743 % IN_WIDTH];
                1142 / IN_WIDTH: ping_storage_data_16 <= ping_storage_data_16 ^ i_input_data[1142 % IN_WIDTH];
                default: ping_storage_data_16 <= ping_storage_data_16;
                endcase
            end else begin
                ping_storage_data_16 <= ping_storage_data_16;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                69 / IN_WIDTH: pong_storage_data_16 <= i_input_data[69 % IN_WIDTH];
                526 / IN_WIDTH: pong_storage_data_16 <= pong_storage_data_16 ^ i_input_data[526 % IN_WIDTH];
                743 / IN_WIDTH: pong_storage_data_16 <= pong_storage_data_16 ^ i_input_data[743 % IN_WIDTH];
                1142 / IN_WIDTH: pong_storage_data_16 <= pong_storage_data_16 ^ i_input_data[1142 % IN_WIDTH];
                default: pong_storage_data_16 <= pong_storage_data_16;
                endcase
            end
        end
    end
end

logic ping_storage_data_17;
logic pong_storage_data_17;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_17 <= 1'b0;
        pong_storage_data_17 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                70 / IN_WIDTH: ping_storage_data_17 <= i_input_data[70 % IN_WIDTH];
                527 / IN_WIDTH: ping_storage_data_17 <= ping_storage_data_17 ^ i_input_data[527 % IN_WIDTH];
                744 / IN_WIDTH: ping_storage_data_17 <= ping_storage_data_17 ^ i_input_data[744 % IN_WIDTH];
                1143 / IN_WIDTH: ping_storage_data_17 <= ping_storage_data_17 ^ i_input_data[1143 % IN_WIDTH];
                default: ping_storage_data_17 <= ping_storage_data_17;
                endcase
            end else begin
                ping_storage_data_17 <= ping_storage_data_17;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                70 / IN_WIDTH: pong_storage_data_17 <= i_input_data[70 % IN_WIDTH];
                527 / IN_WIDTH: pong_storage_data_17 <= pong_storage_data_17 ^ i_input_data[527 % IN_WIDTH];
                744 / IN_WIDTH: pong_storage_data_17 <= pong_storage_data_17 ^ i_input_data[744 % IN_WIDTH];
                1143 / IN_WIDTH: pong_storage_data_17 <= pong_storage_data_17 ^ i_input_data[1143 % IN_WIDTH];
                default: pong_storage_data_17 <= pong_storage_data_17;
                endcase
            end
        end
    end
end

logic ping_storage_data_18;
logic pong_storage_data_18;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_18 <= 1'b0;
        pong_storage_data_18 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                71 / IN_WIDTH: ping_storage_data_18 <= i_input_data[71 % IN_WIDTH];
                528 / IN_WIDTH: ping_storage_data_18 <= ping_storage_data_18 ^ i_input_data[528 % IN_WIDTH];
                745 / IN_WIDTH: ping_storage_data_18 <= ping_storage_data_18 ^ i_input_data[745 % IN_WIDTH];
                1144 / IN_WIDTH: ping_storage_data_18 <= ping_storage_data_18 ^ i_input_data[1144 % IN_WIDTH];
                default: ping_storage_data_18 <= ping_storage_data_18;
                endcase
            end else begin
                ping_storage_data_18 <= ping_storage_data_18;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                71 / IN_WIDTH: pong_storage_data_18 <= i_input_data[71 % IN_WIDTH];
                528 / IN_WIDTH: pong_storage_data_18 <= pong_storage_data_18 ^ i_input_data[528 % IN_WIDTH];
                745 / IN_WIDTH: pong_storage_data_18 <= pong_storage_data_18 ^ i_input_data[745 % IN_WIDTH];
                1144 / IN_WIDTH: pong_storage_data_18 <= pong_storage_data_18 ^ i_input_data[1144 % IN_WIDTH];
                default: pong_storage_data_18 <= pong_storage_data_18;
                endcase
            end
        end
    end
end

logic ping_storage_data_19;
logic pong_storage_data_19;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_19 <= 1'b0;
        pong_storage_data_19 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                72 / IN_WIDTH: ping_storage_data_19 <= i_input_data[72 % IN_WIDTH];
                529 / IN_WIDTH: ping_storage_data_19 <= ping_storage_data_19 ^ i_input_data[529 % IN_WIDTH];
                746 / IN_WIDTH: ping_storage_data_19 <= ping_storage_data_19 ^ i_input_data[746 % IN_WIDTH];
                1145 / IN_WIDTH: ping_storage_data_19 <= ping_storage_data_19 ^ i_input_data[1145 % IN_WIDTH];
                default: ping_storage_data_19 <= ping_storage_data_19;
                endcase
            end else begin
                ping_storage_data_19 <= ping_storage_data_19;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                72 / IN_WIDTH: pong_storage_data_19 <= i_input_data[72 % IN_WIDTH];
                529 / IN_WIDTH: pong_storage_data_19 <= pong_storage_data_19 ^ i_input_data[529 % IN_WIDTH];
                746 / IN_WIDTH: pong_storage_data_19 <= pong_storage_data_19 ^ i_input_data[746 % IN_WIDTH];
                1145 / IN_WIDTH: pong_storage_data_19 <= pong_storage_data_19 ^ i_input_data[1145 % IN_WIDTH];
                default: pong_storage_data_19 <= pong_storage_data_19;
                endcase
            end
        end
    end
end

logic ping_storage_data_20;
logic pong_storage_data_20;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_20 <= 1'b0;
        pong_storage_data_20 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                73 / IN_WIDTH: ping_storage_data_20 <= i_input_data[73 % IN_WIDTH];
                530 / IN_WIDTH: ping_storage_data_20 <= ping_storage_data_20 ^ i_input_data[530 % IN_WIDTH];
                747 / IN_WIDTH: ping_storage_data_20 <= ping_storage_data_20 ^ i_input_data[747 % IN_WIDTH];
                1146 / IN_WIDTH: ping_storage_data_20 <= ping_storage_data_20 ^ i_input_data[1146 % IN_WIDTH];
                default: ping_storage_data_20 <= ping_storage_data_20;
                endcase
            end else begin
                ping_storage_data_20 <= ping_storage_data_20;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                73 / IN_WIDTH: pong_storage_data_20 <= i_input_data[73 % IN_WIDTH];
                530 / IN_WIDTH: pong_storage_data_20 <= pong_storage_data_20 ^ i_input_data[530 % IN_WIDTH];
                747 / IN_WIDTH: pong_storage_data_20 <= pong_storage_data_20 ^ i_input_data[747 % IN_WIDTH];
                1146 / IN_WIDTH: pong_storage_data_20 <= pong_storage_data_20 ^ i_input_data[1146 % IN_WIDTH];
                default: pong_storage_data_20 <= pong_storage_data_20;
                endcase
            end
        end
    end
end

logic ping_storage_data_21;
logic pong_storage_data_21;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_21 <= 1'b0;
        pong_storage_data_21 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                74 / IN_WIDTH: ping_storage_data_21 <= i_input_data[74 % IN_WIDTH];
                531 / IN_WIDTH: ping_storage_data_21 <= ping_storage_data_21 ^ i_input_data[531 % IN_WIDTH];
                748 / IN_WIDTH: ping_storage_data_21 <= ping_storage_data_21 ^ i_input_data[748 % IN_WIDTH];
                1147 / IN_WIDTH: ping_storage_data_21 <= ping_storage_data_21 ^ i_input_data[1147 % IN_WIDTH];
                default: ping_storage_data_21 <= ping_storage_data_21;
                endcase
            end else begin
                ping_storage_data_21 <= ping_storage_data_21;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                74 / IN_WIDTH: pong_storage_data_21 <= i_input_data[74 % IN_WIDTH];
                531 / IN_WIDTH: pong_storage_data_21 <= pong_storage_data_21 ^ i_input_data[531 % IN_WIDTH];
                748 / IN_WIDTH: pong_storage_data_21 <= pong_storage_data_21 ^ i_input_data[748 % IN_WIDTH];
                1147 / IN_WIDTH: pong_storage_data_21 <= pong_storage_data_21 ^ i_input_data[1147 % IN_WIDTH];
                default: pong_storage_data_21 <= pong_storage_data_21;
                endcase
            end
        end
    end
end

logic ping_storage_data_22;
logic pong_storage_data_22;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_22 <= 1'b0;
        pong_storage_data_22 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                75 / IN_WIDTH: ping_storage_data_22 <= i_input_data[75 % IN_WIDTH];
                532 / IN_WIDTH: ping_storage_data_22 <= ping_storage_data_22 ^ i_input_data[532 % IN_WIDTH];
                749 / IN_WIDTH: ping_storage_data_22 <= ping_storage_data_22 ^ i_input_data[749 % IN_WIDTH];
                1148 / IN_WIDTH: ping_storage_data_22 <= ping_storage_data_22 ^ i_input_data[1148 % IN_WIDTH];
                default: ping_storage_data_22 <= ping_storage_data_22;
                endcase
            end else begin
                ping_storage_data_22 <= ping_storage_data_22;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                75 / IN_WIDTH: pong_storage_data_22 <= i_input_data[75 % IN_WIDTH];
                532 / IN_WIDTH: pong_storage_data_22 <= pong_storage_data_22 ^ i_input_data[532 % IN_WIDTH];
                749 / IN_WIDTH: pong_storage_data_22 <= pong_storage_data_22 ^ i_input_data[749 % IN_WIDTH];
                1148 / IN_WIDTH: pong_storage_data_22 <= pong_storage_data_22 ^ i_input_data[1148 % IN_WIDTH];
                default: pong_storage_data_22 <= pong_storage_data_22;
                endcase
            end
        end
    end
end

logic ping_storage_data_23;
logic pong_storage_data_23;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_23 <= 1'b0;
        pong_storage_data_23 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                76 / IN_WIDTH: ping_storage_data_23 <= i_input_data[76 % IN_WIDTH];
                533 / IN_WIDTH: ping_storage_data_23 <= ping_storage_data_23 ^ i_input_data[533 % IN_WIDTH];
                750 / IN_WIDTH: ping_storage_data_23 <= ping_storage_data_23 ^ i_input_data[750 % IN_WIDTH];
                1149 / IN_WIDTH: ping_storage_data_23 <= ping_storage_data_23 ^ i_input_data[1149 % IN_WIDTH];
                default: ping_storage_data_23 <= ping_storage_data_23;
                endcase
            end else begin
                ping_storage_data_23 <= ping_storage_data_23;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                76 / IN_WIDTH: pong_storage_data_23 <= i_input_data[76 % IN_WIDTH];
                533 / IN_WIDTH: pong_storage_data_23 <= pong_storage_data_23 ^ i_input_data[533 % IN_WIDTH];
                750 / IN_WIDTH: pong_storage_data_23 <= pong_storage_data_23 ^ i_input_data[750 % IN_WIDTH];
                1149 / IN_WIDTH: pong_storage_data_23 <= pong_storage_data_23 ^ i_input_data[1149 % IN_WIDTH];
                default: pong_storage_data_23 <= pong_storage_data_23;
                endcase
            end
        end
    end
end

logic ping_storage_data_24;
logic pong_storage_data_24;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_24 <= 1'b0;
        pong_storage_data_24 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                77 / IN_WIDTH: ping_storage_data_24 <= i_input_data[77 % IN_WIDTH];
                534 / IN_WIDTH: ping_storage_data_24 <= ping_storage_data_24 ^ i_input_data[534 % IN_WIDTH];
                751 / IN_WIDTH: ping_storage_data_24 <= ping_storage_data_24 ^ i_input_data[751 % IN_WIDTH];
                1150 / IN_WIDTH: ping_storage_data_24 <= ping_storage_data_24 ^ i_input_data[1150 % IN_WIDTH];
                default: ping_storage_data_24 <= ping_storage_data_24;
                endcase
            end else begin
                ping_storage_data_24 <= ping_storage_data_24;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                77 / IN_WIDTH: pong_storage_data_24 <= i_input_data[77 % IN_WIDTH];
                534 / IN_WIDTH: pong_storage_data_24 <= pong_storage_data_24 ^ i_input_data[534 % IN_WIDTH];
                751 / IN_WIDTH: pong_storage_data_24 <= pong_storage_data_24 ^ i_input_data[751 % IN_WIDTH];
                1150 / IN_WIDTH: pong_storage_data_24 <= pong_storage_data_24 ^ i_input_data[1150 % IN_WIDTH];
                default: pong_storage_data_24 <= pong_storage_data_24;
                endcase
            end
        end
    end
end

logic ping_storage_data_25;
logic pong_storage_data_25;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_25 <= 1'b0;
        pong_storage_data_25 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                78 / IN_WIDTH: ping_storage_data_25 <= i_input_data[78 % IN_WIDTH];
                535 / IN_WIDTH: ping_storage_data_25 <= ping_storage_data_25 ^ i_input_data[535 % IN_WIDTH];
                752 / IN_WIDTH: ping_storage_data_25 <= ping_storage_data_25 ^ i_input_data[752 % IN_WIDTH];
                1151 / IN_WIDTH: ping_storage_data_25 <= ping_storage_data_25 ^ i_input_data[1151 % IN_WIDTH];
                default: ping_storage_data_25 <= ping_storage_data_25;
                endcase
            end else begin
                ping_storage_data_25 <= ping_storage_data_25;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                78 / IN_WIDTH: pong_storage_data_25 <= i_input_data[78 % IN_WIDTH];
                535 / IN_WIDTH: pong_storage_data_25 <= pong_storage_data_25 ^ i_input_data[535 % IN_WIDTH];
                752 / IN_WIDTH: pong_storage_data_25 <= pong_storage_data_25 ^ i_input_data[752 % IN_WIDTH];
                1151 / IN_WIDTH: pong_storage_data_25 <= pong_storage_data_25 ^ i_input_data[1151 % IN_WIDTH];
                default: pong_storage_data_25 <= pong_storage_data_25;
                endcase
            end
        end
    end
end

logic ping_storage_data_26;
logic pong_storage_data_26;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_26 <= 1'b0;
        pong_storage_data_26 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                79 / IN_WIDTH: ping_storage_data_26 <= i_input_data[79 % IN_WIDTH];
                536 / IN_WIDTH: ping_storage_data_26 <= ping_storage_data_26 ^ i_input_data[536 % IN_WIDTH];
                753 / IN_WIDTH: ping_storage_data_26 <= ping_storage_data_26 ^ i_input_data[753 % IN_WIDTH];
                1056 / IN_WIDTH: ping_storage_data_26 <= ping_storage_data_26 ^ i_input_data[1056 % IN_WIDTH];
                default: ping_storage_data_26 <= ping_storage_data_26;
                endcase
            end else begin
                ping_storage_data_26 <= ping_storage_data_26;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                79 / IN_WIDTH: pong_storage_data_26 <= i_input_data[79 % IN_WIDTH];
                536 / IN_WIDTH: pong_storage_data_26 <= pong_storage_data_26 ^ i_input_data[536 % IN_WIDTH];
                753 / IN_WIDTH: pong_storage_data_26 <= pong_storage_data_26 ^ i_input_data[753 % IN_WIDTH];
                1056 / IN_WIDTH: pong_storage_data_26 <= pong_storage_data_26 ^ i_input_data[1056 % IN_WIDTH];
                default: pong_storage_data_26 <= pong_storage_data_26;
                endcase
            end
        end
    end
end

logic ping_storage_data_27;
logic pong_storage_data_27;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_27 <= 1'b0;
        pong_storage_data_27 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                80 / IN_WIDTH: ping_storage_data_27 <= i_input_data[80 % IN_WIDTH];
                537 / IN_WIDTH: ping_storage_data_27 <= ping_storage_data_27 ^ i_input_data[537 % IN_WIDTH];
                754 / IN_WIDTH: ping_storage_data_27 <= ping_storage_data_27 ^ i_input_data[754 % IN_WIDTH];
                1057 / IN_WIDTH: ping_storage_data_27 <= ping_storage_data_27 ^ i_input_data[1057 % IN_WIDTH];
                default: ping_storage_data_27 <= ping_storage_data_27;
                endcase
            end else begin
                ping_storage_data_27 <= ping_storage_data_27;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                80 / IN_WIDTH: pong_storage_data_27 <= i_input_data[80 % IN_WIDTH];
                537 / IN_WIDTH: pong_storage_data_27 <= pong_storage_data_27 ^ i_input_data[537 % IN_WIDTH];
                754 / IN_WIDTH: pong_storage_data_27 <= pong_storage_data_27 ^ i_input_data[754 % IN_WIDTH];
                1057 / IN_WIDTH: pong_storage_data_27 <= pong_storage_data_27 ^ i_input_data[1057 % IN_WIDTH];
                default: pong_storage_data_27 <= pong_storage_data_27;
                endcase
            end
        end
    end
end

logic ping_storage_data_28;
logic pong_storage_data_28;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_28 <= 1'b0;
        pong_storage_data_28 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                81 / IN_WIDTH: ping_storage_data_28 <= i_input_data[81 % IN_WIDTH];
                538 / IN_WIDTH: ping_storage_data_28 <= ping_storage_data_28 ^ i_input_data[538 % IN_WIDTH];
                755 / IN_WIDTH: ping_storage_data_28 <= ping_storage_data_28 ^ i_input_data[755 % IN_WIDTH];
                1058 / IN_WIDTH: ping_storage_data_28 <= ping_storage_data_28 ^ i_input_data[1058 % IN_WIDTH];
                default: ping_storage_data_28 <= ping_storage_data_28;
                endcase
            end else begin
                ping_storage_data_28 <= ping_storage_data_28;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                81 / IN_WIDTH: pong_storage_data_28 <= i_input_data[81 % IN_WIDTH];
                538 / IN_WIDTH: pong_storage_data_28 <= pong_storage_data_28 ^ i_input_data[538 % IN_WIDTH];
                755 / IN_WIDTH: pong_storage_data_28 <= pong_storage_data_28 ^ i_input_data[755 % IN_WIDTH];
                1058 / IN_WIDTH: pong_storage_data_28 <= pong_storage_data_28 ^ i_input_data[1058 % IN_WIDTH];
                default: pong_storage_data_28 <= pong_storage_data_28;
                endcase
            end
        end
    end
end

logic ping_storage_data_29;
logic pong_storage_data_29;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_29 <= 1'b0;
        pong_storage_data_29 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                82 / IN_WIDTH: ping_storage_data_29 <= i_input_data[82 % IN_WIDTH];
                539 / IN_WIDTH: ping_storage_data_29 <= ping_storage_data_29 ^ i_input_data[539 % IN_WIDTH];
                756 / IN_WIDTH: ping_storage_data_29 <= ping_storage_data_29 ^ i_input_data[756 % IN_WIDTH];
                1059 / IN_WIDTH: ping_storage_data_29 <= ping_storage_data_29 ^ i_input_data[1059 % IN_WIDTH];
                default: ping_storage_data_29 <= ping_storage_data_29;
                endcase
            end else begin
                ping_storage_data_29 <= ping_storage_data_29;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                82 / IN_WIDTH: pong_storage_data_29 <= i_input_data[82 % IN_WIDTH];
                539 / IN_WIDTH: pong_storage_data_29 <= pong_storage_data_29 ^ i_input_data[539 % IN_WIDTH];
                756 / IN_WIDTH: pong_storage_data_29 <= pong_storage_data_29 ^ i_input_data[756 % IN_WIDTH];
                1059 / IN_WIDTH: pong_storage_data_29 <= pong_storage_data_29 ^ i_input_data[1059 % IN_WIDTH];
                default: pong_storage_data_29 <= pong_storage_data_29;
                endcase
            end
        end
    end
end

logic ping_storage_data_30;
logic pong_storage_data_30;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_30 <= 1'b0;
        pong_storage_data_30 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                83 / IN_WIDTH: ping_storage_data_30 <= i_input_data[83 % IN_WIDTH];
                540 / IN_WIDTH: ping_storage_data_30 <= ping_storage_data_30 ^ i_input_data[540 % IN_WIDTH];
                757 / IN_WIDTH: ping_storage_data_30 <= ping_storage_data_30 ^ i_input_data[757 % IN_WIDTH];
                1060 / IN_WIDTH: ping_storage_data_30 <= ping_storage_data_30 ^ i_input_data[1060 % IN_WIDTH];
                default: ping_storage_data_30 <= ping_storage_data_30;
                endcase
            end else begin
                ping_storage_data_30 <= ping_storage_data_30;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                83 / IN_WIDTH: pong_storage_data_30 <= i_input_data[83 % IN_WIDTH];
                540 / IN_WIDTH: pong_storage_data_30 <= pong_storage_data_30 ^ i_input_data[540 % IN_WIDTH];
                757 / IN_WIDTH: pong_storage_data_30 <= pong_storage_data_30 ^ i_input_data[757 % IN_WIDTH];
                1060 / IN_WIDTH: pong_storage_data_30 <= pong_storage_data_30 ^ i_input_data[1060 % IN_WIDTH];
                default: pong_storage_data_30 <= pong_storage_data_30;
                endcase
            end
        end
    end
end

logic ping_storage_data_31;
logic pong_storage_data_31;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_31 <= 1'b0;
        pong_storage_data_31 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                84 / IN_WIDTH: ping_storage_data_31 <= i_input_data[84 % IN_WIDTH];
                541 / IN_WIDTH: ping_storage_data_31 <= ping_storage_data_31 ^ i_input_data[541 % IN_WIDTH];
                758 / IN_WIDTH: ping_storage_data_31 <= ping_storage_data_31 ^ i_input_data[758 % IN_WIDTH];
                1061 / IN_WIDTH: ping_storage_data_31 <= ping_storage_data_31 ^ i_input_data[1061 % IN_WIDTH];
                default: ping_storage_data_31 <= ping_storage_data_31;
                endcase
            end else begin
                ping_storage_data_31 <= ping_storage_data_31;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                84 / IN_WIDTH: pong_storage_data_31 <= i_input_data[84 % IN_WIDTH];
                541 / IN_WIDTH: pong_storage_data_31 <= pong_storage_data_31 ^ i_input_data[541 % IN_WIDTH];
                758 / IN_WIDTH: pong_storage_data_31 <= pong_storage_data_31 ^ i_input_data[758 % IN_WIDTH];
                1061 / IN_WIDTH: pong_storage_data_31 <= pong_storage_data_31 ^ i_input_data[1061 % IN_WIDTH];
                default: pong_storage_data_31 <= pong_storage_data_31;
                endcase
            end
        end
    end
end

logic ping_storage_data_32;
logic pong_storage_data_32;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_32 <= 1'b0;
        pong_storage_data_32 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                85 / IN_WIDTH: ping_storage_data_32 <= i_input_data[85 % IN_WIDTH];
                542 / IN_WIDTH: ping_storage_data_32 <= ping_storage_data_32 ^ i_input_data[542 % IN_WIDTH];
                759 / IN_WIDTH: ping_storage_data_32 <= ping_storage_data_32 ^ i_input_data[759 % IN_WIDTH];
                1062 / IN_WIDTH: ping_storage_data_32 <= ping_storage_data_32 ^ i_input_data[1062 % IN_WIDTH];
                default: ping_storage_data_32 <= ping_storage_data_32;
                endcase
            end else begin
                ping_storage_data_32 <= ping_storage_data_32;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                85 / IN_WIDTH: pong_storage_data_32 <= i_input_data[85 % IN_WIDTH];
                542 / IN_WIDTH: pong_storage_data_32 <= pong_storage_data_32 ^ i_input_data[542 % IN_WIDTH];
                759 / IN_WIDTH: pong_storage_data_32 <= pong_storage_data_32 ^ i_input_data[759 % IN_WIDTH];
                1062 / IN_WIDTH: pong_storage_data_32 <= pong_storage_data_32 ^ i_input_data[1062 % IN_WIDTH];
                default: pong_storage_data_32 <= pong_storage_data_32;
                endcase
            end
        end
    end
end

logic ping_storage_data_33;
logic pong_storage_data_33;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_33 <= 1'b0;
        pong_storage_data_33 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                86 / IN_WIDTH: ping_storage_data_33 <= i_input_data[86 % IN_WIDTH];
                543 / IN_WIDTH: ping_storage_data_33 <= ping_storage_data_33 ^ i_input_data[543 % IN_WIDTH];
                760 / IN_WIDTH: ping_storage_data_33 <= ping_storage_data_33 ^ i_input_data[760 % IN_WIDTH];
                1063 / IN_WIDTH: ping_storage_data_33 <= ping_storage_data_33 ^ i_input_data[1063 % IN_WIDTH];
                default: ping_storage_data_33 <= ping_storage_data_33;
                endcase
            end else begin
                ping_storage_data_33 <= ping_storage_data_33;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                86 / IN_WIDTH: pong_storage_data_33 <= i_input_data[86 % IN_WIDTH];
                543 / IN_WIDTH: pong_storage_data_33 <= pong_storage_data_33 ^ i_input_data[543 % IN_WIDTH];
                760 / IN_WIDTH: pong_storage_data_33 <= pong_storage_data_33 ^ i_input_data[760 % IN_WIDTH];
                1063 / IN_WIDTH: pong_storage_data_33 <= pong_storage_data_33 ^ i_input_data[1063 % IN_WIDTH];
                default: pong_storage_data_33 <= pong_storage_data_33;
                endcase
            end
        end
    end
end

logic ping_storage_data_34;
logic pong_storage_data_34;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_34 <= 1'b0;
        pong_storage_data_34 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                87 / IN_WIDTH: ping_storage_data_34 <= i_input_data[87 % IN_WIDTH];
                544 / IN_WIDTH: ping_storage_data_34 <= ping_storage_data_34 ^ i_input_data[544 % IN_WIDTH];
                761 / IN_WIDTH: ping_storage_data_34 <= ping_storage_data_34 ^ i_input_data[761 % IN_WIDTH];
                1064 / IN_WIDTH: ping_storage_data_34 <= ping_storage_data_34 ^ i_input_data[1064 % IN_WIDTH];
                default: ping_storage_data_34 <= ping_storage_data_34;
                endcase
            end else begin
                ping_storage_data_34 <= ping_storage_data_34;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                87 / IN_WIDTH: pong_storage_data_34 <= i_input_data[87 % IN_WIDTH];
                544 / IN_WIDTH: pong_storage_data_34 <= pong_storage_data_34 ^ i_input_data[544 % IN_WIDTH];
                761 / IN_WIDTH: pong_storage_data_34 <= pong_storage_data_34 ^ i_input_data[761 % IN_WIDTH];
                1064 / IN_WIDTH: pong_storage_data_34 <= pong_storage_data_34 ^ i_input_data[1064 % IN_WIDTH];
                default: pong_storage_data_34 <= pong_storage_data_34;
                endcase
            end
        end
    end
end

logic ping_storage_data_35;
logic pong_storage_data_35;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_35 <= 1'b0;
        pong_storage_data_35 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                88 / IN_WIDTH: ping_storage_data_35 <= i_input_data[88 % IN_WIDTH];
                545 / IN_WIDTH: ping_storage_data_35 <= ping_storage_data_35 ^ i_input_data[545 % IN_WIDTH];
                762 / IN_WIDTH: ping_storage_data_35 <= ping_storage_data_35 ^ i_input_data[762 % IN_WIDTH];
                1065 / IN_WIDTH: ping_storage_data_35 <= ping_storage_data_35 ^ i_input_data[1065 % IN_WIDTH];
                default: ping_storage_data_35 <= ping_storage_data_35;
                endcase
            end else begin
                ping_storage_data_35 <= ping_storage_data_35;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                88 / IN_WIDTH: pong_storage_data_35 <= i_input_data[88 % IN_WIDTH];
                545 / IN_WIDTH: pong_storage_data_35 <= pong_storage_data_35 ^ i_input_data[545 % IN_WIDTH];
                762 / IN_WIDTH: pong_storage_data_35 <= pong_storage_data_35 ^ i_input_data[762 % IN_WIDTH];
                1065 / IN_WIDTH: pong_storage_data_35 <= pong_storage_data_35 ^ i_input_data[1065 % IN_WIDTH];
                default: pong_storage_data_35 <= pong_storage_data_35;
                endcase
            end
        end
    end
end

logic ping_storage_data_36;
logic pong_storage_data_36;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_36 <= 1'b0;
        pong_storage_data_36 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                89 / IN_WIDTH: ping_storage_data_36 <= i_input_data[89 % IN_WIDTH];
                546 / IN_WIDTH: ping_storage_data_36 <= ping_storage_data_36 ^ i_input_data[546 % IN_WIDTH];
                763 / IN_WIDTH: ping_storage_data_36 <= ping_storage_data_36 ^ i_input_data[763 % IN_WIDTH];
                1066 / IN_WIDTH: ping_storage_data_36 <= ping_storage_data_36 ^ i_input_data[1066 % IN_WIDTH];
                default: ping_storage_data_36 <= ping_storage_data_36;
                endcase
            end else begin
                ping_storage_data_36 <= ping_storage_data_36;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                89 / IN_WIDTH: pong_storage_data_36 <= i_input_data[89 % IN_WIDTH];
                546 / IN_WIDTH: pong_storage_data_36 <= pong_storage_data_36 ^ i_input_data[546 % IN_WIDTH];
                763 / IN_WIDTH: pong_storage_data_36 <= pong_storage_data_36 ^ i_input_data[763 % IN_WIDTH];
                1066 / IN_WIDTH: pong_storage_data_36 <= pong_storage_data_36 ^ i_input_data[1066 % IN_WIDTH];
                default: pong_storage_data_36 <= pong_storage_data_36;
                endcase
            end
        end
    end
end

logic ping_storage_data_37;
logic pong_storage_data_37;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_37 <= 1'b0;
        pong_storage_data_37 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                90 / IN_WIDTH: ping_storage_data_37 <= i_input_data[90 % IN_WIDTH];
                547 / IN_WIDTH: ping_storage_data_37 <= ping_storage_data_37 ^ i_input_data[547 % IN_WIDTH];
                764 / IN_WIDTH: ping_storage_data_37 <= ping_storage_data_37 ^ i_input_data[764 % IN_WIDTH];
                1067 / IN_WIDTH: ping_storage_data_37 <= ping_storage_data_37 ^ i_input_data[1067 % IN_WIDTH];
                default: ping_storage_data_37 <= ping_storage_data_37;
                endcase
            end else begin
                ping_storage_data_37 <= ping_storage_data_37;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                90 / IN_WIDTH: pong_storage_data_37 <= i_input_data[90 % IN_WIDTH];
                547 / IN_WIDTH: pong_storage_data_37 <= pong_storage_data_37 ^ i_input_data[547 % IN_WIDTH];
                764 / IN_WIDTH: pong_storage_data_37 <= pong_storage_data_37 ^ i_input_data[764 % IN_WIDTH];
                1067 / IN_WIDTH: pong_storage_data_37 <= pong_storage_data_37 ^ i_input_data[1067 % IN_WIDTH];
                default: pong_storage_data_37 <= pong_storage_data_37;
                endcase
            end
        end
    end
end

logic ping_storage_data_38;
logic pong_storage_data_38;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_38 <= 1'b0;
        pong_storage_data_38 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                91 / IN_WIDTH: ping_storage_data_38 <= i_input_data[91 % IN_WIDTH];
                548 / IN_WIDTH: ping_storage_data_38 <= ping_storage_data_38 ^ i_input_data[548 % IN_WIDTH];
                765 / IN_WIDTH: ping_storage_data_38 <= ping_storage_data_38 ^ i_input_data[765 % IN_WIDTH];
                1068 / IN_WIDTH: ping_storage_data_38 <= ping_storage_data_38 ^ i_input_data[1068 % IN_WIDTH];
                default: ping_storage_data_38 <= ping_storage_data_38;
                endcase
            end else begin
                ping_storage_data_38 <= ping_storage_data_38;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                91 / IN_WIDTH: pong_storage_data_38 <= i_input_data[91 % IN_WIDTH];
                548 / IN_WIDTH: pong_storage_data_38 <= pong_storage_data_38 ^ i_input_data[548 % IN_WIDTH];
                765 / IN_WIDTH: pong_storage_data_38 <= pong_storage_data_38 ^ i_input_data[765 % IN_WIDTH];
                1068 / IN_WIDTH: pong_storage_data_38 <= pong_storage_data_38 ^ i_input_data[1068 % IN_WIDTH];
                default: pong_storage_data_38 <= pong_storage_data_38;
                endcase
            end
        end
    end
end

logic ping_storage_data_39;
logic pong_storage_data_39;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_39 <= 1'b0;
        pong_storage_data_39 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                92 / IN_WIDTH: ping_storage_data_39 <= i_input_data[92 % IN_WIDTH];
                549 / IN_WIDTH: ping_storage_data_39 <= ping_storage_data_39 ^ i_input_data[549 % IN_WIDTH];
                766 / IN_WIDTH: ping_storage_data_39 <= ping_storage_data_39 ^ i_input_data[766 % IN_WIDTH];
                1069 / IN_WIDTH: ping_storage_data_39 <= ping_storage_data_39 ^ i_input_data[1069 % IN_WIDTH];
                default: ping_storage_data_39 <= ping_storage_data_39;
                endcase
            end else begin
                ping_storage_data_39 <= ping_storage_data_39;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                92 / IN_WIDTH: pong_storage_data_39 <= i_input_data[92 % IN_WIDTH];
                549 / IN_WIDTH: pong_storage_data_39 <= pong_storage_data_39 ^ i_input_data[549 % IN_WIDTH];
                766 / IN_WIDTH: pong_storage_data_39 <= pong_storage_data_39 ^ i_input_data[766 % IN_WIDTH];
                1069 / IN_WIDTH: pong_storage_data_39 <= pong_storage_data_39 ^ i_input_data[1069 % IN_WIDTH];
                default: pong_storage_data_39 <= pong_storage_data_39;
                endcase
            end
        end
    end
end

logic ping_storage_data_40;
logic pong_storage_data_40;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_40 <= 1'b0;
        pong_storage_data_40 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                93 / IN_WIDTH: ping_storage_data_40 <= i_input_data[93 % IN_WIDTH];
                550 / IN_WIDTH: ping_storage_data_40 <= ping_storage_data_40 ^ i_input_data[550 % IN_WIDTH];
                767 / IN_WIDTH: ping_storage_data_40 <= ping_storage_data_40 ^ i_input_data[767 % IN_WIDTH];
                1070 / IN_WIDTH: ping_storage_data_40 <= ping_storage_data_40 ^ i_input_data[1070 % IN_WIDTH];
                default: ping_storage_data_40 <= ping_storage_data_40;
                endcase
            end else begin
                ping_storage_data_40 <= ping_storage_data_40;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                93 / IN_WIDTH: pong_storage_data_40 <= i_input_data[93 % IN_WIDTH];
                550 / IN_WIDTH: pong_storage_data_40 <= pong_storage_data_40 ^ i_input_data[550 % IN_WIDTH];
                767 / IN_WIDTH: pong_storage_data_40 <= pong_storage_data_40 ^ i_input_data[767 % IN_WIDTH];
                1070 / IN_WIDTH: pong_storage_data_40 <= pong_storage_data_40 ^ i_input_data[1070 % IN_WIDTH];
                default: pong_storage_data_40 <= pong_storage_data_40;
                endcase
            end
        end
    end
end

logic ping_storage_data_41;
logic pong_storage_data_41;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_41 <= 1'b0;
        pong_storage_data_41 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                94 / IN_WIDTH: ping_storage_data_41 <= i_input_data[94 % IN_WIDTH];
                551 / IN_WIDTH: ping_storage_data_41 <= ping_storage_data_41 ^ i_input_data[551 % IN_WIDTH];
                672 / IN_WIDTH: ping_storage_data_41 <= ping_storage_data_41 ^ i_input_data[672 % IN_WIDTH];
                1071 / IN_WIDTH: ping_storage_data_41 <= ping_storage_data_41 ^ i_input_data[1071 % IN_WIDTH];
                default: ping_storage_data_41 <= ping_storage_data_41;
                endcase
            end else begin
                ping_storage_data_41 <= ping_storage_data_41;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                94 / IN_WIDTH: pong_storage_data_41 <= i_input_data[94 % IN_WIDTH];
                551 / IN_WIDTH: pong_storage_data_41 <= pong_storage_data_41 ^ i_input_data[551 % IN_WIDTH];
                672 / IN_WIDTH: pong_storage_data_41 <= pong_storage_data_41 ^ i_input_data[672 % IN_WIDTH];
                1071 / IN_WIDTH: pong_storage_data_41 <= pong_storage_data_41 ^ i_input_data[1071 % IN_WIDTH];
                default: pong_storage_data_41 <= pong_storage_data_41;
                endcase
            end
        end
    end
end

logic ping_storage_data_42;
logic pong_storage_data_42;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_42 <= 1'b0;
        pong_storage_data_42 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                95 / IN_WIDTH: ping_storage_data_42 <= i_input_data[95 % IN_WIDTH];
                552 / IN_WIDTH: ping_storage_data_42 <= ping_storage_data_42 ^ i_input_data[552 % IN_WIDTH];
                673 / IN_WIDTH: ping_storage_data_42 <= ping_storage_data_42 ^ i_input_data[673 % IN_WIDTH];
                1072 / IN_WIDTH: ping_storage_data_42 <= ping_storage_data_42 ^ i_input_data[1072 % IN_WIDTH];
                default: ping_storage_data_42 <= ping_storage_data_42;
                endcase
            end else begin
                ping_storage_data_42 <= ping_storage_data_42;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                95 / IN_WIDTH: pong_storage_data_42 <= i_input_data[95 % IN_WIDTH];
                552 / IN_WIDTH: pong_storage_data_42 <= pong_storage_data_42 ^ i_input_data[552 % IN_WIDTH];
                673 / IN_WIDTH: pong_storage_data_42 <= pong_storage_data_42 ^ i_input_data[673 % IN_WIDTH];
                1072 / IN_WIDTH: pong_storage_data_42 <= pong_storage_data_42 ^ i_input_data[1072 % IN_WIDTH];
                default: pong_storage_data_42 <= pong_storage_data_42;
                endcase
            end
        end
    end
end

logic ping_storage_data_43;
logic pong_storage_data_43;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_43 <= 1'b0;
        pong_storage_data_43 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                0 / IN_WIDTH: ping_storage_data_43 <= i_input_data[0 % IN_WIDTH];
                553 / IN_WIDTH: ping_storage_data_43 <= ping_storage_data_43 ^ i_input_data[553 % IN_WIDTH];
                674 / IN_WIDTH: ping_storage_data_43 <= ping_storage_data_43 ^ i_input_data[674 % IN_WIDTH];
                1073 / IN_WIDTH: ping_storage_data_43 <= ping_storage_data_43 ^ i_input_data[1073 % IN_WIDTH];
                default: ping_storage_data_43 <= ping_storage_data_43;
                endcase
            end else begin
                ping_storage_data_43 <= ping_storage_data_43;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                0 / IN_WIDTH: pong_storage_data_43 <= i_input_data[0 % IN_WIDTH];
                553 / IN_WIDTH: pong_storage_data_43 <= pong_storage_data_43 ^ i_input_data[553 % IN_WIDTH];
                674 / IN_WIDTH: pong_storage_data_43 <= pong_storage_data_43 ^ i_input_data[674 % IN_WIDTH];
                1073 / IN_WIDTH: pong_storage_data_43 <= pong_storage_data_43 ^ i_input_data[1073 % IN_WIDTH];
                default: pong_storage_data_43 <= pong_storage_data_43;
                endcase
            end
        end
    end
end

logic ping_storage_data_44;
logic pong_storage_data_44;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_44 <= 1'b0;
        pong_storage_data_44 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                1 / IN_WIDTH: ping_storage_data_44 <= i_input_data[1 % IN_WIDTH];
                554 / IN_WIDTH: ping_storage_data_44 <= ping_storage_data_44 ^ i_input_data[554 % IN_WIDTH];
                675 / IN_WIDTH: ping_storage_data_44 <= ping_storage_data_44 ^ i_input_data[675 % IN_WIDTH];
                1074 / IN_WIDTH: ping_storage_data_44 <= ping_storage_data_44 ^ i_input_data[1074 % IN_WIDTH];
                default: ping_storage_data_44 <= ping_storage_data_44;
                endcase
            end else begin
                ping_storage_data_44 <= ping_storage_data_44;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                1 / IN_WIDTH: pong_storage_data_44 <= i_input_data[1 % IN_WIDTH];
                554 / IN_WIDTH: pong_storage_data_44 <= pong_storage_data_44 ^ i_input_data[554 % IN_WIDTH];
                675 / IN_WIDTH: pong_storage_data_44 <= pong_storage_data_44 ^ i_input_data[675 % IN_WIDTH];
                1074 / IN_WIDTH: pong_storage_data_44 <= pong_storage_data_44 ^ i_input_data[1074 % IN_WIDTH];
                default: pong_storage_data_44 <= pong_storage_data_44;
                endcase
            end
        end
    end
end

logic ping_storage_data_45;
logic pong_storage_data_45;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_45 <= 1'b0;
        pong_storage_data_45 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                2 / IN_WIDTH: ping_storage_data_45 <= i_input_data[2 % IN_WIDTH];
                555 / IN_WIDTH: ping_storage_data_45 <= ping_storage_data_45 ^ i_input_data[555 % IN_WIDTH];
                676 / IN_WIDTH: ping_storage_data_45 <= ping_storage_data_45 ^ i_input_data[676 % IN_WIDTH];
                1075 / IN_WIDTH: ping_storage_data_45 <= ping_storage_data_45 ^ i_input_data[1075 % IN_WIDTH];
                default: ping_storage_data_45 <= ping_storage_data_45;
                endcase
            end else begin
                ping_storage_data_45 <= ping_storage_data_45;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                2 / IN_WIDTH: pong_storage_data_45 <= i_input_data[2 % IN_WIDTH];
                555 / IN_WIDTH: pong_storage_data_45 <= pong_storage_data_45 ^ i_input_data[555 % IN_WIDTH];
                676 / IN_WIDTH: pong_storage_data_45 <= pong_storage_data_45 ^ i_input_data[676 % IN_WIDTH];
                1075 / IN_WIDTH: pong_storage_data_45 <= pong_storage_data_45 ^ i_input_data[1075 % IN_WIDTH];
                default: pong_storage_data_45 <= pong_storage_data_45;
                endcase
            end
        end
    end
end

logic ping_storage_data_46;
logic pong_storage_data_46;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_46 <= 1'b0;
        pong_storage_data_46 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                3 / IN_WIDTH: ping_storage_data_46 <= i_input_data[3 % IN_WIDTH];
                556 / IN_WIDTH: ping_storage_data_46 <= ping_storage_data_46 ^ i_input_data[556 % IN_WIDTH];
                677 / IN_WIDTH: ping_storage_data_46 <= ping_storage_data_46 ^ i_input_data[677 % IN_WIDTH];
                1076 / IN_WIDTH: ping_storage_data_46 <= ping_storage_data_46 ^ i_input_data[1076 % IN_WIDTH];
                default: ping_storage_data_46 <= ping_storage_data_46;
                endcase
            end else begin
                ping_storage_data_46 <= ping_storage_data_46;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                3 / IN_WIDTH: pong_storage_data_46 <= i_input_data[3 % IN_WIDTH];
                556 / IN_WIDTH: pong_storage_data_46 <= pong_storage_data_46 ^ i_input_data[556 % IN_WIDTH];
                677 / IN_WIDTH: pong_storage_data_46 <= pong_storage_data_46 ^ i_input_data[677 % IN_WIDTH];
                1076 / IN_WIDTH: pong_storage_data_46 <= pong_storage_data_46 ^ i_input_data[1076 % IN_WIDTH];
                default: pong_storage_data_46 <= pong_storage_data_46;
                endcase
            end
        end
    end
end

logic ping_storage_data_47;
logic pong_storage_data_47;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_47 <= 1'b0;
        pong_storage_data_47 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                4 / IN_WIDTH: ping_storage_data_47 <= i_input_data[4 % IN_WIDTH];
                557 / IN_WIDTH: ping_storage_data_47 <= ping_storage_data_47 ^ i_input_data[557 % IN_WIDTH];
                678 / IN_WIDTH: ping_storage_data_47 <= ping_storage_data_47 ^ i_input_data[678 % IN_WIDTH];
                1077 / IN_WIDTH: ping_storage_data_47 <= ping_storage_data_47 ^ i_input_data[1077 % IN_WIDTH];
                default: ping_storage_data_47 <= ping_storage_data_47;
                endcase
            end else begin
                ping_storage_data_47 <= ping_storage_data_47;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                4 / IN_WIDTH: pong_storage_data_47 <= i_input_data[4 % IN_WIDTH];
                557 / IN_WIDTH: pong_storage_data_47 <= pong_storage_data_47 ^ i_input_data[557 % IN_WIDTH];
                678 / IN_WIDTH: pong_storage_data_47 <= pong_storage_data_47 ^ i_input_data[678 % IN_WIDTH];
                1077 / IN_WIDTH: pong_storage_data_47 <= pong_storage_data_47 ^ i_input_data[1077 % IN_WIDTH];
                default: pong_storage_data_47 <= pong_storage_data_47;
                endcase
            end
        end
    end
end

logic ping_storage_data_48;
logic pong_storage_data_48;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_48 <= 1'b0;
        pong_storage_data_48 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                5 / IN_WIDTH: ping_storage_data_48 <= i_input_data[5 % IN_WIDTH];
                558 / IN_WIDTH: ping_storage_data_48 <= ping_storage_data_48 ^ i_input_data[558 % IN_WIDTH];
                679 / IN_WIDTH: ping_storage_data_48 <= ping_storage_data_48 ^ i_input_data[679 % IN_WIDTH];
                1078 / IN_WIDTH: ping_storage_data_48 <= ping_storage_data_48 ^ i_input_data[1078 % IN_WIDTH];
                default: ping_storage_data_48 <= ping_storage_data_48;
                endcase
            end else begin
                ping_storage_data_48 <= ping_storage_data_48;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                5 / IN_WIDTH: pong_storage_data_48 <= i_input_data[5 % IN_WIDTH];
                558 / IN_WIDTH: pong_storage_data_48 <= pong_storage_data_48 ^ i_input_data[558 % IN_WIDTH];
                679 / IN_WIDTH: pong_storage_data_48 <= pong_storage_data_48 ^ i_input_data[679 % IN_WIDTH];
                1078 / IN_WIDTH: pong_storage_data_48 <= pong_storage_data_48 ^ i_input_data[1078 % IN_WIDTH];
                default: pong_storage_data_48 <= pong_storage_data_48;
                endcase
            end
        end
    end
end

logic ping_storage_data_49;
logic pong_storage_data_49;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_49 <= 1'b0;
        pong_storage_data_49 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                6 / IN_WIDTH: ping_storage_data_49 <= i_input_data[6 % IN_WIDTH];
                559 / IN_WIDTH: ping_storage_data_49 <= ping_storage_data_49 ^ i_input_data[559 % IN_WIDTH];
                680 / IN_WIDTH: ping_storage_data_49 <= ping_storage_data_49 ^ i_input_data[680 % IN_WIDTH];
                1079 / IN_WIDTH: ping_storage_data_49 <= ping_storage_data_49 ^ i_input_data[1079 % IN_WIDTH];
                default: ping_storage_data_49 <= ping_storage_data_49;
                endcase
            end else begin
                ping_storage_data_49 <= ping_storage_data_49;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                6 / IN_WIDTH: pong_storage_data_49 <= i_input_data[6 % IN_WIDTH];
                559 / IN_WIDTH: pong_storage_data_49 <= pong_storage_data_49 ^ i_input_data[559 % IN_WIDTH];
                680 / IN_WIDTH: pong_storage_data_49 <= pong_storage_data_49 ^ i_input_data[680 % IN_WIDTH];
                1079 / IN_WIDTH: pong_storage_data_49 <= pong_storage_data_49 ^ i_input_data[1079 % IN_WIDTH];
                default: pong_storage_data_49 <= pong_storage_data_49;
                endcase
            end
        end
    end
end

logic ping_storage_data_50;
logic pong_storage_data_50;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_50 <= 1'b0;
        pong_storage_data_50 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                7 / IN_WIDTH: ping_storage_data_50 <= i_input_data[7 % IN_WIDTH];
                560 / IN_WIDTH: ping_storage_data_50 <= ping_storage_data_50 ^ i_input_data[560 % IN_WIDTH];
                681 / IN_WIDTH: ping_storage_data_50 <= ping_storage_data_50 ^ i_input_data[681 % IN_WIDTH];
                1080 / IN_WIDTH: ping_storage_data_50 <= ping_storage_data_50 ^ i_input_data[1080 % IN_WIDTH];
                default: ping_storage_data_50 <= ping_storage_data_50;
                endcase
            end else begin
                ping_storage_data_50 <= ping_storage_data_50;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                7 / IN_WIDTH: pong_storage_data_50 <= i_input_data[7 % IN_WIDTH];
                560 / IN_WIDTH: pong_storage_data_50 <= pong_storage_data_50 ^ i_input_data[560 % IN_WIDTH];
                681 / IN_WIDTH: pong_storage_data_50 <= pong_storage_data_50 ^ i_input_data[681 % IN_WIDTH];
                1080 / IN_WIDTH: pong_storage_data_50 <= pong_storage_data_50 ^ i_input_data[1080 % IN_WIDTH];
                default: pong_storage_data_50 <= pong_storage_data_50;
                endcase
            end
        end
    end
end

logic ping_storage_data_51;
logic pong_storage_data_51;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_51 <= 1'b0;
        pong_storage_data_51 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                8 / IN_WIDTH: ping_storage_data_51 <= i_input_data[8 % IN_WIDTH];
                561 / IN_WIDTH: ping_storage_data_51 <= ping_storage_data_51 ^ i_input_data[561 % IN_WIDTH];
                682 / IN_WIDTH: ping_storage_data_51 <= ping_storage_data_51 ^ i_input_data[682 % IN_WIDTH];
                1081 / IN_WIDTH: ping_storage_data_51 <= ping_storage_data_51 ^ i_input_data[1081 % IN_WIDTH];
                default: ping_storage_data_51 <= ping_storage_data_51;
                endcase
            end else begin
                ping_storage_data_51 <= ping_storage_data_51;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                8 / IN_WIDTH: pong_storage_data_51 <= i_input_data[8 % IN_WIDTH];
                561 / IN_WIDTH: pong_storage_data_51 <= pong_storage_data_51 ^ i_input_data[561 % IN_WIDTH];
                682 / IN_WIDTH: pong_storage_data_51 <= pong_storage_data_51 ^ i_input_data[682 % IN_WIDTH];
                1081 / IN_WIDTH: pong_storage_data_51 <= pong_storage_data_51 ^ i_input_data[1081 % IN_WIDTH];
                default: pong_storage_data_51 <= pong_storage_data_51;
                endcase
            end
        end
    end
end

logic ping_storage_data_52;
logic pong_storage_data_52;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_52 <= 1'b0;
        pong_storage_data_52 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                9 / IN_WIDTH: ping_storage_data_52 <= i_input_data[9 % IN_WIDTH];
                562 / IN_WIDTH: ping_storage_data_52 <= ping_storage_data_52 ^ i_input_data[562 % IN_WIDTH];
                683 / IN_WIDTH: ping_storage_data_52 <= ping_storage_data_52 ^ i_input_data[683 % IN_WIDTH];
                1082 / IN_WIDTH: ping_storage_data_52 <= ping_storage_data_52 ^ i_input_data[1082 % IN_WIDTH];
                default: ping_storage_data_52 <= ping_storage_data_52;
                endcase
            end else begin
                ping_storage_data_52 <= ping_storage_data_52;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                9 / IN_WIDTH: pong_storage_data_52 <= i_input_data[9 % IN_WIDTH];
                562 / IN_WIDTH: pong_storage_data_52 <= pong_storage_data_52 ^ i_input_data[562 % IN_WIDTH];
                683 / IN_WIDTH: pong_storage_data_52 <= pong_storage_data_52 ^ i_input_data[683 % IN_WIDTH];
                1082 / IN_WIDTH: pong_storage_data_52 <= pong_storage_data_52 ^ i_input_data[1082 % IN_WIDTH];
                default: pong_storage_data_52 <= pong_storage_data_52;
                endcase
            end
        end
    end
end

logic ping_storage_data_53;
logic pong_storage_data_53;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_53 <= 1'b0;
        pong_storage_data_53 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                10 / IN_WIDTH: ping_storage_data_53 <= i_input_data[10 % IN_WIDTH];
                563 / IN_WIDTH: ping_storage_data_53 <= ping_storage_data_53 ^ i_input_data[563 % IN_WIDTH];
                684 / IN_WIDTH: ping_storage_data_53 <= ping_storage_data_53 ^ i_input_data[684 % IN_WIDTH];
                1083 / IN_WIDTH: ping_storage_data_53 <= ping_storage_data_53 ^ i_input_data[1083 % IN_WIDTH];
                default: ping_storage_data_53 <= ping_storage_data_53;
                endcase
            end else begin
                ping_storage_data_53 <= ping_storage_data_53;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                10 / IN_WIDTH: pong_storage_data_53 <= i_input_data[10 % IN_WIDTH];
                563 / IN_WIDTH: pong_storage_data_53 <= pong_storage_data_53 ^ i_input_data[563 % IN_WIDTH];
                684 / IN_WIDTH: pong_storage_data_53 <= pong_storage_data_53 ^ i_input_data[684 % IN_WIDTH];
                1083 / IN_WIDTH: pong_storage_data_53 <= pong_storage_data_53 ^ i_input_data[1083 % IN_WIDTH];
                default: pong_storage_data_53 <= pong_storage_data_53;
                endcase
            end
        end
    end
end

logic ping_storage_data_54;
logic pong_storage_data_54;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_54 <= 1'b0;
        pong_storage_data_54 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                11 / IN_WIDTH: ping_storage_data_54 <= i_input_data[11 % IN_WIDTH];
                564 / IN_WIDTH: ping_storage_data_54 <= ping_storage_data_54 ^ i_input_data[564 % IN_WIDTH];
                685 / IN_WIDTH: ping_storage_data_54 <= ping_storage_data_54 ^ i_input_data[685 % IN_WIDTH];
                1084 / IN_WIDTH: ping_storage_data_54 <= ping_storage_data_54 ^ i_input_data[1084 % IN_WIDTH];
                default: ping_storage_data_54 <= ping_storage_data_54;
                endcase
            end else begin
                ping_storage_data_54 <= ping_storage_data_54;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                11 / IN_WIDTH: pong_storage_data_54 <= i_input_data[11 % IN_WIDTH];
                564 / IN_WIDTH: pong_storage_data_54 <= pong_storage_data_54 ^ i_input_data[564 % IN_WIDTH];
                685 / IN_WIDTH: pong_storage_data_54 <= pong_storage_data_54 ^ i_input_data[685 % IN_WIDTH];
                1084 / IN_WIDTH: pong_storage_data_54 <= pong_storage_data_54 ^ i_input_data[1084 % IN_WIDTH];
                default: pong_storage_data_54 <= pong_storage_data_54;
                endcase
            end
        end
    end
end

logic ping_storage_data_55;
logic pong_storage_data_55;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_55 <= 1'b0;
        pong_storage_data_55 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                12 / IN_WIDTH: ping_storage_data_55 <= i_input_data[12 % IN_WIDTH];
                565 / IN_WIDTH: ping_storage_data_55 <= ping_storage_data_55 ^ i_input_data[565 % IN_WIDTH];
                686 / IN_WIDTH: ping_storage_data_55 <= ping_storage_data_55 ^ i_input_data[686 % IN_WIDTH];
                1085 / IN_WIDTH: ping_storage_data_55 <= ping_storage_data_55 ^ i_input_data[1085 % IN_WIDTH];
                default: ping_storage_data_55 <= ping_storage_data_55;
                endcase
            end else begin
                ping_storage_data_55 <= ping_storage_data_55;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                12 / IN_WIDTH: pong_storage_data_55 <= i_input_data[12 % IN_WIDTH];
                565 / IN_WIDTH: pong_storage_data_55 <= pong_storage_data_55 ^ i_input_data[565 % IN_WIDTH];
                686 / IN_WIDTH: pong_storage_data_55 <= pong_storage_data_55 ^ i_input_data[686 % IN_WIDTH];
                1085 / IN_WIDTH: pong_storage_data_55 <= pong_storage_data_55 ^ i_input_data[1085 % IN_WIDTH];
                default: pong_storage_data_55 <= pong_storage_data_55;
                endcase
            end
        end
    end
end

logic ping_storage_data_56;
logic pong_storage_data_56;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_56 <= 1'b0;
        pong_storage_data_56 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                13 / IN_WIDTH: ping_storage_data_56 <= i_input_data[13 % IN_WIDTH];
                566 / IN_WIDTH: ping_storage_data_56 <= ping_storage_data_56 ^ i_input_data[566 % IN_WIDTH];
                687 / IN_WIDTH: ping_storage_data_56 <= ping_storage_data_56 ^ i_input_data[687 % IN_WIDTH];
                1086 / IN_WIDTH: ping_storage_data_56 <= ping_storage_data_56 ^ i_input_data[1086 % IN_WIDTH];
                default: ping_storage_data_56 <= ping_storage_data_56;
                endcase
            end else begin
                ping_storage_data_56 <= ping_storage_data_56;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                13 / IN_WIDTH: pong_storage_data_56 <= i_input_data[13 % IN_WIDTH];
                566 / IN_WIDTH: pong_storage_data_56 <= pong_storage_data_56 ^ i_input_data[566 % IN_WIDTH];
                687 / IN_WIDTH: pong_storage_data_56 <= pong_storage_data_56 ^ i_input_data[687 % IN_WIDTH];
                1086 / IN_WIDTH: pong_storage_data_56 <= pong_storage_data_56 ^ i_input_data[1086 % IN_WIDTH];
                default: pong_storage_data_56 <= pong_storage_data_56;
                endcase
            end
        end
    end
end

logic ping_storage_data_57;
logic pong_storage_data_57;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_57 <= 1'b0;
        pong_storage_data_57 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                14 / IN_WIDTH: ping_storage_data_57 <= i_input_data[14 % IN_WIDTH];
                567 / IN_WIDTH: ping_storage_data_57 <= ping_storage_data_57 ^ i_input_data[567 % IN_WIDTH];
                688 / IN_WIDTH: ping_storage_data_57 <= ping_storage_data_57 ^ i_input_data[688 % IN_WIDTH];
                1087 / IN_WIDTH: ping_storage_data_57 <= ping_storage_data_57 ^ i_input_data[1087 % IN_WIDTH];
                default: ping_storage_data_57 <= ping_storage_data_57;
                endcase
            end else begin
                ping_storage_data_57 <= ping_storage_data_57;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                14 / IN_WIDTH: pong_storage_data_57 <= i_input_data[14 % IN_WIDTH];
                567 / IN_WIDTH: pong_storage_data_57 <= pong_storage_data_57 ^ i_input_data[567 % IN_WIDTH];
                688 / IN_WIDTH: pong_storage_data_57 <= pong_storage_data_57 ^ i_input_data[688 % IN_WIDTH];
                1087 / IN_WIDTH: pong_storage_data_57 <= pong_storage_data_57 ^ i_input_data[1087 % IN_WIDTH];
                default: pong_storage_data_57 <= pong_storage_data_57;
                endcase
            end
        end
    end
end

logic ping_storage_data_58;
logic pong_storage_data_58;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_58 <= 1'b0;
        pong_storage_data_58 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                15 / IN_WIDTH: ping_storage_data_58 <= i_input_data[15 % IN_WIDTH];
                568 / IN_WIDTH: ping_storage_data_58 <= ping_storage_data_58 ^ i_input_data[568 % IN_WIDTH];
                689 / IN_WIDTH: ping_storage_data_58 <= ping_storage_data_58 ^ i_input_data[689 % IN_WIDTH];
                1088 / IN_WIDTH: ping_storage_data_58 <= ping_storage_data_58 ^ i_input_data[1088 % IN_WIDTH];
                default: ping_storage_data_58 <= ping_storage_data_58;
                endcase
            end else begin
                ping_storage_data_58 <= ping_storage_data_58;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                15 / IN_WIDTH: pong_storage_data_58 <= i_input_data[15 % IN_WIDTH];
                568 / IN_WIDTH: pong_storage_data_58 <= pong_storage_data_58 ^ i_input_data[568 % IN_WIDTH];
                689 / IN_WIDTH: pong_storage_data_58 <= pong_storage_data_58 ^ i_input_data[689 % IN_WIDTH];
                1088 / IN_WIDTH: pong_storage_data_58 <= pong_storage_data_58 ^ i_input_data[1088 % IN_WIDTH];
                default: pong_storage_data_58 <= pong_storage_data_58;
                endcase
            end
        end
    end
end

logic ping_storage_data_59;
logic pong_storage_data_59;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_59 <= 1'b0;
        pong_storage_data_59 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                16 / IN_WIDTH: ping_storage_data_59 <= i_input_data[16 % IN_WIDTH];
                569 / IN_WIDTH: ping_storage_data_59 <= ping_storage_data_59 ^ i_input_data[569 % IN_WIDTH];
                690 / IN_WIDTH: ping_storage_data_59 <= ping_storage_data_59 ^ i_input_data[690 % IN_WIDTH];
                1089 / IN_WIDTH: ping_storage_data_59 <= ping_storage_data_59 ^ i_input_data[1089 % IN_WIDTH];
                default: ping_storage_data_59 <= ping_storage_data_59;
                endcase
            end else begin
                ping_storage_data_59 <= ping_storage_data_59;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                16 / IN_WIDTH: pong_storage_data_59 <= i_input_data[16 % IN_WIDTH];
                569 / IN_WIDTH: pong_storage_data_59 <= pong_storage_data_59 ^ i_input_data[569 % IN_WIDTH];
                690 / IN_WIDTH: pong_storage_data_59 <= pong_storage_data_59 ^ i_input_data[690 % IN_WIDTH];
                1089 / IN_WIDTH: pong_storage_data_59 <= pong_storage_data_59 ^ i_input_data[1089 % IN_WIDTH];
                default: pong_storage_data_59 <= pong_storage_data_59;
                endcase
            end
        end
    end
end

logic ping_storage_data_60;
logic pong_storage_data_60;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_60 <= 1'b0;
        pong_storage_data_60 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                17 / IN_WIDTH: ping_storage_data_60 <= i_input_data[17 % IN_WIDTH];
                570 / IN_WIDTH: ping_storage_data_60 <= ping_storage_data_60 ^ i_input_data[570 % IN_WIDTH];
                691 / IN_WIDTH: ping_storage_data_60 <= ping_storage_data_60 ^ i_input_data[691 % IN_WIDTH];
                1090 / IN_WIDTH: ping_storage_data_60 <= ping_storage_data_60 ^ i_input_data[1090 % IN_WIDTH];
                default: ping_storage_data_60 <= ping_storage_data_60;
                endcase
            end else begin
                ping_storage_data_60 <= ping_storage_data_60;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                17 / IN_WIDTH: pong_storage_data_60 <= i_input_data[17 % IN_WIDTH];
                570 / IN_WIDTH: pong_storage_data_60 <= pong_storage_data_60 ^ i_input_data[570 % IN_WIDTH];
                691 / IN_WIDTH: pong_storage_data_60 <= pong_storage_data_60 ^ i_input_data[691 % IN_WIDTH];
                1090 / IN_WIDTH: pong_storage_data_60 <= pong_storage_data_60 ^ i_input_data[1090 % IN_WIDTH];
                default: pong_storage_data_60 <= pong_storage_data_60;
                endcase
            end
        end
    end
end

logic ping_storage_data_61;
logic pong_storage_data_61;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_61 <= 1'b0;
        pong_storage_data_61 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                18 / IN_WIDTH: ping_storage_data_61 <= i_input_data[18 % IN_WIDTH];
                571 / IN_WIDTH: ping_storage_data_61 <= ping_storage_data_61 ^ i_input_data[571 % IN_WIDTH];
                692 / IN_WIDTH: ping_storage_data_61 <= ping_storage_data_61 ^ i_input_data[692 % IN_WIDTH];
                1091 / IN_WIDTH: ping_storage_data_61 <= ping_storage_data_61 ^ i_input_data[1091 % IN_WIDTH];
                default: ping_storage_data_61 <= ping_storage_data_61;
                endcase
            end else begin
                ping_storage_data_61 <= ping_storage_data_61;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                18 / IN_WIDTH: pong_storage_data_61 <= i_input_data[18 % IN_WIDTH];
                571 / IN_WIDTH: pong_storage_data_61 <= pong_storage_data_61 ^ i_input_data[571 % IN_WIDTH];
                692 / IN_WIDTH: pong_storage_data_61 <= pong_storage_data_61 ^ i_input_data[692 % IN_WIDTH];
                1091 / IN_WIDTH: pong_storage_data_61 <= pong_storage_data_61 ^ i_input_data[1091 % IN_WIDTH];
                default: pong_storage_data_61 <= pong_storage_data_61;
                endcase
            end
        end
    end
end

logic ping_storage_data_62;
logic pong_storage_data_62;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_62 <= 1'b0;
        pong_storage_data_62 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                19 / IN_WIDTH: ping_storage_data_62 <= i_input_data[19 % IN_WIDTH];
                572 / IN_WIDTH: ping_storage_data_62 <= ping_storage_data_62 ^ i_input_data[572 % IN_WIDTH];
                693 / IN_WIDTH: ping_storage_data_62 <= ping_storage_data_62 ^ i_input_data[693 % IN_WIDTH];
                1092 / IN_WIDTH: ping_storage_data_62 <= ping_storage_data_62 ^ i_input_data[1092 % IN_WIDTH];
                default: ping_storage_data_62 <= ping_storage_data_62;
                endcase
            end else begin
                ping_storage_data_62 <= ping_storage_data_62;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                19 / IN_WIDTH: pong_storage_data_62 <= i_input_data[19 % IN_WIDTH];
                572 / IN_WIDTH: pong_storage_data_62 <= pong_storage_data_62 ^ i_input_data[572 % IN_WIDTH];
                693 / IN_WIDTH: pong_storage_data_62 <= pong_storage_data_62 ^ i_input_data[693 % IN_WIDTH];
                1092 / IN_WIDTH: pong_storage_data_62 <= pong_storage_data_62 ^ i_input_data[1092 % IN_WIDTH];
                default: pong_storage_data_62 <= pong_storage_data_62;
                endcase
            end
        end
    end
end

logic ping_storage_data_63;
logic pong_storage_data_63;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_63 <= 1'b0;
        pong_storage_data_63 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                20 / IN_WIDTH: ping_storage_data_63 <= i_input_data[20 % IN_WIDTH];
                573 / IN_WIDTH: ping_storage_data_63 <= ping_storage_data_63 ^ i_input_data[573 % IN_WIDTH];
                694 / IN_WIDTH: ping_storage_data_63 <= ping_storage_data_63 ^ i_input_data[694 % IN_WIDTH];
                1093 / IN_WIDTH: ping_storage_data_63 <= ping_storage_data_63 ^ i_input_data[1093 % IN_WIDTH];
                default: ping_storage_data_63 <= ping_storage_data_63;
                endcase
            end else begin
                ping_storage_data_63 <= ping_storage_data_63;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                20 / IN_WIDTH: pong_storage_data_63 <= i_input_data[20 % IN_WIDTH];
                573 / IN_WIDTH: pong_storage_data_63 <= pong_storage_data_63 ^ i_input_data[573 % IN_WIDTH];
                694 / IN_WIDTH: pong_storage_data_63 <= pong_storage_data_63 ^ i_input_data[694 % IN_WIDTH];
                1093 / IN_WIDTH: pong_storage_data_63 <= pong_storage_data_63 ^ i_input_data[1093 % IN_WIDTH];
                default: pong_storage_data_63 <= pong_storage_data_63;
                endcase
            end
        end
    end
end

logic ping_storage_data_64;
logic pong_storage_data_64;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_64 <= 1'b0;
        pong_storage_data_64 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                21 / IN_WIDTH: ping_storage_data_64 <= i_input_data[21 % IN_WIDTH];
                574 / IN_WIDTH: ping_storage_data_64 <= ping_storage_data_64 ^ i_input_data[574 % IN_WIDTH];
                695 / IN_WIDTH: ping_storage_data_64 <= ping_storage_data_64 ^ i_input_data[695 % IN_WIDTH];
                1094 / IN_WIDTH: ping_storage_data_64 <= ping_storage_data_64 ^ i_input_data[1094 % IN_WIDTH];
                default: ping_storage_data_64 <= ping_storage_data_64;
                endcase
            end else begin
                ping_storage_data_64 <= ping_storage_data_64;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                21 / IN_WIDTH: pong_storage_data_64 <= i_input_data[21 % IN_WIDTH];
                574 / IN_WIDTH: pong_storage_data_64 <= pong_storage_data_64 ^ i_input_data[574 % IN_WIDTH];
                695 / IN_WIDTH: pong_storage_data_64 <= pong_storage_data_64 ^ i_input_data[695 % IN_WIDTH];
                1094 / IN_WIDTH: pong_storage_data_64 <= pong_storage_data_64 ^ i_input_data[1094 % IN_WIDTH];
                default: pong_storage_data_64 <= pong_storage_data_64;
                endcase
            end
        end
    end
end

logic ping_storage_data_65;
logic pong_storage_data_65;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_65 <= 1'b0;
        pong_storage_data_65 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                22 / IN_WIDTH: ping_storage_data_65 <= i_input_data[22 % IN_WIDTH];
                575 / IN_WIDTH: ping_storage_data_65 <= ping_storage_data_65 ^ i_input_data[575 % IN_WIDTH];
                696 / IN_WIDTH: ping_storage_data_65 <= ping_storage_data_65 ^ i_input_data[696 % IN_WIDTH];
                1095 / IN_WIDTH: ping_storage_data_65 <= ping_storage_data_65 ^ i_input_data[1095 % IN_WIDTH];
                default: ping_storage_data_65 <= ping_storage_data_65;
                endcase
            end else begin
                ping_storage_data_65 <= ping_storage_data_65;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                22 / IN_WIDTH: pong_storage_data_65 <= i_input_data[22 % IN_WIDTH];
                575 / IN_WIDTH: pong_storage_data_65 <= pong_storage_data_65 ^ i_input_data[575 % IN_WIDTH];
                696 / IN_WIDTH: pong_storage_data_65 <= pong_storage_data_65 ^ i_input_data[696 % IN_WIDTH];
                1095 / IN_WIDTH: pong_storage_data_65 <= pong_storage_data_65 ^ i_input_data[1095 % IN_WIDTH];
                default: pong_storage_data_65 <= pong_storage_data_65;
                endcase
            end
        end
    end
end

logic ping_storage_data_66;
logic pong_storage_data_66;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_66 <= 1'b0;
        pong_storage_data_66 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                23 / IN_WIDTH: ping_storage_data_66 <= i_input_data[23 % IN_WIDTH];
                480 / IN_WIDTH: ping_storage_data_66 <= ping_storage_data_66 ^ i_input_data[480 % IN_WIDTH];
                697 / IN_WIDTH: ping_storage_data_66 <= ping_storage_data_66 ^ i_input_data[697 % IN_WIDTH];
                1096 / IN_WIDTH: ping_storage_data_66 <= ping_storage_data_66 ^ i_input_data[1096 % IN_WIDTH];
                default: ping_storage_data_66 <= ping_storage_data_66;
                endcase
            end else begin
                ping_storage_data_66 <= ping_storage_data_66;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                23 / IN_WIDTH: pong_storage_data_66 <= i_input_data[23 % IN_WIDTH];
                480 / IN_WIDTH: pong_storage_data_66 <= pong_storage_data_66 ^ i_input_data[480 % IN_WIDTH];
                697 / IN_WIDTH: pong_storage_data_66 <= pong_storage_data_66 ^ i_input_data[697 % IN_WIDTH];
                1096 / IN_WIDTH: pong_storage_data_66 <= pong_storage_data_66 ^ i_input_data[1096 % IN_WIDTH];
                default: pong_storage_data_66 <= pong_storage_data_66;
                endcase
            end
        end
    end
end

logic ping_storage_data_67;
logic pong_storage_data_67;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_67 <= 1'b0;
        pong_storage_data_67 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                24 / IN_WIDTH: ping_storage_data_67 <= i_input_data[24 % IN_WIDTH];
                481 / IN_WIDTH: ping_storage_data_67 <= ping_storage_data_67 ^ i_input_data[481 % IN_WIDTH];
                698 / IN_WIDTH: ping_storage_data_67 <= ping_storage_data_67 ^ i_input_data[698 % IN_WIDTH];
                1097 / IN_WIDTH: ping_storage_data_67 <= ping_storage_data_67 ^ i_input_data[1097 % IN_WIDTH];
                default: ping_storage_data_67 <= ping_storage_data_67;
                endcase
            end else begin
                ping_storage_data_67 <= ping_storage_data_67;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                24 / IN_WIDTH: pong_storage_data_67 <= i_input_data[24 % IN_WIDTH];
                481 / IN_WIDTH: pong_storage_data_67 <= pong_storage_data_67 ^ i_input_data[481 % IN_WIDTH];
                698 / IN_WIDTH: pong_storage_data_67 <= pong_storage_data_67 ^ i_input_data[698 % IN_WIDTH];
                1097 / IN_WIDTH: pong_storage_data_67 <= pong_storage_data_67 ^ i_input_data[1097 % IN_WIDTH];
                default: pong_storage_data_67 <= pong_storage_data_67;
                endcase
            end
        end
    end
end

logic ping_storage_data_68;
logic pong_storage_data_68;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_68 <= 1'b0;
        pong_storage_data_68 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                25 / IN_WIDTH: ping_storage_data_68 <= i_input_data[25 % IN_WIDTH];
                482 / IN_WIDTH: ping_storage_data_68 <= ping_storage_data_68 ^ i_input_data[482 % IN_WIDTH];
                699 / IN_WIDTH: ping_storage_data_68 <= ping_storage_data_68 ^ i_input_data[699 % IN_WIDTH];
                1098 / IN_WIDTH: ping_storage_data_68 <= ping_storage_data_68 ^ i_input_data[1098 % IN_WIDTH];
                default: ping_storage_data_68 <= ping_storage_data_68;
                endcase
            end else begin
                ping_storage_data_68 <= ping_storage_data_68;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                25 / IN_WIDTH: pong_storage_data_68 <= i_input_data[25 % IN_WIDTH];
                482 / IN_WIDTH: pong_storage_data_68 <= pong_storage_data_68 ^ i_input_data[482 % IN_WIDTH];
                699 / IN_WIDTH: pong_storage_data_68 <= pong_storage_data_68 ^ i_input_data[699 % IN_WIDTH];
                1098 / IN_WIDTH: pong_storage_data_68 <= pong_storage_data_68 ^ i_input_data[1098 % IN_WIDTH];
                default: pong_storage_data_68 <= pong_storage_data_68;
                endcase
            end
        end
    end
end

logic ping_storage_data_69;
logic pong_storage_data_69;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_69 <= 1'b0;
        pong_storage_data_69 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                26 / IN_WIDTH: ping_storage_data_69 <= i_input_data[26 % IN_WIDTH];
                483 / IN_WIDTH: ping_storage_data_69 <= ping_storage_data_69 ^ i_input_data[483 % IN_WIDTH];
                700 / IN_WIDTH: ping_storage_data_69 <= ping_storage_data_69 ^ i_input_data[700 % IN_WIDTH];
                1099 / IN_WIDTH: ping_storage_data_69 <= ping_storage_data_69 ^ i_input_data[1099 % IN_WIDTH];
                default: ping_storage_data_69 <= ping_storage_data_69;
                endcase
            end else begin
                ping_storage_data_69 <= ping_storage_data_69;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                26 / IN_WIDTH: pong_storage_data_69 <= i_input_data[26 % IN_WIDTH];
                483 / IN_WIDTH: pong_storage_data_69 <= pong_storage_data_69 ^ i_input_data[483 % IN_WIDTH];
                700 / IN_WIDTH: pong_storage_data_69 <= pong_storage_data_69 ^ i_input_data[700 % IN_WIDTH];
                1099 / IN_WIDTH: pong_storage_data_69 <= pong_storage_data_69 ^ i_input_data[1099 % IN_WIDTH];
                default: pong_storage_data_69 <= pong_storage_data_69;
                endcase
            end
        end
    end
end

logic ping_storage_data_70;
logic pong_storage_data_70;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_70 <= 1'b0;
        pong_storage_data_70 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                27 / IN_WIDTH: ping_storage_data_70 <= i_input_data[27 % IN_WIDTH];
                484 / IN_WIDTH: ping_storage_data_70 <= ping_storage_data_70 ^ i_input_data[484 % IN_WIDTH];
                701 / IN_WIDTH: ping_storage_data_70 <= ping_storage_data_70 ^ i_input_data[701 % IN_WIDTH];
                1100 / IN_WIDTH: ping_storage_data_70 <= ping_storage_data_70 ^ i_input_data[1100 % IN_WIDTH];
                default: ping_storage_data_70 <= ping_storage_data_70;
                endcase
            end else begin
                ping_storage_data_70 <= ping_storage_data_70;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                27 / IN_WIDTH: pong_storage_data_70 <= i_input_data[27 % IN_WIDTH];
                484 / IN_WIDTH: pong_storage_data_70 <= pong_storage_data_70 ^ i_input_data[484 % IN_WIDTH];
                701 / IN_WIDTH: pong_storage_data_70 <= pong_storage_data_70 ^ i_input_data[701 % IN_WIDTH];
                1100 / IN_WIDTH: pong_storage_data_70 <= pong_storage_data_70 ^ i_input_data[1100 % IN_WIDTH];
                default: pong_storage_data_70 <= pong_storage_data_70;
                endcase
            end
        end
    end
end

logic ping_storage_data_71;
logic pong_storage_data_71;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_71 <= 1'b0;
        pong_storage_data_71 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                28 / IN_WIDTH: ping_storage_data_71 <= i_input_data[28 % IN_WIDTH];
                485 / IN_WIDTH: ping_storage_data_71 <= ping_storage_data_71 ^ i_input_data[485 % IN_WIDTH];
                702 / IN_WIDTH: ping_storage_data_71 <= ping_storage_data_71 ^ i_input_data[702 % IN_WIDTH];
                1101 / IN_WIDTH: ping_storage_data_71 <= ping_storage_data_71 ^ i_input_data[1101 % IN_WIDTH];
                default: ping_storage_data_71 <= ping_storage_data_71;
                endcase
            end else begin
                ping_storage_data_71 <= ping_storage_data_71;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                28 / IN_WIDTH: pong_storage_data_71 <= i_input_data[28 % IN_WIDTH];
                485 / IN_WIDTH: pong_storage_data_71 <= pong_storage_data_71 ^ i_input_data[485 % IN_WIDTH];
                702 / IN_WIDTH: pong_storage_data_71 <= pong_storage_data_71 ^ i_input_data[702 % IN_WIDTH];
                1101 / IN_WIDTH: pong_storage_data_71 <= pong_storage_data_71 ^ i_input_data[1101 % IN_WIDTH];
                default: pong_storage_data_71 <= pong_storage_data_71;
                endcase
            end
        end
    end
end

logic ping_storage_data_72;
logic pong_storage_data_72;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_72 <= 1'b0;
        pong_storage_data_72 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                29 / IN_WIDTH: ping_storage_data_72 <= i_input_data[29 % IN_WIDTH];
                486 / IN_WIDTH: ping_storage_data_72 <= ping_storage_data_72 ^ i_input_data[486 % IN_WIDTH];
                703 / IN_WIDTH: ping_storage_data_72 <= ping_storage_data_72 ^ i_input_data[703 % IN_WIDTH];
                1102 / IN_WIDTH: ping_storage_data_72 <= ping_storage_data_72 ^ i_input_data[1102 % IN_WIDTH];
                default: ping_storage_data_72 <= ping_storage_data_72;
                endcase
            end else begin
                ping_storage_data_72 <= ping_storage_data_72;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                29 / IN_WIDTH: pong_storage_data_72 <= i_input_data[29 % IN_WIDTH];
                486 / IN_WIDTH: pong_storage_data_72 <= pong_storage_data_72 ^ i_input_data[486 % IN_WIDTH];
                703 / IN_WIDTH: pong_storage_data_72 <= pong_storage_data_72 ^ i_input_data[703 % IN_WIDTH];
                1102 / IN_WIDTH: pong_storage_data_72 <= pong_storage_data_72 ^ i_input_data[1102 % IN_WIDTH];
                default: pong_storage_data_72 <= pong_storage_data_72;
                endcase
            end
        end
    end
end

logic ping_storage_data_73;
logic pong_storage_data_73;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_73 <= 1'b0;
        pong_storage_data_73 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                30 / IN_WIDTH: ping_storage_data_73 <= i_input_data[30 % IN_WIDTH];
                487 / IN_WIDTH: ping_storage_data_73 <= ping_storage_data_73 ^ i_input_data[487 % IN_WIDTH];
                704 / IN_WIDTH: ping_storage_data_73 <= ping_storage_data_73 ^ i_input_data[704 % IN_WIDTH];
                1103 / IN_WIDTH: ping_storage_data_73 <= ping_storage_data_73 ^ i_input_data[1103 % IN_WIDTH];
                default: ping_storage_data_73 <= ping_storage_data_73;
                endcase
            end else begin
                ping_storage_data_73 <= ping_storage_data_73;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                30 / IN_WIDTH: pong_storage_data_73 <= i_input_data[30 % IN_WIDTH];
                487 / IN_WIDTH: pong_storage_data_73 <= pong_storage_data_73 ^ i_input_data[487 % IN_WIDTH];
                704 / IN_WIDTH: pong_storage_data_73 <= pong_storage_data_73 ^ i_input_data[704 % IN_WIDTH];
                1103 / IN_WIDTH: pong_storage_data_73 <= pong_storage_data_73 ^ i_input_data[1103 % IN_WIDTH];
                default: pong_storage_data_73 <= pong_storage_data_73;
                endcase
            end
        end
    end
end

logic ping_storage_data_74;
logic pong_storage_data_74;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_74 <= 1'b0;
        pong_storage_data_74 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                31 / IN_WIDTH: ping_storage_data_74 <= i_input_data[31 % IN_WIDTH];
                488 / IN_WIDTH: ping_storage_data_74 <= ping_storage_data_74 ^ i_input_data[488 % IN_WIDTH];
                705 / IN_WIDTH: ping_storage_data_74 <= ping_storage_data_74 ^ i_input_data[705 % IN_WIDTH];
                1104 / IN_WIDTH: ping_storage_data_74 <= ping_storage_data_74 ^ i_input_data[1104 % IN_WIDTH];
                default: ping_storage_data_74 <= ping_storage_data_74;
                endcase
            end else begin
                ping_storage_data_74 <= ping_storage_data_74;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                31 / IN_WIDTH: pong_storage_data_74 <= i_input_data[31 % IN_WIDTH];
                488 / IN_WIDTH: pong_storage_data_74 <= pong_storage_data_74 ^ i_input_data[488 % IN_WIDTH];
                705 / IN_WIDTH: pong_storage_data_74 <= pong_storage_data_74 ^ i_input_data[705 % IN_WIDTH];
                1104 / IN_WIDTH: pong_storage_data_74 <= pong_storage_data_74 ^ i_input_data[1104 % IN_WIDTH];
                default: pong_storage_data_74 <= pong_storage_data_74;
                endcase
            end
        end
    end
end

logic ping_storage_data_75;
logic pong_storage_data_75;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_75 <= 1'b0;
        pong_storage_data_75 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                32 / IN_WIDTH: ping_storage_data_75 <= i_input_data[32 % IN_WIDTH];
                489 / IN_WIDTH: ping_storage_data_75 <= ping_storage_data_75 ^ i_input_data[489 % IN_WIDTH];
                706 / IN_WIDTH: ping_storage_data_75 <= ping_storage_data_75 ^ i_input_data[706 % IN_WIDTH];
                1105 / IN_WIDTH: ping_storage_data_75 <= ping_storage_data_75 ^ i_input_data[1105 % IN_WIDTH];
                default: ping_storage_data_75 <= ping_storage_data_75;
                endcase
            end else begin
                ping_storage_data_75 <= ping_storage_data_75;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                32 / IN_WIDTH: pong_storage_data_75 <= i_input_data[32 % IN_WIDTH];
                489 / IN_WIDTH: pong_storage_data_75 <= pong_storage_data_75 ^ i_input_data[489 % IN_WIDTH];
                706 / IN_WIDTH: pong_storage_data_75 <= pong_storage_data_75 ^ i_input_data[706 % IN_WIDTH];
                1105 / IN_WIDTH: pong_storage_data_75 <= pong_storage_data_75 ^ i_input_data[1105 % IN_WIDTH];
                default: pong_storage_data_75 <= pong_storage_data_75;
                endcase
            end
        end
    end
end

logic ping_storage_data_76;
logic pong_storage_data_76;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_76 <= 1'b0;
        pong_storage_data_76 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                33 / IN_WIDTH: ping_storage_data_76 <= i_input_data[33 % IN_WIDTH];
                490 / IN_WIDTH: ping_storage_data_76 <= ping_storage_data_76 ^ i_input_data[490 % IN_WIDTH];
                707 / IN_WIDTH: ping_storage_data_76 <= ping_storage_data_76 ^ i_input_data[707 % IN_WIDTH];
                1106 / IN_WIDTH: ping_storage_data_76 <= ping_storage_data_76 ^ i_input_data[1106 % IN_WIDTH];
                default: ping_storage_data_76 <= ping_storage_data_76;
                endcase
            end else begin
                ping_storage_data_76 <= ping_storage_data_76;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                33 / IN_WIDTH: pong_storage_data_76 <= i_input_data[33 % IN_WIDTH];
                490 / IN_WIDTH: pong_storage_data_76 <= pong_storage_data_76 ^ i_input_data[490 % IN_WIDTH];
                707 / IN_WIDTH: pong_storage_data_76 <= pong_storage_data_76 ^ i_input_data[707 % IN_WIDTH];
                1106 / IN_WIDTH: pong_storage_data_76 <= pong_storage_data_76 ^ i_input_data[1106 % IN_WIDTH];
                default: pong_storage_data_76 <= pong_storage_data_76;
                endcase
            end
        end
    end
end

logic ping_storage_data_77;
logic pong_storage_data_77;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_77 <= 1'b0;
        pong_storage_data_77 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                34 / IN_WIDTH: ping_storage_data_77 <= i_input_data[34 % IN_WIDTH];
                491 / IN_WIDTH: ping_storage_data_77 <= ping_storage_data_77 ^ i_input_data[491 % IN_WIDTH];
                708 / IN_WIDTH: ping_storage_data_77 <= ping_storage_data_77 ^ i_input_data[708 % IN_WIDTH];
                1107 / IN_WIDTH: ping_storage_data_77 <= ping_storage_data_77 ^ i_input_data[1107 % IN_WIDTH];
                default: ping_storage_data_77 <= ping_storage_data_77;
                endcase
            end else begin
                ping_storage_data_77 <= ping_storage_data_77;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                34 / IN_WIDTH: pong_storage_data_77 <= i_input_data[34 % IN_WIDTH];
                491 / IN_WIDTH: pong_storage_data_77 <= pong_storage_data_77 ^ i_input_data[491 % IN_WIDTH];
                708 / IN_WIDTH: pong_storage_data_77 <= pong_storage_data_77 ^ i_input_data[708 % IN_WIDTH];
                1107 / IN_WIDTH: pong_storage_data_77 <= pong_storage_data_77 ^ i_input_data[1107 % IN_WIDTH];
                default: pong_storage_data_77 <= pong_storage_data_77;
                endcase
            end
        end
    end
end

logic ping_storage_data_78;
logic pong_storage_data_78;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_78 <= 1'b0;
        pong_storage_data_78 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                35 / IN_WIDTH: ping_storage_data_78 <= i_input_data[35 % IN_WIDTH];
                492 / IN_WIDTH: ping_storage_data_78 <= ping_storage_data_78 ^ i_input_data[492 % IN_WIDTH];
                709 / IN_WIDTH: ping_storage_data_78 <= ping_storage_data_78 ^ i_input_data[709 % IN_WIDTH];
                1108 / IN_WIDTH: ping_storage_data_78 <= ping_storage_data_78 ^ i_input_data[1108 % IN_WIDTH];
                default: ping_storage_data_78 <= ping_storage_data_78;
                endcase
            end else begin
                ping_storage_data_78 <= ping_storage_data_78;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                35 / IN_WIDTH: pong_storage_data_78 <= i_input_data[35 % IN_WIDTH];
                492 / IN_WIDTH: pong_storage_data_78 <= pong_storage_data_78 ^ i_input_data[492 % IN_WIDTH];
                709 / IN_WIDTH: pong_storage_data_78 <= pong_storage_data_78 ^ i_input_data[709 % IN_WIDTH];
                1108 / IN_WIDTH: pong_storage_data_78 <= pong_storage_data_78 ^ i_input_data[1108 % IN_WIDTH];
                default: pong_storage_data_78 <= pong_storage_data_78;
                endcase
            end
        end
    end
end

logic ping_storage_data_79;
logic pong_storage_data_79;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_79 <= 1'b0;
        pong_storage_data_79 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                36 / IN_WIDTH: ping_storage_data_79 <= i_input_data[36 % IN_WIDTH];
                493 / IN_WIDTH: ping_storage_data_79 <= ping_storage_data_79 ^ i_input_data[493 % IN_WIDTH];
                710 / IN_WIDTH: ping_storage_data_79 <= ping_storage_data_79 ^ i_input_data[710 % IN_WIDTH];
                1109 / IN_WIDTH: ping_storage_data_79 <= ping_storage_data_79 ^ i_input_data[1109 % IN_WIDTH];
                default: ping_storage_data_79 <= ping_storage_data_79;
                endcase
            end else begin
                ping_storage_data_79 <= ping_storage_data_79;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                36 / IN_WIDTH: pong_storage_data_79 <= i_input_data[36 % IN_WIDTH];
                493 / IN_WIDTH: pong_storage_data_79 <= pong_storage_data_79 ^ i_input_data[493 % IN_WIDTH];
                710 / IN_WIDTH: pong_storage_data_79 <= pong_storage_data_79 ^ i_input_data[710 % IN_WIDTH];
                1109 / IN_WIDTH: pong_storage_data_79 <= pong_storage_data_79 ^ i_input_data[1109 % IN_WIDTH];
                default: pong_storage_data_79 <= pong_storage_data_79;
                endcase
            end
        end
    end
end

logic ping_storage_data_80;
logic pong_storage_data_80;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_80 <= 1'b0;
        pong_storage_data_80 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                37 / IN_WIDTH: ping_storage_data_80 <= i_input_data[37 % IN_WIDTH];
                494 / IN_WIDTH: ping_storage_data_80 <= ping_storage_data_80 ^ i_input_data[494 % IN_WIDTH];
                711 / IN_WIDTH: ping_storage_data_80 <= ping_storage_data_80 ^ i_input_data[711 % IN_WIDTH];
                1110 / IN_WIDTH: ping_storage_data_80 <= ping_storage_data_80 ^ i_input_data[1110 % IN_WIDTH];
                default: ping_storage_data_80 <= ping_storage_data_80;
                endcase
            end else begin
                ping_storage_data_80 <= ping_storage_data_80;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                37 / IN_WIDTH: pong_storage_data_80 <= i_input_data[37 % IN_WIDTH];
                494 / IN_WIDTH: pong_storage_data_80 <= pong_storage_data_80 ^ i_input_data[494 % IN_WIDTH];
                711 / IN_WIDTH: pong_storage_data_80 <= pong_storage_data_80 ^ i_input_data[711 % IN_WIDTH];
                1110 / IN_WIDTH: pong_storage_data_80 <= pong_storage_data_80 ^ i_input_data[1110 % IN_WIDTH];
                default: pong_storage_data_80 <= pong_storage_data_80;
                endcase
            end
        end
    end
end

logic ping_storage_data_81;
logic pong_storage_data_81;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_81 <= 1'b0;
        pong_storage_data_81 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                38 / IN_WIDTH: ping_storage_data_81 <= i_input_data[38 % IN_WIDTH];
                495 / IN_WIDTH: ping_storage_data_81 <= ping_storage_data_81 ^ i_input_data[495 % IN_WIDTH];
                712 / IN_WIDTH: ping_storage_data_81 <= ping_storage_data_81 ^ i_input_data[712 % IN_WIDTH];
                1111 / IN_WIDTH: ping_storage_data_81 <= ping_storage_data_81 ^ i_input_data[1111 % IN_WIDTH];
                default: ping_storage_data_81 <= ping_storage_data_81;
                endcase
            end else begin
                ping_storage_data_81 <= ping_storage_data_81;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                38 / IN_WIDTH: pong_storage_data_81 <= i_input_data[38 % IN_WIDTH];
                495 / IN_WIDTH: pong_storage_data_81 <= pong_storage_data_81 ^ i_input_data[495 % IN_WIDTH];
                712 / IN_WIDTH: pong_storage_data_81 <= pong_storage_data_81 ^ i_input_data[712 % IN_WIDTH];
                1111 / IN_WIDTH: pong_storage_data_81 <= pong_storage_data_81 ^ i_input_data[1111 % IN_WIDTH];
                default: pong_storage_data_81 <= pong_storage_data_81;
                endcase
            end
        end
    end
end

logic ping_storage_data_82;
logic pong_storage_data_82;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_82 <= 1'b0;
        pong_storage_data_82 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                39 / IN_WIDTH: ping_storage_data_82 <= i_input_data[39 % IN_WIDTH];
                496 / IN_WIDTH: ping_storage_data_82 <= ping_storage_data_82 ^ i_input_data[496 % IN_WIDTH];
                713 / IN_WIDTH: ping_storage_data_82 <= ping_storage_data_82 ^ i_input_data[713 % IN_WIDTH];
                1112 / IN_WIDTH: ping_storage_data_82 <= ping_storage_data_82 ^ i_input_data[1112 % IN_WIDTH];
                default: ping_storage_data_82 <= ping_storage_data_82;
                endcase
            end else begin
                ping_storage_data_82 <= ping_storage_data_82;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                39 / IN_WIDTH: pong_storage_data_82 <= i_input_data[39 % IN_WIDTH];
                496 / IN_WIDTH: pong_storage_data_82 <= pong_storage_data_82 ^ i_input_data[496 % IN_WIDTH];
                713 / IN_WIDTH: pong_storage_data_82 <= pong_storage_data_82 ^ i_input_data[713 % IN_WIDTH];
                1112 / IN_WIDTH: pong_storage_data_82 <= pong_storage_data_82 ^ i_input_data[1112 % IN_WIDTH];
                default: pong_storage_data_82 <= pong_storage_data_82;
                endcase
            end
        end
    end
end

logic ping_storage_data_83;
logic pong_storage_data_83;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_83 <= 1'b0;
        pong_storage_data_83 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                40 / IN_WIDTH: ping_storage_data_83 <= i_input_data[40 % IN_WIDTH];
                497 / IN_WIDTH: ping_storage_data_83 <= ping_storage_data_83 ^ i_input_data[497 % IN_WIDTH];
                714 / IN_WIDTH: ping_storage_data_83 <= ping_storage_data_83 ^ i_input_data[714 % IN_WIDTH];
                1113 / IN_WIDTH: ping_storage_data_83 <= ping_storage_data_83 ^ i_input_data[1113 % IN_WIDTH];
                default: ping_storage_data_83 <= ping_storage_data_83;
                endcase
            end else begin
                ping_storage_data_83 <= ping_storage_data_83;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                40 / IN_WIDTH: pong_storage_data_83 <= i_input_data[40 % IN_WIDTH];
                497 / IN_WIDTH: pong_storage_data_83 <= pong_storage_data_83 ^ i_input_data[497 % IN_WIDTH];
                714 / IN_WIDTH: pong_storage_data_83 <= pong_storage_data_83 ^ i_input_data[714 % IN_WIDTH];
                1113 / IN_WIDTH: pong_storage_data_83 <= pong_storage_data_83 ^ i_input_data[1113 % IN_WIDTH];
                default: pong_storage_data_83 <= pong_storage_data_83;
                endcase
            end
        end
    end
end

logic ping_storage_data_84;
logic pong_storage_data_84;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_84 <= 1'b0;
        pong_storage_data_84 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                41 / IN_WIDTH: ping_storage_data_84 <= i_input_data[41 % IN_WIDTH];
                498 / IN_WIDTH: ping_storage_data_84 <= ping_storage_data_84 ^ i_input_data[498 % IN_WIDTH];
                715 / IN_WIDTH: ping_storage_data_84 <= ping_storage_data_84 ^ i_input_data[715 % IN_WIDTH];
                1114 / IN_WIDTH: ping_storage_data_84 <= ping_storage_data_84 ^ i_input_data[1114 % IN_WIDTH];
                default: ping_storage_data_84 <= ping_storage_data_84;
                endcase
            end else begin
                ping_storage_data_84 <= ping_storage_data_84;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                41 / IN_WIDTH: pong_storage_data_84 <= i_input_data[41 % IN_WIDTH];
                498 / IN_WIDTH: pong_storage_data_84 <= pong_storage_data_84 ^ i_input_data[498 % IN_WIDTH];
                715 / IN_WIDTH: pong_storage_data_84 <= pong_storage_data_84 ^ i_input_data[715 % IN_WIDTH];
                1114 / IN_WIDTH: pong_storage_data_84 <= pong_storage_data_84 ^ i_input_data[1114 % IN_WIDTH];
                default: pong_storage_data_84 <= pong_storage_data_84;
                endcase
            end
        end
    end
end

logic ping_storage_data_85;
logic pong_storage_data_85;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_85 <= 1'b0;
        pong_storage_data_85 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                42 / IN_WIDTH: ping_storage_data_85 <= i_input_data[42 % IN_WIDTH];
                499 / IN_WIDTH: ping_storage_data_85 <= ping_storage_data_85 ^ i_input_data[499 % IN_WIDTH];
                716 / IN_WIDTH: ping_storage_data_85 <= ping_storage_data_85 ^ i_input_data[716 % IN_WIDTH];
                1115 / IN_WIDTH: ping_storage_data_85 <= ping_storage_data_85 ^ i_input_data[1115 % IN_WIDTH];
                default: ping_storage_data_85 <= ping_storage_data_85;
                endcase
            end else begin
                ping_storage_data_85 <= ping_storage_data_85;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                42 / IN_WIDTH: pong_storage_data_85 <= i_input_data[42 % IN_WIDTH];
                499 / IN_WIDTH: pong_storage_data_85 <= pong_storage_data_85 ^ i_input_data[499 % IN_WIDTH];
                716 / IN_WIDTH: pong_storage_data_85 <= pong_storage_data_85 ^ i_input_data[716 % IN_WIDTH];
                1115 / IN_WIDTH: pong_storage_data_85 <= pong_storage_data_85 ^ i_input_data[1115 % IN_WIDTH];
                default: pong_storage_data_85 <= pong_storage_data_85;
                endcase
            end
        end
    end
end

logic ping_storage_data_86;
logic pong_storage_data_86;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_86 <= 1'b0;
        pong_storage_data_86 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                43 / IN_WIDTH: ping_storage_data_86 <= i_input_data[43 % IN_WIDTH];
                500 / IN_WIDTH: ping_storage_data_86 <= ping_storage_data_86 ^ i_input_data[500 % IN_WIDTH];
                717 / IN_WIDTH: ping_storage_data_86 <= ping_storage_data_86 ^ i_input_data[717 % IN_WIDTH];
                1116 / IN_WIDTH: ping_storage_data_86 <= ping_storage_data_86 ^ i_input_data[1116 % IN_WIDTH];
                default: ping_storage_data_86 <= ping_storage_data_86;
                endcase
            end else begin
                ping_storage_data_86 <= ping_storage_data_86;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                43 / IN_WIDTH: pong_storage_data_86 <= i_input_data[43 % IN_WIDTH];
                500 / IN_WIDTH: pong_storage_data_86 <= pong_storage_data_86 ^ i_input_data[500 % IN_WIDTH];
                717 / IN_WIDTH: pong_storage_data_86 <= pong_storage_data_86 ^ i_input_data[717 % IN_WIDTH];
                1116 / IN_WIDTH: pong_storage_data_86 <= pong_storage_data_86 ^ i_input_data[1116 % IN_WIDTH];
                default: pong_storage_data_86 <= pong_storage_data_86;
                endcase
            end
        end
    end
end

logic ping_storage_data_87;
logic pong_storage_data_87;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_87 <= 1'b0;
        pong_storage_data_87 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                44 / IN_WIDTH: ping_storage_data_87 <= i_input_data[44 % IN_WIDTH];
                501 / IN_WIDTH: ping_storage_data_87 <= ping_storage_data_87 ^ i_input_data[501 % IN_WIDTH];
                718 / IN_WIDTH: ping_storage_data_87 <= ping_storage_data_87 ^ i_input_data[718 % IN_WIDTH];
                1117 / IN_WIDTH: ping_storage_data_87 <= ping_storage_data_87 ^ i_input_data[1117 % IN_WIDTH];
                default: ping_storage_data_87 <= ping_storage_data_87;
                endcase
            end else begin
                ping_storage_data_87 <= ping_storage_data_87;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                44 / IN_WIDTH: pong_storage_data_87 <= i_input_data[44 % IN_WIDTH];
                501 / IN_WIDTH: pong_storage_data_87 <= pong_storage_data_87 ^ i_input_data[501 % IN_WIDTH];
                718 / IN_WIDTH: pong_storage_data_87 <= pong_storage_data_87 ^ i_input_data[718 % IN_WIDTH];
                1117 / IN_WIDTH: pong_storage_data_87 <= pong_storage_data_87 ^ i_input_data[1117 % IN_WIDTH];
                default: pong_storage_data_87 <= pong_storage_data_87;
                endcase
            end
        end
    end
end

logic ping_storage_data_88;
logic pong_storage_data_88;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_88 <= 1'b0;
        pong_storage_data_88 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                45 / IN_WIDTH: ping_storage_data_88 <= i_input_data[45 % IN_WIDTH];
                502 / IN_WIDTH: ping_storage_data_88 <= ping_storage_data_88 ^ i_input_data[502 % IN_WIDTH];
                719 / IN_WIDTH: ping_storage_data_88 <= ping_storage_data_88 ^ i_input_data[719 % IN_WIDTH];
                1118 / IN_WIDTH: ping_storage_data_88 <= ping_storage_data_88 ^ i_input_data[1118 % IN_WIDTH];
                default: ping_storage_data_88 <= ping_storage_data_88;
                endcase
            end else begin
                ping_storage_data_88 <= ping_storage_data_88;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                45 / IN_WIDTH: pong_storage_data_88 <= i_input_data[45 % IN_WIDTH];
                502 / IN_WIDTH: pong_storage_data_88 <= pong_storage_data_88 ^ i_input_data[502 % IN_WIDTH];
                719 / IN_WIDTH: pong_storage_data_88 <= pong_storage_data_88 ^ i_input_data[719 % IN_WIDTH];
                1118 / IN_WIDTH: pong_storage_data_88 <= pong_storage_data_88 ^ i_input_data[1118 % IN_WIDTH];
                default: pong_storage_data_88 <= pong_storage_data_88;
                endcase
            end
        end
    end
end

logic ping_storage_data_89;
logic pong_storage_data_89;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_89 <= 1'b0;
        pong_storage_data_89 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                46 / IN_WIDTH: ping_storage_data_89 <= i_input_data[46 % IN_WIDTH];
                503 / IN_WIDTH: ping_storage_data_89 <= ping_storage_data_89 ^ i_input_data[503 % IN_WIDTH];
                720 / IN_WIDTH: ping_storage_data_89 <= ping_storage_data_89 ^ i_input_data[720 % IN_WIDTH];
                1119 / IN_WIDTH: ping_storage_data_89 <= ping_storage_data_89 ^ i_input_data[1119 % IN_WIDTH];
                default: ping_storage_data_89 <= ping_storage_data_89;
                endcase
            end else begin
                ping_storage_data_89 <= ping_storage_data_89;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                46 / IN_WIDTH: pong_storage_data_89 <= i_input_data[46 % IN_WIDTH];
                503 / IN_WIDTH: pong_storage_data_89 <= pong_storage_data_89 ^ i_input_data[503 % IN_WIDTH];
                720 / IN_WIDTH: pong_storage_data_89 <= pong_storage_data_89 ^ i_input_data[720 % IN_WIDTH];
                1119 / IN_WIDTH: pong_storage_data_89 <= pong_storage_data_89 ^ i_input_data[1119 % IN_WIDTH];
                default: pong_storage_data_89 <= pong_storage_data_89;
                endcase
            end
        end
    end
end

logic ping_storage_data_90;
logic pong_storage_data_90;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_90 <= 1'b0;
        pong_storage_data_90 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                47 / IN_WIDTH: ping_storage_data_90 <= i_input_data[47 % IN_WIDTH];
                504 / IN_WIDTH: ping_storage_data_90 <= ping_storage_data_90 ^ i_input_data[504 % IN_WIDTH];
                721 / IN_WIDTH: ping_storage_data_90 <= ping_storage_data_90 ^ i_input_data[721 % IN_WIDTH];
                1120 / IN_WIDTH: ping_storage_data_90 <= ping_storage_data_90 ^ i_input_data[1120 % IN_WIDTH];
                default: ping_storage_data_90 <= ping_storage_data_90;
                endcase
            end else begin
                ping_storage_data_90 <= ping_storage_data_90;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                47 / IN_WIDTH: pong_storage_data_90 <= i_input_data[47 % IN_WIDTH];
                504 / IN_WIDTH: pong_storage_data_90 <= pong_storage_data_90 ^ i_input_data[504 % IN_WIDTH];
                721 / IN_WIDTH: pong_storage_data_90 <= pong_storage_data_90 ^ i_input_data[721 % IN_WIDTH];
                1120 / IN_WIDTH: pong_storage_data_90 <= pong_storage_data_90 ^ i_input_data[1120 % IN_WIDTH];
                default: pong_storage_data_90 <= pong_storage_data_90;
                endcase
            end
        end
    end
end

logic ping_storage_data_91;
logic pong_storage_data_91;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_91 <= 1'b0;
        pong_storage_data_91 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                48 / IN_WIDTH: ping_storage_data_91 <= i_input_data[48 % IN_WIDTH];
                505 / IN_WIDTH: ping_storage_data_91 <= ping_storage_data_91 ^ i_input_data[505 % IN_WIDTH];
                722 / IN_WIDTH: ping_storage_data_91 <= ping_storage_data_91 ^ i_input_data[722 % IN_WIDTH];
                1121 / IN_WIDTH: ping_storage_data_91 <= ping_storage_data_91 ^ i_input_data[1121 % IN_WIDTH];
                default: ping_storage_data_91 <= ping_storage_data_91;
                endcase
            end else begin
                ping_storage_data_91 <= ping_storage_data_91;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                48 / IN_WIDTH: pong_storage_data_91 <= i_input_data[48 % IN_WIDTH];
                505 / IN_WIDTH: pong_storage_data_91 <= pong_storage_data_91 ^ i_input_data[505 % IN_WIDTH];
                722 / IN_WIDTH: pong_storage_data_91 <= pong_storage_data_91 ^ i_input_data[722 % IN_WIDTH];
                1121 / IN_WIDTH: pong_storage_data_91 <= pong_storage_data_91 ^ i_input_data[1121 % IN_WIDTH];
                default: pong_storage_data_91 <= pong_storage_data_91;
                endcase
            end
        end
    end
end

logic ping_storage_data_92;
logic pong_storage_data_92;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_92 <= 1'b0;
        pong_storage_data_92 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                49 / IN_WIDTH: ping_storage_data_92 <= i_input_data[49 % IN_WIDTH];
                506 / IN_WIDTH: ping_storage_data_92 <= ping_storage_data_92 ^ i_input_data[506 % IN_WIDTH];
                723 / IN_WIDTH: ping_storage_data_92 <= ping_storage_data_92 ^ i_input_data[723 % IN_WIDTH];
                1122 / IN_WIDTH: ping_storage_data_92 <= ping_storage_data_92 ^ i_input_data[1122 % IN_WIDTH];
                default: ping_storage_data_92 <= ping_storage_data_92;
                endcase
            end else begin
                ping_storage_data_92 <= ping_storage_data_92;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                49 / IN_WIDTH: pong_storage_data_92 <= i_input_data[49 % IN_WIDTH];
                506 / IN_WIDTH: pong_storage_data_92 <= pong_storage_data_92 ^ i_input_data[506 % IN_WIDTH];
                723 / IN_WIDTH: pong_storage_data_92 <= pong_storage_data_92 ^ i_input_data[723 % IN_WIDTH];
                1122 / IN_WIDTH: pong_storage_data_92 <= pong_storage_data_92 ^ i_input_data[1122 % IN_WIDTH];
                default: pong_storage_data_92 <= pong_storage_data_92;
                endcase
            end
        end
    end
end

logic ping_storage_data_93;
logic pong_storage_data_93;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_93 <= 1'b0;
        pong_storage_data_93 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                50 / IN_WIDTH: ping_storage_data_93 <= i_input_data[50 % IN_WIDTH];
                507 / IN_WIDTH: ping_storage_data_93 <= ping_storage_data_93 ^ i_input_data[507 % IN_WIDTH];
                724 / IN_WIDTH: ping_storage_data_93 <= ping_storage_data_93 ^ i_input_data[724 % IN_WIDTH];
                1123 / IN_WIDTH: ping_storage_data_93 <= ping_storage_data_93 ^ i_input_data[1123 % IN_WIDTH];
                default: ping_storage_data_93 <= ping_storage_data_93;
                endcase
            end else begin
                ping_storage_data_93 <= ping_storage_data_93;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                50 / IN_WIDTH: pong_storage_data_93 <= i_input_data[50 % IN_WIDTH];
                507 / IN_WIDTH: pong_storage_data_93 <= pong_storage_data_93 ^ i_input_data[507 % IN_WIDTH];
                724 / IN_WIDTH: pong_storage_data_93 <= pong_storage_data_93 ^ i_input_data[724 % IN_WIDTH];
                1123 / IN_WIDTH: pong_storage_data_93 <= pong_storage_data_93 ^ i_input_data[1123 % IN_WIDTH];
                default: pong_storage_data_93 <= pong_storage_data_93;
                endcase
            end
        end
    end
end

logic ping_storage_data_94;
logic pong_storage_data_94;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_94 <= 1'b0;
        pong_storage_data_94 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                51 / IN_WIDTH: ping_storage_data_94 <= i_input_data[51 % IN_WIDTH];
                508 / IN_WIDTH: ping_storage_data_94 <= ping_storage_data_94 ^ i_input_data[508 % IN_WIDTH];
                725 / IN_WIDTH: ping_storage_data_94 <= ping_storage_data_94 ^ i_input_data[725 % IN_WIDTH];
                1124 / IN_WIDTH: ping_storage_data_94 <= ping_storage_data_94 ^ i_input_data[1124 % IN_WIDTH];
                default: ping_storage_data_94 <= ping_storage_data_94;
                endcase
            end else begin
                ping_storage_data_94 <= ping_storage_data_94;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                51 / IN_WIDTH: pong_storage_data_94 <= i_input_data[51 % IN_WIDTH];
                508 / IN_WIDTH: pong_storage_data_94 <= pong_storage_data_94 ^ i_input_data[508 % IN_WIDTH];
                725 / IN_WIDTH: pong_storage_data_94 <= pong_storage_data_94 ^ i_input_data[725 % IN_WIDTH];
                1124 / IN_WIDTH: pong_storage_data_94 <= pong_storage_data_94 ^ i_input_data[1124 % IN_WIDTH];
                default: pong_storage_data_94 <= pong_storage_data_94;
                endcase
            end
        end
    end
end

logic ping_storage_data_95;
logic pong_storage_data_95;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        ping_storage_data_95 <= 1'b0;
        pong_storage_data_95 <= 1'b0;
    end else begin
        if (fillup_state == ST_PING) begin
            if (i_input_valid) begin
                case (input_count)
                52 / IN_WIDTH: ping_storage_data_95 <= i_input_data[52 % IN_WIDTH];
                509 / IN_WIDTH: ping_storage_data_95 <= ping_storage_data_95 ^ i_input_data[509 % IN_WIDTH];
                726 / IN_WIDTH: ping_storage_data_95 <= ping_storage_data_95 ^ i_input_data[726 % IN_WIDTH];
                1125 / IN_WIDTH: ping_storage_data_95 <= ping_storage_data_95 ^ i_input_data[1125 % IN_WIDTH];
                default: ping_storage_data_95 <= ping_storage_data_95;
                endcase
            end else begin
                ping_storage_data_95 <= ping_storage_data_95;
            end
        end
        if (fillup_state == ST_PONG) begin
            if (i_input_valid) begin
                case (input_count)
                52 / IN_WIDTH: pong_storage_data_95 <= i_input_data[52 % IN_WIDTH];
                509 / IN_WIDTH: pong_storage_data_95 <= pong_storage_data_95 ^ i_input_data[509 % IN_WIDTH];
                726 / IN_WIDTH: pong_storage_data_95 <= pong_storage_data_95 ^ i_input_data[726 % IN_WIDTH];
                1125 / IN_WIDTH: pong_storage_data_95 <= pong_storage_data_95 ^ i_input_data[1125 % IN_WIDTH];
                default: pong_storage_data_95 <= pong_storage_data_95;
                endcase
            end
        end
    end
end


endmodule: ldpc_sparse_mult_by_C

`default_nettype wire
