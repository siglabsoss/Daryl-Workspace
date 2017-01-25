// ldpc_minsigner.sv
//
// Input = 8-bit LLR values before min-sign update
// Output = 8-bit LLR values after min-sign update

`timescale 10ps / 10ps

`default_nettype none

module ldpc_minsigner (
    input  wire logic [7:0] i_data_a0,
    input  wire logic [7:0] i_data_a1,
    input  wire logic [7:0] i_data_a2,
    input  wire logic [7:0] i_data_a3,
    input  wire logic [7:0] i_data_a4,
    input  wire logic [7:0] i_data_a5,
    input  wire logic       i_latch_inputs,
    output      logic [7:0] o_data_a0,
    output      logic [7:0] o_data_a1,
    output      logic [7:0] o_data_a2,
    output      logic [7:0] o_data_a3,
    output      logic [7:0] o_data_a4,
    output      logic [7:0] o_data_a5,
    input  wire logic       i_clock,
    input  wire logic       i_reset
);

logic [7:0] data_a0;
logic       sign_a0;
logic [7:0] data_a1;
logic       sign_a1;
logic [7:0] data_a2;
logic       sign_a2;
logic [7:0] data_a3;
logic       sign_a3;
logic [7:0] data_a4;
logic       sign_a4;
logic [7:0] data_a5;
logic       sign_a5;

logic [7:0] first_min;
logic [7:0] second_min;

always_ff @ (posedge i_clock) begin
    // Extract magnitude of LLR (convert from signed to unsigned)
    if (i_latch_inputs == 1'b1) begin
        data_a0 <= i_data_a0[7] ? (-i_data_a0) : i_data_a0;
        data_a1 <= i_data_a1[7] ? (-i_data_a1) : i_data_a1;
        data_a2 <= i_data_a2[7] ? (-i_data_a2) : i_data_a2;
        data_a3 <= i_data_a3[7] ? (-i_data_a3) : i_data_a3;
        data_a4 <= i_data_a4[7] ? (-i_data_a4) : i_data_a4;
        data_a5 <= i_data_a5[7] ? (-i_data_a5) : i_data_a5;
    end
    // Extract sign bits
    if (i_latch_inputs == 1'b1) begin
        sign_a0 <= i_data_a0[7];
        sign_a1 <= i_data_a0[7];
        sign_a2 <= i_data_a0[7];
        sign_a3 <= i_data_a0[7];
        sign_a4 <= i_data_a0[7];
        sign_a5 <= i_data_a0[7];
    end
end

// Extract smallest magnitude
logic [7:0] min_location;
ldpc_minimum #(
    .WIDTH(8))
ldpc_minimum_0_inst (
    .i_in_data ({
        8'hf,
        8'hf,
        data_a5,
        data_a4,
        data_a3,
        data_a2,
        data_a1,
        data_a0
    }),
    .o_out_data    (first_min   ),
    .o_min_location(min_location),
    .i_clock       (i_clock     ),
    .i_reset       (i_reset     ));

logic [7:0] shifted_data_a0;
logic [7:0] shifted_data_a1;
logic [7:0] shifted_data_a2;
logic [7:0] shifted_data_a3;
logic [7:0] shifted_data_a4;
logic [7:0] shifted_data_a5;

always_ff @ (posedge i_clock) begin
    shifted_data_a0 <= data_a0 - first_min - 1;
    shifted_data_a1 <= data_a1 - first_min - 1;
    shifted_data_a2 <= data_a2 - first_min - 1;
    shifted_data_a3 <= data_a3 - first_min - 1;
    shifted_data_a4 <= data_a4 - first_min - 1;
    shifted_data_a5 <= data_a5 - first_min - 1;
end

// Extract second smallest magnitude
ldpc_minimum #(
    .WIDTH(8))
ldpc_minimum_1_inst (
    .i_in_data ({
        8'hff,
        8'hff,
        shifted_data_a5,
        shifted_data_a4,
        shifted_data_a3,
        shifted_data_a2,
        shifted_data_a1,
        shifted_data_a0
    }),
    .o_out_data    (second_min),
    .o_min_location(          ),
    .i_clock       (i_clock   ),
    .i_reset       (i_reset   ));

