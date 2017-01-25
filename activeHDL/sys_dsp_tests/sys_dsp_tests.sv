`timescale 10ps / 10ps

`default_nettype none

module sys_dsp_tests (
    input  wire logic [17:0] i_term_a_data,
    input  wire logic [17:0] i_term_b_data,
    input  wire logic [17:0] i_term_c_data,
    output      logic [17:0] o_sum_data,
    input  wire logic        i_clock,
    input  wire logic        i_reset
);

wire PA17,PA16,PA15,PA14,PA13,PA12,PA11,PA10,PA9,PA8,PA7,PA6,PA5,PA4,PA3,PA2,PA1,PA0;
wire PB17,PB16,PB15,PB14,PB13,PB12,PB11,PB10,PB9,PB8,PB7,PB6,PB5,PB4,PB3,PB2,PB1,PB0;
wire C17,C16,C15,C14,C13,C12,C11,C10,C9,C8,C7,C6,C5,C4,C3,C2,C1,C0;
wire SOURCEA,OPPRE;
wire CE0,CE1,CE2,CE3,CLK0,CLK1,CLK2,CLK3,RST0,RST1,RST2,RST3;
wire SRIA17,SRIA16,SRIA15,SRIA14,SRIA13,SRIA12,SRIA11,SRIA10,SRIA9;
wire SRIA8,SRIA7,SRIA6,SRIA5,SRIA4,SRIA3,SRIA2,SRIA1,SRIA0;
wire SRIB17,SRIB16,SRIB15,SRIB14,SRIB13,SRIB12,SRIB11,SRIB10,SRIB9;
wire SRIB8,SRIB7,SRIB6,SRIB5,SRIB4,SRIB3,SRIB2,SRIB1,SRIB0;
wire SROA17,SROA16,SROA15,SROA14,SROA13,SROA12,SROA11,SROA10,SROA9;
wire SROA8,SROA7,SROA6,SROA5,SROA4,SROA3,SROA2,SROA1,SROA0;
wire SROB17,SROB16,SROB15,SROB14,SROB13,SROB12,SROB11,SROB10,SROB9;
wire SROB8,SROB7,SROB6,SROB5,SROB4,SROB3,SROB2,SROB1,SROB0;
wire PO17,PO16,PO15,PO14,PO13,PO12,PO11,PO10,PO9;
wire PO8,PO7,PO6,PO5,PO4,PO3,PO2,PO1,PO0;

PRADD18A #(
    .REG_INPUTA_CLK("CLK0"),
    .REG_INPUTB_CLK("CLK0"),
    .REG_INPUTC_CLK("CLK0"),
    .REG_OPPRE_CLK("CLK0"),
    .CAS_MATCH_REG("FALSE"),
    .SOURCEA_MODE("A_SHIFT"),
    .SOURCEB_MODE("PARALLEL"),
    .FB_MUX("DISABLED"),
    .SYMMETRY_MODE("INTERNAL"))
preadder_inst(.*) /* synthesis SOURCEB_MODE="PARALLEL" */;

assign CE0 = 1'b1;
assign CE1 = 1'b1;
assign CE2 = 1'b1;
assign CE3 = 1'b1;

assign CLK0 = i_clock;
assign CLK1 = i_clock;
assign CLK2 = i_clock;
assign CLK3 = i_clock;

assign RST0 = i_reset;
assign RST1 = i_reset;
assign RST2 = i_reset;
assign RST3 = i_reset;

assign SOURCEA = 1'b1;
assign OPPRE = 1'b0;

assign PA17 = i_term_a_data[17];
assign PA16 = i_term_a_data[16];
assign PA15 = i_term_a_data[15];
assign PA14 = i_term_a_data[14];
assign PA13 = i_term_a_data[13];
assign PA12 = i_term_a_data[12];
assign PA11 = i_term_a_data[11];
assign PA10 = i_term_a_data[10];
assign PA9 = i_term_a_data[9];
assign PA8 = i_term_a_data[8];
assign PA7 = i_term_a_data[7];
assign PA6 = i_term_a_data[6];
assign PA5 = i_term_a_data[5];
assign PA4 = i_term_a_data[4];
assign PA3 = i_term_a_data[3];
assign PA2 = i_term_a_data[2];
assign PA1 = i_term_a_data[1];
assign PA0 = i_term_a_data[0];

assign PB17 = i_term_b_data[17];
assign PB16 = i_term_b_data[16];
assign PB15 = i_term_b_data[15];
assign PB14 = i_term_b_data[14];
assign PB13 = i_term_b_data[13];
assign PB12 = i_term_b_data[12];
assign PB11 = i_term_b_data[11];
assign PB10 = i_term_b_data[10];
assign PB9 = i_term_b_data[9];
assign PB8 = i_term_b_data[8];
assign PB7 = i_term_b_data[7];
assign PB6 = i_term_b_data[6];
assign PB5 = i_term_b_data[5];
assign PB4 = i_term_b_data[4];
assign PB3 = i_term_b_data[3];
assign PB2 = i_term_b_data[2];
assign PB1 = i_term_b_data[1];
assign PB0 = i_term_b_data[0];

assign C17 = i_term_c_data[17];
assign C16 = i_term_c_data[16];
assign C15 = i_term_c_data[15];
assign C14 = i_term_c_data[14];
assign C13 = i_term_c_data[13];
assign C12 = i_term_c_data[12];
assign C11 = i_term_c_data[11];
assign C10 = i_term_c_data[10];
assign C9 = i_term_c_data[9];
assign C8 = i_term_c_data[8];
assign C7 = i_term_c_data[7];
assign C6 = i_term_c_data[6];
assign C5 = i_term_c_data[5];
assign C4 = i_term_c_data[4];
assign C3 = i_term_c_data[3];
assign C2 = i_term_c_data[2];
assign C1 = i_term_c_data[1];
assign C0 = i_term_c_data[0];

assign SRIA17 = 1'b1;
assign SRIA16 = 1'b1;
assign SRIA15 = 1'b1;
assign SRIA14 = 1'b1;
assign SRIA13 = 1'b1;
assign SRIA12 = 1'b1;
assign SRIA11 = 1'b1;
assign SRIA10 = 1'b1;
assign SRIA9 = 1'b1;
assign SRIA8 = 1'b1;
assign SRIA7 = 1'b1;
assign SRIA6 = 1'b1;
assign SRIA5 = 1'b1;
assign SRIA4 = 1'b1;
assign SRIA3 = 1'b1;
assign SRIA2 = 1'b1;
assign SRIA1 = 1'b1;
assign SRIA0 = 1'b1;

assign SRIB17 = 1'b1;
assign SRIB16 = 1'b1;
assign SRIB15 = 1'b1;
assign SRIB14 = 1'b1;
assign SRIB13 = 1'b1;
assign SRIB12 = 1'b1;
assign SRIB11 = 1'b1;
assign SRIB10 = 1'b1;
assign SRIB9 = 1'b1;
assign SRIB8 = 1'b1;
assign SRIB7 = 1'b1;
assign SRIB6 = 1'b1;
assign SRIB5 = 1'b1;
assign SRIB4 = 1'b1;
assign SRIB3 = 1'b1;
assign SRIB2 = 1'b1;
assign SRIB1 = 1'b1;
assign SRIB0 = 1'b1;

assign o_sum_data = {
    PO17, PO16, PO15, PO14, PO13, PO12,
    PO11, PO10, PO9,  PO8,  PO7,  PO6,
    PO5,  PO4,  PO3,  PO2,  PO1,  PO0
};

endmodule: sys_dsp_tests

`default_nettype wire
