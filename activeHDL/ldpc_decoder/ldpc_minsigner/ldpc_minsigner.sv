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
    input  wire logic       i_valid,
    output      logic [7:0] o_data_a0,
    output      logic [7:0] o_data_a1,
    output      logic [7:0] o_data_a2,
    output      logic [7:0] o_data_a3,
    output      logic [7:0] o_data_a4,
    output      logic [7:0] o_data_a5,
    output      logic       o_valid,
    input  wire logic       i_clock,
    input  wire logic       i_reset
);

logic [7:0] data_a0_reg0;
logic       sign_a0_reg0;
logic [7:0] data_a1_reg0;
logic       sign_a1_reg0;
logic [7:0] data_a2_reg0;
logic       sign_a2_reg0;
logic [7:0] data_a3_reg0;
logic       sign_a3_reg0;
logic [7:0] data_a4_reg0;
logic       sign_a4_reg0;
logic [7:0] data_a5_reg0;
logic       sign_a5_reg0;

logic [7:0] data_a0_reg1;
logic       sign_a0_reg1;
logic [7:0] data_a1_reg1;
logic       sign_a1_reg1;
logic [7:0] data_a2_reg1;
logic       sign_a2_reg1;
logic [7:0] data_a3_reg1;
logic       sign_a3_reg1;
logic [7:0] data_a4_reg1;
logic       sign_a4_reg1;
logic [7:0] data_a5_reg1;
logic       sign_a5_reg1;

logic [7:0] data_a0_reg2;
logic       sign_a0_reg2;
logic [7:0] data_a1_reg2;
logic       sign_a1_reg2;
logic [7:0] data_a2_reg2;
logic       sign_a2_reg2;
logic [7:0] data_a3_reg2;
logic       sign_a3_reg2;
logic [7:0] data_a4_reg2;
logic       sign_a4_reg2;
logic [7:0] data_a5_reg2;
logic       sign_a5_reg2;

logic [7:0] first_min_reg2;

always_ff @ (posedge i_clock) begin
    // Pipeline Stage 0
    // Extract magnitude of LLR (convert from signed to unsigned)
    data_a0_reg0 <= i_data_a0[7] ? (-i_data_a0) : i_data_a0;
    data_a1_reg0 <= i_data_a1[7] ? (-i_data_a1) : i_data_a1;
    data_a2_reg0 <= i_data_a2[7] ? (-i_data_a2) : i_data_a2;
    data_a3_reg0 <= i_data_a3[7] ? (-i_data_a3) : i_data_a3;
    data_a4_reg0 <= i_data_a4[7] ? (-i_data_a4) : i_data_a4;
    data_a5_reg0 <= i_data_a5[7] ? (-i_data_a5) : i_data_a5;
    // Extract sign bits
    sign_a0_reg0 <= i_data_a0[7];
    sign_a1_reg0 <= i_data_a1[7];
    sign_a2_reg0 <= i_data_a2[7];
    sign_a3_reg0 <= i_data_a3[7];
    sign_a4_reg0 <= i_data_a4[7];
    sign_a5_reg0 <= i_data_a5[7];

    // Pipeline Stage 1
    data_a0_reg1 <= data_a0_reg0;
    data_a1_reg1 <= data_a1_reg0;
    data_a2_reg1 <= data_a2_reg0;
    data_a3_reg1 <= data_a3_reg0;
    data_a4_reg1 <= data_a4_reg0;
    data_a5_reg1 <= data_a5_reg0;

    sign_a0_reg1 <= sign_a0_reg0;
    sign_a1_reg1 <= sign_a1_reg0;
    sign_a2_reg1 <= sign_a2_reg0;
    sign_a3_reg1 <= sign_a3_reg0;
    sign_a4_reg1 <= sign_a4_reg0;
    sign_a5_reg1 <= sign_a5_reg0;

    // Pipeline Stage 2 (Corresponds to first min output)
    data_a0_reg2 <= data_a0_reg1;
    data_a1_reg2 <= data_a1_reg1;
    data_a2_reg2 <= data_a2_reg1;
    data_a3_reg2 <= data_a3_reg1;
    data_a4_reg2 <= data_a4_reg1;
    data_a5_reg2 <= data_a5_reg1;

    sign_a0_reg2 <= sign_a0_reg1;
    sign_a1_reg2 <= sign_a1_reg1;
    sign_a2_reg2 <= sign_a2_reg1;
    sign_a3_reg2 <= sign_a3_reg1;
    sign_a4_reg2 <= sign_a4_reg1;
    sign_a5_reg2 <= sign_a5_reg1;
