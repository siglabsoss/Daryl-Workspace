`timescale 1ps/1ps

`default_nettype none

module ldpc_encoder (
    input  wire logic [7:0] i_in_data,
    input  wire logic       i_in_valid,
    output      logic       o_in_ready,
    output      logic [7:0] o_out_data,
    output      logic       o_out_valid,
    input  wire logic       i_out_ready,
    input  wire logic       i_clock,
    input  wire logic       i_reset
);

logic [95:0] out_data_A;
logic        out_valid_A;
logic        out_ready_A;
logic        in_ready_A;

logic [95:0] out_data_C;
logic        out_valid_C;
logic        out_ready_C;
logic        in_ready_C;

logic concatenator_ready_1;

// Input is ready only when all modules are ready
assign o_in_ready = in_ready_A & in_ready_C & concatenator_ready_1;

sparse_mult_by_A sparse_mult_by_A_inst (
    .i_in_data  (i_in_data                                     ),
    .i_in_valid (i_in_valid & in_ready_C & concatenator_ready_1),
    .o_in_ready (in_ready_A                                    ),
    .o_out_data (out_data_A                                    ),
    .o_out_valid(out_valid_A                                   ),
    .i_out_ready(out_ready_A                                   ),
    .i_clock    (i_clock                                       ),
    .i_reset    (i_reset                                       ));

sparse_mult_by_C sparse_mult_by_C_inst (
    .i_in_data  (i_in_data                                     ),
    .i_in_valid (i_in_valid & in_ready_A & concatenator_ready_1),
    .o_in_ready (in_ready_C                                    ),
    .o_out_data (out_data_C                                    ),
    .o_out_valid(out_valid_C                                   ),
    .i_out_ready(out_ready_C                                   ),
    .i_clock    (i_clock                                       ),
    .i_reset    (i_reset                                       ));

logic [95:0] out_data_backsub_0;
logic        out_valid_backsub_0;
logic        out_ready_backsub_0;

logic [95:0] out_data_delay_0;
logic        out_valid_delay_0;
logic        out_ready_delay_0;

logic in_ready_delay_0;
logic in_ready_backsub_0;
// Ready for next output only when all downstream modules are ready
assign out_ready_C = in_ready_backsub_0 & in_ready_delay_0;

dual_diagonal_backsub dual_diagonal_backsub_0_inst (
    .i_in_data  (out_data_A                    ),
    .i_in_valid (out_valid_A & in_ready_delay_0),
    .o_in_ready (in_ready_backsub_0            ),
    .o_out_data (out_data_backsub_0            ),
    .o_out_valid(out_valid_backsub_0           ),
    .i_out_ready(out_ready_backsub_0           ),
    .i_clock    (i_clock                       ),
    .i_reset    (i_reset                       ));

delay_buffer delay_buffer_0_inst (
    .i_in_data  (out_data_A                      ),
    .i_in_valid (out_valid_A & in_ready_backsub_0),
    .o_in_ready (in_ready_delay_0                ),
    .o_out_data (out_data_delay_0                ),
    .o_out_valid(out_valid_delay_0               ),
    .i_out_ready(out_ready_delay_0               ),
    .i_clock    (i_clock                         ),
    .i_reset    (i_reset                         ));

logic [95:0] out_data_E;
logic        out_valid_E;
logic        out_ready_E;

sparse_mult_by_E sparse_mult_by_E_inst (
    .i_in_data  (out_data_backsub_0 ),
    .i_in_valid (out_valid_backsub_0),
    .o_in_ready (out_ready_backsub_0),
    .o_out_data (out_data_E         ),
    .o_out_valid(out_valid_E        ),
    .i_out_ready(out_ready_E        ),
    .i_clock    (i_clock            ),
    .i_reset    (i_reset            ));

logic [95:0] out_data_delay_1;
logic        out_valid_delay_1;
logic        out_ready_delay_1;

