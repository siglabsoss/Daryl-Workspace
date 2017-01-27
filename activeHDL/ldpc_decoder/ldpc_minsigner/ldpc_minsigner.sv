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
    input  wire logic [7:0] i_data_a6,
    input  wire logic       i_valid,
    output      logic [7:0] o_data_a0,
    output      logic [7:0] o_data_a1,
    output      logic [7:0] o_data_a2,
    output      logic [7:0] o_data_a3,
    output      logic [7:0] o_data_a4,
    output      logic [7:0] o_data_a5,
    output      logic [7:0] o_data_a6,
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
logic [7:0] data_a6_reg0;
logic       sign_a6_reg0;

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
logic [7:0] data_a6_reg1;
logic       sign_a6_reg1;

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
logic [7:0] data_a6_reg2;
logic       sign_a6_reg2;

logic [7:0] data_a0_reg3;
logic       sign_a0_reg3;
logic [7:0] data_a1_reg3;
logic       sign_a1_reg3;
logic [7:0] data_a2_reg3;
logic       sign_a2_reg3;
logic [7:0] data_a3_reg3;
logic       sign_a3_reg3;
logic [7:0] data_a4_reg3;
logic       sign_a4_reg3;
logic [7:0] data_a5_reg3;
logic       sign_a5_reg3;
logic [7:0] data_a6_reg3;
logic       sign_a6_reg3;

always_ff @ (posedge i_clock) begin
    // Pipeline Stage 0
    // Extract magnitude of LLR (convert from signed to unsigned)
    data_a0_reg0 <= i_data_a0[7] ? (-i_data_a0) : i_data_a0;
    data_a1_reg0 <= i_data_a1[7] ? (-i_data_a1) : i_data_a1;
    data_a2_reg0 <= i_data_a2[7] ? (-i_data_a2) : i_data_a2;
    data_a3_reg0 <= i_data_a3[7] ? (-i_data_a3) : i_data_a3;
    data_a4_reg0 <= i_data_a4[7] ? (-i_data_a4) : i_data_a4;
    data_a5_reg0 <= i_data_a5[7] ? (-i_data_a5) : i_data_a5;
    data_a6_reg0 <= i_data_a6[7] ? (-i_data_a6) : i_data_a6;
    // Extract sign bits
    sign_a0_reg0 <= i_data_a0[7];
    sign_a1_reg0 <= i_data_a1[7];
    sign_a2_reg0 <= i_data_a2[7];
    sign_a3_reg0 <= i_data_a3[7];
    sign_a4_reg0 <= i_data_a4[7];
    sign_a5_reg0 <= i_data_a5[7];
    sign_a6_reg0 <= i_data_a6[7];

    // Pipeline Stage 1
    data_a0_reg1 <= data_a0_reg0;
    data_a1_reg1 <= data_a1_reg0;
    data_a2_reg1 <= data_a2_reg0;
    data_a3_reg1 <= data_a3_reg0;
    data_a4_reg1 <= data_a4_reg0;
    data_a5_reg1 <= data_a5_reg0;
    data_a6_reg1 <= data_a6_reg0;

    sign_a0_reg1 <= sign_a0_reg0;
    sign_a1_reg1 <= sign_a1_reg0;
    sign_a2_reg1 <= sign_a2_reg0;
    sign_a3_reg1 <= sign_a3_reg0;
    sign_a4_reg1 <= sign_a4_reg0;
    sign_a5_reg1 <= sign_a5_reg0;
    sign_a6_reg1 <= sign_a6_reg0;

    // Pipeline Stage 2
    data_a0_reg2 <= data_a0_reg1;
    data_a1_reg2 <= data_a1_reg1;
    data_a2_reg2 <= data_a2_reg1;
    data_a3_reg2 <= data_a3_reg1;
    data_a4_reg2 <= data_a4_reg1;
    data_a5_reg2 <= data_a5_reg1;
    data_a6_reg2 <= data_a6_reg1;

    sign_a0_reg2 <= sign_a0_reg1;
    sign_a1_reg2 <= sign_a1_reg1;
    sign_a2_reg2 <= sign_a2_reg1;
    sign_a3_reg2 <= sign_a3_reg1;
    sign_a4_reg2 <= sign_a4_reg1;
    sign_a5_reg2 <= sign_a5_reg1;
    sign_a6_reg2 <= sign_a6_reg1;

    // Pipeline Stage 3 (Corresponds to first min output)
    data_a0_reg3 <= data_a0_reg2;
    data_a1_reg3 <= data_a1_reg2;
    data_a2_reg3 <= data_a2_reg2;
    data_a3_reg3 <= data_a3_reg2;
    data_a4_reg3 <= data_a4_reg2;
    data_a5_reg3 <= data_a5_reg2;
    data_a6_reg3 <= data_a6_reg2;

    sign_a0_reg3 <= sign_a0_reg2;
    sign_a1_reg3 <= sign_a1_reg2;
    sign_a2_reg3 <= sign_a2_reg2;
    sign_a3_reg3 <= sign_a3_reg2;
    sign_a4_reg3 <= sign_a4_reg2;
    sign_a5_reg3 <= sign_a5_reg2;
    sign_a6_reg3 <= sign_a6_reg2;
