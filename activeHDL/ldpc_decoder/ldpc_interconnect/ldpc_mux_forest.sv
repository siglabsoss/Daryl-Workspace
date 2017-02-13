// ldpc_mux_forest.sv
//

`timescale 10ps / 10ps

`default_nettype none

module ldpc_mux_forest #(
    parameter integer WIDTH = 8,
    parameter integer NUM_RAMS = 24,
    parameter integer EXPANSION_FACTOR = 96
) (
    input  logic [8*WIDTH-1:0]                             i_data,
    input  logic [8*$clog2(EXPANSION_FACTOR)-1:0]          i_offset,
    input  logic [8*$clog2(NUM_RAMS)-1:0]                  i_ram_addr,
    input  logic [8*$clog2(8)-1:0]                         i_to_branch,
    input  logic                                           i_valid,
    output logic [8*NUM_RAMS*WIDTH-1:0]                    o_data,
    output logic [8*NUM_RAMS*$clog2(EXPANSION_FACTOR)-1:0] o_addr,
    output logic [8*NUM_RAMS-1:0]                          o_valid,
    input  logic                                           i_clock,
    input  logic                                           i_reset
);

localparam integer IN_BRANCHES = 8;
localparam integer OUT_BRANCHES = 8;

genvar branch_number;
genvar ram_number;
generate
for (branch_number = 0; branch_number < OUT_BRANCHES; branch_number++) begin
    for (ram_number = 0; ram_number < NUM_RAMS; ram_number++) begin
        ldpc_mux_tree #(
            .WIDTH           (WIDTH           ),
            .NUM_RAMS        (NUM_RAMS        ),
            .EXPANSION_FACTOR(EXPANSION_FACTOR),
            .TO_BRANCH       (tree_number     ),
            .TO_RAM          (ram_number      ))
        ldpc_mux_tree_inst (
            .i_data     (i_data                                                                                                                                     ),
            .i_offset   (i_offset                                                                                                                                   ),
            .i_ram_addr (i_ram_addr                                                                                                                                 ),
            .i_to_branch(i_to_branch                                                                                                                                ),
            .i_valid    (i_valid                                                                                                                                    ),
            .o_data     (o_data[(branch_number*NUM_RAMS + ram_number + 1)*WIDTH-1:(branch_number*NUM_RAMS + ram_number)*WIDTH]                                      ),
            .o_addr     (o_addr[(branch_number*NUM_RAMS + ram_number + 1)*$clog2(EXPANSION_FACTOR)-1:(branch_number*NUM_RAMS + ram_number)*$clog2(EXPANSION_FACTOR)]),
            .o_valid    (o_valid[branch_number*NUM_RAMS + ram_number]                                                                                               ),
            .i_clock    (i_clock                                                                                                                                    ),
            .i_reset    (i_reset                                                                                                                                    ));
    end
end
endgenerate

endmodule: ldpc_mux_forest

`default_nettype wire