end

// Extract smallest magnitude
logic [7:0] min_location_reg2;

ldpc_minimum #(
    .WIDTH(8))
ldpc_minimum_0_inst (
    .i_in_data ({
        8'hf,
        8'hf,
        data_a5_reg0,
        data_a4_reg0,
        data_a3_reg0,
        data_a2_reg0,
        data_a1_reg0,
        data_a0_reg0
    }),
    .o_out_data    (first_min_reg2   ),
    .o_min_location(min_location_reg2),
    .i_clock       (i_clock          ),
    .i_reset       (i_reset          ));

logic [7:0] shifted_data_a0_reg3;
logic [7:0] shifted_data_a1_reg3;
logic [7:0] shifted_data_a2_reg3;
logic [7:0] shifted_data_a3_reg3;
logic [7:0] shifted_data_a4_reg3;
logic [7:0] shifted_data_a5_reg3;

logic       sign_a0_reg3;
logic       sign_a1_reg3;
logic       sign_a2_reg3;
logic       sign_a3_reg3;
logic       sign_a4_reg3;
logic       sign_a5_reg3;

logic [7:0] first_min_reg3;
logic [5:0] min_location_reg3;

logic       sign_a0_reg4;
logic       sign_a1_reg4;
logic       sign_a2_reg4;
logic       sign_a3_reg4;
logic       sign_a4_reg4;
logic       sign_a5_reg4;

logic [7:0] first_min_reg4;
logic [5:0] min_location_reg4;

logic       sign_a0_reg5;
logic       sign_a1_reg5;
logic       sign_a2_reg5;
logic       sign_a3_reg5;
logic       sign_a4_reg5;
logic       sign_a5_reg5;

logic [7:0] first_min_reg5;
logic [5:0] min_location_reg5;

always_ff @ (posedge i_clock) begin
    // Pipeline Stage 3
    shifted_data_a0_reg3 <= data_a0_reg2 - first_min_reg2 - 1;
    shifted_data_a1_reg3 <= data_a1_reg2 - first_min_reg2 - 1;
    shifted_data_a2_reg3 <= data_a2_reg2 - first_min_reg2 - 1;
    shifted_data_a3_reg3 <= data_a3_reg2 - first_min_reg2 - 1;
    shifted_data_a4_reg3 <= data_a4_reg2 - first_min_reg2 - 1;
    shifted_data_a5_reg3 <= data_a5_reg2 - first_min_reg2 - 1;

    sign_a0_reg3 <= sign_a0_reg2;
    sign_a1_reg3 <= sign_a1_reg2;
    sign_a2_reg3 <= sign_a2_reg2;
    sign_a3_reg3 <= sign_a3_reg2;
    sign_a4_reg3 <= sign_a4_reg2;
    sign_a5_reg3 <= sign_a5_reg2;

    first_min_reg3 <= first_min_reg2;
    min_location_reg3 <= min_location_reg2[5:0];

    // Pipeline Stage 4
    sign_a0_reg4 <= sign_a0_reg3;
    sign_a1_reg4 <= sign_a1_reg3;
    sign_a2_reg4 <= sign_a2_reg3;
    sign_a3_reg4 <= sign_a3_reg3;
    sign_a4_reg4 <= sign_a4_reg3;
    sign_a5_reg4 <= sign_a5_reg3;

    first_min_reg4 <= first_min_reg3;
    min_location_reg4 <= min_location_reg3;

    // Pipeline Stage 5
    sign_a0_reg5 <= sign_a0_reg4;
    sign_a1_reg5 <= sign_a1_reg4;
    sign_a2_reg5 <= sign_a2_reg4;
    sign_a3_reg5 <= sign_a3_reg4;
    sign_a4_reg5 <= sign_a4_reg4;
    sign_a5_reg5 <= sign_a5_reg4;

    first_min_reg5 <= first_min_reg4;
    min_location_reg5 <= min_location_reg4;