end

// Extract smallest magnitude
logic [7:0] min_location_reg3;
logic [7:0] first_min_reg3;

ldpc_minimum #(
    .WIDTH(8))
ldpc_minimum_0_inst (
    .i_in_data ({
        8'hf,
        data_a6_reg0,
        data_a5_reg0,
        data_a4_reg0,
        data_a3_reg0,
        data_a2_reg0,
        data_a1_reg0,
        data_a0_reg0
    }),
    .o_out_data    (first_min_reg3   ),
    .o_min_location(min_location_reg3),
    .i_clock       (i_clock          ),
    .i_reset       (i_reset          ));

logic [7:0] shifted_data_a0_reg4;
logic [7:0] shifted_data_a1_reg4;
logic [7:0] shifted_data_a2_reg4;
logic [7:0] shifted_data_a3_reg4;
logic [7:0] shifted_data_a4_reg4;
logic [7:0] shifted_data_a5_reg4;
logic [7:0] shifted_data_a6_reg4;

logic       sign_a0_reg4;
logic       sign_a1_reg4;
logic       sign_a2_reg4;
logic       sign_a3_reg4;
logic       sign_a4_reg4;
logic       sign_a5_reg4;
logic       sign_a6_reg4;

logic [7:0] first_min_reg4;
logic [6:0] min_location_reg4;

logic       sign_a0_reg5;
logic       sign_a1_reg5;
logic       sign_a2_reg5;
logic       sign_a3_reg5;
logic       sign_a4_reg5;
logic       sign_a5_reg5;
logic       sign_a6_reg5;

logic [7:0] first_min_reg5;
logic [6:0] min_location_reg5;

logic       sign_a0_reg6;
logic       sign_a1_reg6;
logic       sign_a2_reg6;
logic       sign_a3_reg6;
logic       sign_a4_reg6;
logic       sign_a5_reg6;
logic       sign_a6_reg6;

logic [7:0] first_min_reg6;
logic [6:0] min_location_reg6;

logic       sign_a0_reg7;
logic       sign_a1_reg7;
logic       sign_a2_reg7;
logic       sign_a3_reg7;
logic       sign_a4_reg7;
logic       sign_a5_reg7;
logic       sign_a6_reg7;

logic [7:0] first_min_reg7;
logic [6:0] min_location_reg7;