delay_buffer delay_buffer_1_inst (
    .i_in_data  (out_data_C       ),
    .i_in_valid (out_valid_C      ),
    .o_in_ready (out_ready_C      ),
    .o_out_data (out_data_delay_1 ),
    .o_out_valid(out_valid_delay_1),
    .i_out_ready(out_ready_delay_1),
    .i_clock    (i_clock          ),
    .i_reset    (i_reset          ));

logic [95:0] sum_data_0;
logic        sum_valid_0;
logic        sum_ready_0;
logic        in_ready_B_0;
logic        concatenator_ready_2;

assign sum_ready_0 = in_ready_B_0 & concatenator_ready_2;

adder_gf2 #(
    .WIDTH(96))
adder_gf2_0_inst (
    .i_lhs_data (out_data_E       ),
    .i_lhs_valid(out_valid_E      ),
    .o_lhs_ready(out_ready_E      ),
    .i_rhs_data (out_data_delay_1 ),
    .i_rhs_valid(out_valid_delay_1),
    .o_rhs_ready(out_ready_delay_1),
    .o_sum_data (sum_data_0       ),
    .o_sum_valid(sum_valid_0      ),
    .i_sum_ready(sum_ready_0      ),
    .i_clock    (i_clock          ),
    .i_reset    (i_reset          ));

logic [95:0] out_data_B;
logic        out_valid_B;
logic        out_ready_B;

sparse_mult_by_B sparse_mult_by_B_inst (
    .i_in_data  (sum_data_0  ),
    .i_in_valid (sum_valid_0 ),
    .o_in_ready (in_ready_B_0),
    .o_out_data (out_data_B  ),
    .o_out_valid(out_valid_B ),
    .i_out_ready(out_ready_B ),
    .i_clock    (i_clock     ),
    .i_reset    (i_reset     ));

logic [95:0] sum_data_1;
logic        sum_valid_1;
logic        sum_ready_1;

adder_gf2 #(
    .WIDTH(96))
adder_gf2_1_inst (
    .i_lhs_data (out_data_delay_0 ),
    .i_lhs_valid(out_valid_delay_0),
    .o_lhs_ready(out_ready_delay_0),
    .i_rhs_data (out_data_B       ),
    .i_rhs_valid(out_valid_B      ),
    .o_rhs_ready(out_ready_B      ),
    .o_sum_data (sum_data_1       ),
    .o_sum_valid(sum_valid_1      ),
    .i_sum_ready(sum_ready_1      ),
    .i_clock    (i_clock          ),
    .i_reset    (i_reset          ));

logic [95:0] out_data_backsub_1;
logic        out_valid_backsub_1;
logic        out_ready_backsub_1;

dual_diagonal_backsub dual_diagonal_backsub_1_inst (
    .i_in_data  (sum_data_1         ),
    .i_in_valid (sum_valid_1        ),
    .o_in_ready (sum_ready_1        ),
    .o_out_data (out_data_backsub_1 ),
    .o_out_valid(out_valid_backsub_1),
    .i_out_ready(out_ready_backsub_1),
    .i_clock    (i_clock            ),
    .i_reset    (i_reset            ));

concatenator concatenator_inst (
    .i_first_data        (i_in_data                             ),
    .i_first_valid       (i_in_valid & out_ready_A & out_ready_C),
    .i_first_ready       (concatenator_ready_1                  ),
    .i_second_data       (sum_data_0                            ),
    .i_second_valid      (sum_valid_0 & in_ready_B_0            ),
    .i_second_ready      (concatenator_ready_2                  ),
    .i_third_data        (out_data_backsub_1                    ),
    .i_third_valid       (out_valid_backsub_1                   ),
    .i_third_ready       (out_ready_backsub_1                   ),
    .o_concatenated_data (o_out_data                            ),
    .o_concatenated_valid(o_out_valid                           ),
    .o_concatenated_ready(o_out_ready                           ),
    .i_clock             (i_clock                               ),
    .i_reset             (i_reset                               ));

endmodule: ldpc_encoder

`default_nettype wire