end

// Extract second smallest magnitude
logic [7:0] temp_second_min_reg5;
ldpc_minimum #(
    .WIDTH(8))
ldpc_minimum_1_inst (
    .i_in_data ({
        8'hff,
        8'hff,
        shifted_data_a5_reg3,
        shifted_data_a4_reg3,
        shifted_data_a3_reg3,
        shifted_data_a2_reg3,
        shifted_data_a1_reg3,
        shifted_data_a0_reg3
    }),
    .o_out_data    (temp_second_min_reg5),
    .o_min_location(                    ),
    .i_clock       (i_clock             ),
    .i_reset       (i_reset             ));

logic       sign_a0_reg6;
logic       sign_a1_reg6;
logic       sign_a2_reg6;
logic       sign_a3_reg6;
logic       sign_a4_reg6;
logic       sign_a5_reg6;

logic [7:0] first_min_reg6;
logic [7:0] second_min_reg6;
logic [5:0] min_location_reg6;

always_ff @(posedge i_clock) begin
    // Pipeline Stage 6
    sign_a0_reg6 <= sign_a0_reg5;
    sign_a1_reg6 <= sign_a1_reg5;
    sign_a2_reg6 <= sign_a2_reg5;
    sign_a3_reg6 <= sign_a3_reg5;
    sign_a4_reg6 <= sign_a4_reg5;
    sign_a5_reg6 <= sign_a5_reg5;

    first_min_reg6 <= first_min_reg5;
    second_min_reg6 <= temp_second_min_reg5 + first_min_reg5 + 1;
    min_location_reg6 <= min_location_reg5;
end

// Sign calculation
logic       sign_abcd_r0_reg7;
logic       sign_efgh_r0_reg7;

logic       sign_a0_reg7;
logic       sign_a1_reg7;
logic       sign_a2_reg7;
logic       sign_a3_reg7;
logic       sign_a4_reg7;
logic       sign_a5_reg7;

logic [7:0] first_min_reg7;
logic [7:0] second_min_reg7;
logic [5:0] min_location_reg7;

logic       sign_abcdefgh_r1_reg8;

logic       sign_a0_reg8;
logic       sign_a1_reg8;
logic       sign_a2_reg8;
logic       sign_a3_reg8;
logic       sign_a4_reg8;
logic       sign_a5_reg8;

logic [7:0] first_min_reg8;
logic [7:0] second_min_reg8;
logic [5:0] min_location_reg8;

logic       final_sign_a0_reg9;
logic       final_sign_a1_reg9;
logic       final_sign_a2_reg9;
logic       final_sign_a3_reg9;
logic       final_sign_a4_reg9;
logic       final_sign_a5_reg9;

logic [7:0] first_min_reg9;
logic [7:0] second_min_reg9;
logic [5:0] min_location_reg9;

logic [7:0] sign_vector;
assign sign_vector = {
    2'b00,
    sign_a5_reg6,
    sign_a4_reg6,
    sign_a3_reg6,
    sign_a2_reg6,
    sign_a1_reg6,
    sign_a0_reg6
};