always_ff @ (posedge i_clock) begin
    // Pipeline Stage 4
    if (min_location_reg3[0] == 1'b1) begin
        shifted_data_a0_reg4 <= data_a0_reg3 - first_min_reg3 - 1;
    end else begin
        shifted_data_a0_reg4 <= data_a0_reg3;
    end
    if (min_location_reg3[1] == 1'b1) begin
        shifted_data_a1_reg4 <= data_a1_reg3 - first_min_reg3 - 1;
    end else begin
        shifted_data_a1_reg4 <= data_a1_reg3;
    end
    if (min_location_reg3[2] == 1'b1) begin
        shifted_data_a2_reg4 <= data_a2_reg3 - first_min_reg3 - 1;
    end else begin
        shifted_data_a2_reg4 <= data_a2_reg3;
    end
    if (min_location_reg3[3] == 1'b1) begin
        shifted_data_a3_reg4 <= data_a3_reg3 - first_min_reg3 - 1;
    end else begin
        shifted_data_a3_reg4 <= data_a3_reg3;
    end
    if (min_location_reg3[4] == 1'b1) begin
        shifted_data_a4_reg4 <= data_a4_reg3 - first_min_reg3 - 1;
    end else begin
        shifted_data_a4_reg4 <= data_a4_reg3;
    end
    if (min_location_reg3[5] == 1'b1) begin
        shifted_data_a5_reg4 <= data_a5_reg3 - first_min_reg3 - 1;
    end else begin
        shifted_data_a5_reg4 <= data_a5_reg3;
    end
    if (min_location_reg3[6] == 1'b1) begin
        shifted_data_a6_reg4 <= data_a6_reg3 - first_min_reg3 - 1;
    end else begin
        shifted_data_a6_reg4 <= data_a6_reg3;
    end

    sign_a0_reg4 <= sign_a0_reg3;
    sign_a1_reg4 <= sign_a1_reg3;
    sign_a2_reg4 <= sign_a2_reg3;
    sign_a3_reg4 <= sign_a3_reg3;
    sign_a4_reg4 <= sign_a4_reg3;
    sign_a5_reg4 <= sign_a5_reg3;
    sign_a6_reg4 <= sign_a6_reg3;

    first_min_reg4 <= first_min_reg3;
    min_location_reg4 <= min_location_reg3[6:0];

    // Pipeline Stage 5
    sign_a0_reg5 <= sign_a0_reg4;
    sign_a1_reg5 <= sign_a1_reg4;
    sign_a2_reg5 <= sign_a2_reg4;
    sign_a3_reg5 <= sign_a3_reg4;
    sign_a4_reg5 <= sign_a4_reg4;
    sign_a5_reg5 <= sign_a5_reg4;
    sign_a6_reg5 <= sign_a6_reg4;

    first_min_reg5 <= first_min_reg4;
    min_location_reg5 <= min_location_reg4;

    // Pipeline Stage 6
    sign_a0_reg6 <= sign_a0_reg5;
    sign_a1_reg6 <= sign_a1_reg5;
    sign_a2_reg6 <= sign_a2_reg5;
    sign_a3_reg6 <= sign_a3_reg5;
    sign_a4_reg6 <= sign_a4_reg5;
    sign_a5_reg6 <= sign_a5_reg5;
    sign_a6_reg6 <= sign_a6_reg5;

    first_min_reg6 <= first_min_reg5;
    min_location_reg6 <= min_location_reg5;

    // Pipeline Stage 7 (corresponding to second min output)
    sign_a0_reg7 <= sign_a0_reg6;
    sign_a1_reg7 <= sign_a1_reg6;
    sign_a2_reg7 <= sign_a2_reg6;
    sign_a3_reg7 <= sign_a3_reg6;
    sign_a4_reg7 <= sign_a4_reg6;
    sign_a5_reg7 <= sign_a5_reg6;
    sign_a6_reg7 <= sign_a6_reg6;

    first_min_reg7 <= first_min_reg6;
    min_location_reg7 <= min_location_reg6;
end

// Extract second smallest magnitude
logic [7:0] second_min_reg7;
ldpc_minimum #(
    .WIDTH(8))
ldpc_minimum_1_inst (
    .i_in_data ({
        8'hff,
        shifted_data_a6_reg4,
        shifted_data_a5_reg4,
        shifted_data_a4_reg4,
        shifted_data_a3_reg4,
        shifted_data_a2_reg4,
        shifted_data_a1_reg4,
        shifted_data_a0_reg4
    }),
    .o_out_data    (second_min_reg7),
    .o_min_location(               ),
    .i_clock       (i_clock        ),
    .i_reset       (i_reset        ));

logic       sign_a0_reg8;
logic       sign_a1_reg8;
logic       sign_a2_reg8;
logic       sign_a3_reg8;
logic       sign_a4_reg8;
logic       sign_a5_reg8;
logic       sign_a6_reg8;

logic [7:0] first_min_reg8;
logic [7:0] second_min_reg8;
logic [6:0] min_location_reg8;

always_ff @(posedge i_clock) begin
    // Pipeline Stage 8
    sign_a0_reg8 <= sign_a0_reg7;
    sign_a1_reg8 <= sign_a1_reg7;
    sign_a2_reg8 <= sign_a2_reg7;
    sign_a3_reg8 <= sign_a3_reg7;
    sign_a4_reg8 <= sign_a4_reg7;
    sign_a5_reg8 <= sign_a5_reg7;
    sign_a6_reg8 <= sign_a6_reg7;

    first_min_reg8 <= first_min_reg7;
    second_min_reg8 <= second_min_reg7;
    min_location_reg8 <= min_location_reg7;
end

// Sign calculation
logic       sign_abcd_r0_reg9;
logic       sign_efgh_r0_reg9;

logic       sign_a0_reg9;
logic       sign_a1_reg9;
logic       sign_a2_reg9;
logic       sign_a3_reg9;
logic       sign_a4_reg9;
logic       sign_a5_reg9;
logic       sign_a6_reg9;

logic [7:0] first_min_reg9;
logic [7:0] second_min_reg9;
logic [6:0] min_location_reg9;

logic       sign_abcdefgh_r1_reg10;

logic       sign_a0_reg10;
logic       sign_a1_reg10;
logic       sign_a2_reg10;
logic       sign_a3_reg10;
logic       sign_a4_reg10;
logic       sign_a5_reg10;
logic       sign_a6_reg10;

logic [7:0] first_min_reg10;
logic [7:0] second_min_reg10;
logic [6:0] min_location_reg10;

logic       final_sign_a0_reg11;
logic       final_sign_a1_reg11;
logic       final_sign_a2_reg11;
logic       final_sign_a3_reg11;
logic       final_sign_a4_reg11;
logic       final_sign_a5_reg11;
logic       final_sign_a6_reg11;

logic [7:0] first_min_reg11;
logic [7:0] second_min_reg11;
logic [6:0] min_location_reg11;

logic [7:0] sign_vector;
assign sign_vector = {
    1'b0,
    sign_a6_reg8,
    sign_a5_reg8,
    sign_a4_reg8,
    sign_a3_reg8,
    sign_a2_reg8,
    sign_a1_reg8,
    sign_a0_reg8
};

always_ff @(posedge i_clock) begin
    // Pipeline Stage 9 : Ministage 0
    sign_abcd_r0_reg9 <= ^sign_vector[3:0];
    sign_efgh_r0_reg9 <= ^sign_vector[7:4];

    sign_a0_reg9 <= sign_a0_reg8;
    sign_a1_reg9 <= sign_a1_reg8;
    sign_a2_reg9 <= sign_a2_reg8;
    sign_a3_reg9 <= sign_a3_reg8;
    sign_a4_reg9 <= sign_a4_reg8;
    sign_a5_reg9 <= sign_a5_reg8;
    sign_a6_reg9 <= sign_a6_reg8;

    first_min_reg9 <= first_min_reg8;
    second_min_reg9 <= second_min_reg8;
    min_location_reg9 <= min_location_reg8;

    // Pipeline Stage 10 : Ministage 1
    sign_abcdefgh_r1_reg10 <= sign_abcd_r0_reg9 ^ sign_efgh_r0_reg9;

    sign_a0_reg10 <= sign_a0_reg9;
    sign_a1_reg10 <= sign_a1_reg9;
    sign_a2_reg10 <= sign_a2_reg9;
    sign_a3_reg10 <= sign_a3_reg9;
    sign_a4_reg10 <= sign_a4_reg9;
    sign_a5_reg10 <= sign_a5_reg9;
    sign_a6_reg10 <= sign_a6_reg9;

    first_min_reg10 <= first_min_reg9;
    second_min_reg10 <= second_min_reg9;
    min_location_reg10 <= min_location_reg9;

    // Pipeline Stage 9 : Ministage 2
    final_sign_a0_reg11 <= sign_abcdefgh_r1_reg10 ^ sign_a0_reg10;
    final_sign_a1_reg11 <= sign_abcdefgh_r1_reg10 ^ sign_a1_reg10;
    final_sign_a2_reg11 <= sign_abcdefgh_r1_reg10 ^ sign_a2_reg10;
    final_sign_a3_reg11 <= sign_abcdefgh_r1_reg10 ^ sign_a3_reg10;
    final_sign_a4_reg11 <= sign_abcdefgh_r1_reg10 ^ sign_a4_reg10;
    final_sign_a5_reg11 <= sign_abcdefgh_r1_reg10 ^ sign_a5_reg10;
    final_sign_a6_reg11 <= sign_abcdefgh_r1_reg10 ^ sign_a6_reg10;

    first_min_reg11 <= first_min_reg10;
    second_min_reg11 <= second_min_reg10;
    min_location_reg11 <= min_location_reg10;
end

// Send result to output
logic [7:0] neg_first_min;
logic [7:0] neg_second_min;
assign neg_first_min = -first_min_reg11;
assign neg_second_min = -second_min_reg11;
always_ff @ (posedge i_clock) begin
    case ({ min_location_reg11[0], final_sign_a0_reg11 })
        2'b11:   o_data_a0 <= neg_second_min;
        2'b01:   o_data_a0 <= neg_first_min;
        2'b10:   o_data_a0 <= second_min_reg11;
        default: o_data_a0 <= first_min_reg11;
    endcase
    case ({ min_location_reg11[1], final_sign_a1_reg11 })
        2'b11:   o_data_a1 <= neg_second_min;
        2'b01:   o_data_a1 <= neg_first_min;
        2'b10:   o_data_a1 <= second_min_reg11;
        default: o_data_a1 <= first_min_reg11;
    endcase
    case ({ min_location_reg11[2], final_sign_a2_reg11 })
        2'b11:   o_data_a2 <= neg_second_min;
        2'b01:   o_data_a2 <= neg_first_min;
        2'b10:   o_data_a2 <= second_min_reg11;
        default: o_data_a2 <= first_min_reg11;
    endcase
    case ({ min_location_reg11[3], final_sign_a3_reg11 })
        2'b11:   o_data_a3 <= neg_second_min;
        2'b01:   o_data_a3 <= neg_first_min;
        2'b10:   o_data_a3 <= second_min_reg11;
        default: o_data_a3 <= first_min_reg11;
    endcase
    case ({ min_location_reg11[4], final_sign_a4_reg11 })
        2'b11:   o_data_a4 <= neg_second_min;
        2'b01:   o_data_a4 <= neg_first_min;
        2'b10:   o_data_a4 <= second_min_reg11;
        default: o_data_a4 <= first_min_reg11;
    endcase
    case ({ min_location_reg11[5], final_sign_a5_reg11 })
        2'b11:   o_data_a5 <= neg_second_min;
        2'b01:   o_data_a5 <= neg_first_min;
        2'b10:   o_data_a5 <= second_min_reg11;
        default: o_data_a5 <= first_min_reg11;
    endcase
    case ({ min_location_reg11[6], final_sign_a6_reg11 })
        2'b11:   o_data_a6 <= neg_second_min;
        2'b01:   o_data_a6 <= neg_first_min;
        2'b10:   o_data_a6 <= second_min_reg11;
        default: o_data_a6 <= first_min_reg11;
    endcase
end

logic [11:0] valid_regs;
always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        valid_regs <= 0;
        o_valid <= 1'b0;
    end else begin
        valid_regs[11:0] <= { valid_regs[11-1:0], i_valid };
        o_valid <= valid_regs[11];
    end
end

endmodule: ldpc_minsigner

`default_nettype wire
