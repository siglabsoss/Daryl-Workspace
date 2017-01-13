// concatenator.sv
//
// WIDTHs and DEPTHs are optimized for 18 Kbit EBR

`timescale 10ps / 10ps

`default_nettype none

module concatenator #(
    parameter integer OUT_WIDTH = 8,
    parameter integer WIDTH1 = 8,
    parameter integer WIDTH2 = 96,
    parameter integer WIDTH3 = 96,
    parameter integer DEPTH1 = 2304,
    parameter integer DEPTH2 = 192,
    parameter integer DEPTH3 = 192
) (
    input  wire logic [WIDTH1-1:0]    i_first_data,
    input  wire logic                 i_first_valid,
    output      logic                 o_first_ready,
    input  wire logic [WIDTH2-1:0]    i_second_data,
    input  wire logic                 i_second_valid,
    output      logic                 o_second_ready,
    input  wire logic [WIDTH3-1:0]    i_third_data,
    input  wire logic                 i_third_valid,
    output      logic                 o_third_ready,
    output      logic [OUT_WIDTH-1:0] o_out_data,
    output      logic                 o_out_valid,
    input  wire logic                 i_out_ready,
    input  wire logic                 i_clock,
    input  wire logic                 i_reset
);

logic [WIDTH1-1:0] first_buffer  [0:DEPTH1-1] /* synthesis syn_ramstyle = "block_ram" */;
logic [WIDTH2-1:0] second_buffer [0:DEPTH2-1] /* synthesis syn_ramstyle = "block_ram" */;
logic [WIDTH3-1:0] third_buffer  [0:DEPTH3-1] /* synthesis syn_ramstyle = "block_ram" */;

logic [$clog2(DEPTH1)-1:0] first_head;
logic [$clog2(DEPTH1)-1:0] first_tail;
logic [$clog2(DEPTH2)-1:0] second_head;
logic [$clog2(DEPTH2)-1:0] second_tail;
logic [$clog2(DEPTH3)-1:0] third_head;
logic [$clog2(DEPTH3)-1:0] third_tail;

always @(posedge i_clock) begin
    if (i_reset == 1'b1) begin
        o_out_data <= 0;
        o_out_valid <= 1'b0;
    end else begin
        o_out_data <= i_in_data;
        o_out_valid <= i_in_valid;
    end
end

endmodule: concatenator

`default_nettype wire