always_ff @(posedge i_clock) begin
    // Pipeline Stage 7 : Ministage 0
    sign_abcd_r0_reg7 <= ^sign_vector[3:0];
    sign_efgh_r0_reg7 <= ^sign_vector[7:4];

    sign_a0_reg7 <= sign_a0_reg6;
    sign_a1_reg7 <= sign_a1_reg6;
    sign_a2_reg7 <= sign_a2_reg6;
    sign_a3_reg7 <= sign_a3_reg6;
    sign_a4_reg7 <= sign_a4_reg6;
    sign_a5_reg7 <= sign_a5_reg6;

    first_min_reg7 <= first_min_reg6;
    second_min_reg7 <= second_min_reg6;
    min_location_reg7 <= min_location_reg6;

    // Pipeline Stage 8 : Ministage 1
    sign_abcdefgh_r1_reg8 <= sign_abcd_r0_reg7 ^ sign_efgh_r0_reg7;

    sign_a0_reg8 <= sign_a0_reg7;
    sign_a1_reg8 <= sign_a1_reg7;
    sign_a2_reg8 <= sign_a2_reg7;
    sign_a3_reg8 <= sign_a3_reg7;
    sign_a4_reg8 <= sign_a4_reg7;
    sign_a5_reg8 <= sign_a5_reg7;

    first_min_reg8 <= first_min_reg7;
    second_min_reg8 <= second_min_reg7;
    min_location_reg8 <= min_location_reg7;

    // Pipeline Stage 9 : Ministage 2
    final_sign_a0_reg9 <= sign_abcdefgh_r1_reg8 ^ sign_a0_reg8;
    final_sign_a1_reg9 <= sign_abcdefgh_r1_reg8 ^ sign_a1_reg8;
    final_sign_a2_reg9 <= sign_abcdefgh_r1_reg8 ^ sign_a2_reg8;
    final_sign_a3_reg9 <= sign_abcdefgh_r1_reg8 ^ sign_a3_reg8;
    final_sign_a4_reg9 <= sign_abcdefgh_r1_reg8 ^ sign_a4_reg8;
    final_sign_a5_reg9 <= sign_abcdefgh_r1_reg8 ^ sign_a5_reg8;

    first_min_reg9 <= first_min_reg8;
    second_min_reg9 <= second_min_reg8;
    min_location_reg9 <= min_location_reg8;
end

// Send result to output
logic [7:0] neg_first_min;
logic [7:0] neg_second_min;
assign neg_first_min = -first_min_reg9;
assign neg_second_min = -second_min_reg9;
always_ff @ (posedge i_clock) begin
    case ({ min_location_reg9[0], final_sign_a0_reg9 })
        2'b11:   o_data_a0 <= neg_second_min;
        2'b01:   o_data_a0 <= neg_first_min;
        2'b10:   o_data_a0 <= second_min_reg9;
        default: o_data_a0 <= first_min_reg9;
    endcase
    case ({ min_location_reg9[1], final_sign_a1_reg9 })
        2'b11:   o_data_a1 <= neg_second_min;
        2'b01:   o_data_a1 <= neg_first_min;
        2'b10:   o_data_a1 <= second_min_reg9;
        default: o_data_a1 <= first_min_reg9;
    endcase
    case ({ min_location_reg9[2], final_sign_a2_reg9 })
        2'b11:   o_data_a2 <= neg_second_min;
        2'b01:   o_data_a2 <= neg_first_min;
        2'b10:   o_data_a2 <= second_min_reg9;
        default: o_data_a2 <= first_min_reg9;
    endcase
    case ({ min_location_reg9[3], final_sign_a3_reg9 })
        2'b11:   o_data_a3 <= neg_second_min;
        2'b01:   o_data_a3 <= neg_first_min;
        2'b10:   o_data_a3 <= second_min_reg9;
        default: o_data_a3 <= first_min_reg9;
    endcase
    case ({ min_location_reg9[4], final_sign_a4_reg9 })
        2'b11:   o_data_a4 <= neg_second_min;
        2'b01:   o_data_a4 <= neg_first_min;
        2'b10:   o_data_a4 <= second_min_reg9;
        default: o_data_a4 <= first_min_reg9;
    endcase
    case ({ min_location_reg9[5], final_sign_a5_reg9 })
        2'b11:   o_data_a5 <= neg_second_min;
        2'b01:   o_data_a5 <= neg_first_min;
        2'b10:   o_data_a5 <= second_min_reg9;
        default: o_data_a5 <= first_min_reg9;
    endcase
end

logic [9:0] valid_regs;
always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        valid_regs <= 0;
        o_valid <= 1'b0;
    end else begin
        valid_regs[9:0] <= { valid_regs[8:0], i_valid };
        o_valid <= valid_regs[9];
    end
end

endmodule: ldpc_minsigner

`default_nettype wire