// Sign calculation
logic sign_abcd_r0;
logic sign_efgh_r0;

logic sign_abcdefgh_r1;

logic final_sign_a0;
logic final_sign_a1;
logic final_sign_a2;
logic final_sign_a3;
logic final_sign_a4;
logic final_sign_a5;

logic [7:0] sign_vector;
assign sign_vector = {
    2'b00,
    data_a5[7],
    data_a4[7],
    data_a3[7],
    data_a2[7],
    data_a1[7],
    data_a0[7]
};

always_ff @(posedge i_clock) begin
    if(i_reset) begin
        sign_abcd_r0 <= 1'b0;
        sign_efgh_r0 <= 1'b0;
        sign_abcdefgh_r1 <= 1'b0;
        final_sign_a0 <= 1'b0;
        final_sign_a1 <= 1'b0;
        final_sign_a2 <= 1'b0;
        final_sign_a3 <= 1'b0;
        final_sign_a4 <= 1'b0;
        final_sign_a5 <= 1'b0;
    end else begin
        // Stage 0
        sign_abcd_r0 <= ^(sign_vector[3:0]);
        sign_efgh_r0 <= ^(sign_vector[7:4]);
        // Stage 1
        sign_abcdefgh_r1 <= sign_abcd_r0 ^ sign_efgh_r0;
        // Stage 2
        final_sign_a0 <= sign_abcdefgh_r1 ^ sign_a0;
        final_sign_a1 <= sign_abcdefgh_r1 ^ sign_a1;
        final_sign_a2 <= sign_abcdefgh_r1 ^ sign_a2;
        final_sign_a3 <= sign_abcdefgh_r1 ^ sign_a3;
        final_sign_a4 <= sign_abcdefgh_r1 ^ sign_a4;
        final_sign_a5 <= sign_abcdefgh_r1 ^ sign_a5;
    end
end

// Send result to output
logic [7:0] neg_first_min;
logic [7:0] neg_second_min;
assign neg_first_min = -first_min;
assign neg_second_min = -second_min;
always_ff @ (posedge i_clock) begin
    case ({ min_location[0], final_sign_a0 })
        2'b11:   o_data_a0 <= neg_second_min;
        2'b01:   o_data_a0 <= neg_first_min;
        2'b10:   o_data_a0 <= second_min;
        default: o_data_a0 <= first_min;
    endcase
    case ({ min_location[1], final_sign_a1 })
        2'b11:   o_data_a1 <= neg_second_min;
        2'b01:   o_data_a1 <= neg_first_min;
        2'b10:   o_data_a1 <= second_min;
        default: o_data_a1 <= first_min;
    endcase
    case ({ min_location[2], final_sign_a2 })
        2'b11:   o_data_a2 <= neg_second_min;
        2'b01:   o_data_a2 <= neg_first_min;
        2'b10:   o_data_a2 <= second_min;
        default: o_data_a2 <= first_min;
    endcase
    case ({ min_location[3], final_sign_a3 })
        2'b11:   o_data_a3 <= neg_second_min;
        2'b01:   o_data_a3 <= neg_first_min;
        2'b10:   o_data_a3 <= second_min;
        default: o_data_a3 <= first_min;
    endcase
    case ({ min_location[4], final_sign_a4 })
        2'b11:   o_data_a4 <= neg_second_min;
        2'b01:   o_data_a4 <= neg_first_min;
        2'b10:   o_data_a4 <= second_min;
        default: o_data_a4 <= first_min;
    endcase
    case ({ min_location[5], final_sign_a5 })
        2'b11:   o_data_a5 <= neg_second_min;
        2'b01:   o_data_a5 <= neg_first_min;
        2'b10:   o_data_a5 <= second_min;
        default: o_data_a5 <= first_min;
    endcase
end

endmodule: ldpc_minsigner

`default_nettype wire
