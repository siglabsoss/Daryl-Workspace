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

// Input is ready only when all modules are ready
assign o_in_ready = in_ready_A & in_ready_C;

sparse_mult_by_A sparse_mult_by_A_inst (
    .i_in_data  (i_in_data              ),
    .i_in_valid (i_in_valid & in_ready_C),
    .o_in_ready (in_ready_A             ),
    .o_out_data (out_data_A             ),
    .o_out_valid(out_valid_A            ),
    .i_out_ready(out_ready_A            ),
    .i_clock    (i_clock                ),
    .i_reset    (i_reset                ));

sparse_mult_by_C sparse_mult_by_C_inst (
    .i_in_data  (i_in_data              ),
    .i_in_valid (i_in_valid & in_ready_A),
    .o_in_ready (in_ready_C             ),
    .o_out_data (out_data_C             ),
    .o_out_valid(out_valid_C            ),
    .i_out_ready(out_ready_C            ),
    .i_clock    (i_clock                ),
    .i_reset    (i_reset                ));

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
    .i_in_data  (out_data_backsub_0              ),
    .i_in_valid (out_valid_backsub_0             ),
    .o_in_ready (out_ready_backsub_0             ),
    .o_out_data (out_data_E                      ),
    .o_out_valid(out_valid_E                     ),
    .i_out_ready(out_ready_E                     ),
    .i_clock    (i_clock                         ),
    .i_reset    (i_reset                         ));

delay_buffer delay_buffer_1_inst (
    .i_in_data  (out_data_C                      ),
    .i_in_valid (out_valid_C                     ),
    .o_in_ready (out_ready_C                     ),
    .o_out_data (out_data_delay_1                ),
    .o_out_valid(out_data_delay_2                ),
    .i_out_ready(out_data_delay_3                ),
    .i_clock    (i_clock                         ),
    .i_reset    (i_reset                         ));

adder_gf2 adder_gf2_0_inst (
    .i_lhs_data (),
    .i_lhs_valid(),
    .o_lhs_ready(),
    .i_rhs_data (),
    .i_rhs_valid(),
    .o_rhs_ready(),
    .o_sum_data (),
    .o_sum_valid(),
    .i_sum_ready(),
    .i_clock    (),
    .i_reset    ());

sparse_mult_by_B sparse_mult_by_B_inst (
    );

adder_gf2 adder_gf2_1_inst (
    .i_lhs_data (),
    .i_lhs_valid(),
    .o_lhs_ready(),
    .i_rhs_data (),
    .i_rhs_valid(),
    .o_rhs_ready(),
    .o_sum_data (),
    .o_sum_valid(),
    .i_sum_ready(),
    .i_clock    (),
    .i_reset    ());

dual_diagonal_backsub dual_diagonal_backsub_1_inst (
    .i_in_data  (out_data_A                    ),
    .i_in_valid (out_valid_A & in_ready_delay_0),
    .o_in_ready (in_ready_backsub_0            ),
    .o_out_data (out_data_backsub_0            ),
    .o_out_valid(out_valid_backsub_0           ),
    .i_out_ready(out_ready_backsub_0           ),
    .i_clock    (i_clock                       ),
    .i_reset    (i_reset                       ));

endmodule: ldpc_encoder

`default_nettype wire
