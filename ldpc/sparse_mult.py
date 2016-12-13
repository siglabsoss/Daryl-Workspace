import time
import jinja2


temp = jinja2.Template(''' // Generated from template on {{ date }}.
`timescale 1ps / 1ps

`default_nettype none

module sparse_mult #(
    parameter integer WIDTH = 8
) (
    input  wire logic [WIDTH-1:0] in_data,
    input  wire logic             in_valid,
    output      logic             in_ready,
    output      logic [WIDTH-1:0] out_data,
    output      logic             out_valid,
    input  wire logic             out_ready,
    input  wire logic             clock,
    input  wire logic             reset
);

localparam integer INPUT_LENGTH = {{ in_length }};
localparam integer OUTPUT_LENGTH = {{ out_length }};

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
{% for row in sparse_matrix %}
logic ping_storage_data_{{ loop.index0 }};
logic pong_storage_data_{{ loop.index0 }};

always_ff @ (posedge clock) begin
    if ((input_valid & input_ready) == 1'b1) begin
        if (input_is_ping == 1'b1) begin{% set outer_loop_index = loop.index0 %}
            case (input_count){% for next_nonzero_element in row %}
            {{ next_nonzero_element }}: ping_storage_data_{{ outer_loop_index }} <= ping_storage_data_{{ outer_loop_index }} ^ input_data;{% endfor %}
            default: pong_storage_data_{{ outer_loop_index }} <= pong_storage_data_{{ outer_loop_index }};
            endcase
        end else begin
            case (input_count){% for next_nonzero_element in row %}
            {{ next_nonzero_element }}: pong_storage_data_{{ outer_loop_index }} <= pong_storage_data_{{ outer_loop_index }} ^ input_data;{% endfor %}
            default: pong_storage_data_{{ outer_loop_index }} <= pong_storage_data_{{ outer_loop_index }};
            endcase
        end

    end
end
{% endfor %}

endmodule: sparse_mult

`default_nettype wire
''')

print(temp.render(
    date=time.strftime("%d/%m/%Y"),
    in_length=10,
    out_length=10,
    sparse_matrix=[
        [1, 2, 3],
        [3, 4, 9],
        [0, 5, 6],
        [7, 8, 9],
        [0, 2, 4],
        [1, 5, 7],
        [0, 1],
        [9],
        [1, 2, 3],
        [0, 4, 8]
    ]))