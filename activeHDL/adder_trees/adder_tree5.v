`timescale 1 ns / 1 ps

module adder_tree5 (
    input  wire [15:0] i_data_a0,
    input  wire [15:0] i_data_a1,
    input  wire [15:0] i_data_a2,
    input  wire [15:0] i_data_a3,
    input  wire [15:0] i_data_a4,
    input  wire        i_clock,
    input  wire        i_enable,
    input  wire        i_reset,
    output wire [15:0] o_result);


    wire adder_tree5_alu_signedr_1_0;
    wire adder_tree5_alu_output_r_1_0_53;
    wire adder_tree5_alu_output_r_1_0_52;
    wire adder_tree5_alu_output_r_1_0_51;
    wire adder_tree5_alu_output_r_1_0_50;
    wire adder_tree5_alu_output_r_1_0_49;
    wire adder_tree5_alu_output_r_1_0_48;
    wire adder_tree5_alu_output_r_1_0_47;
    wire adder_tree5_alu_output_r_1_0_46;
    wire adder_tree5_alu_output_r_1_0_45;
    wire adder_tree5_alu_output_r_1_0_44;
    wire adder_tree5_alu_output_r_1_0_43;
    wire adder_tree5_alu_output_r_1_0_42;
    wire adder_tree5_alu_output_r_1_0_41;
    wire adder_tree5_alu_output_r_1_0_40;
    wire adder_tree5_alu_output_r_1_0_39;
    wire adder_tree5_alu_output_r_1_0_38;
    wire adder_tree5_alu_output_r_1_0_37;
    wire adder_tree5_alu_output_r_1_0_36;
    wire adder_tree5_alu_output_r_1_0_35;
    wire adder_tree5_alu_output_r_1_0_34;
    wire adder_tree5_alu_output_r_1_0_33;
    wire adder_tree5_alu_output_r_1_0_32;
    wire adder_tree5_alu_output_r_1_0_31;
    wire adder_tree5_alu_output_r_1_0_30;
    wire adder_tree5_alu_output_r_1_0_29;
    wire adder_tree5_alu_output_r_1_0_28;
    wire adder_tree5_alu_output_r_1_0_27;
    wire adder_tree5_alu_output_r_1_0_26;
    wire adder_tree5_alu_output_r_1_0_25;
    wire adder_tree5_alu_output_r_1_0_24;
    wire adder_tree5_alu_output_r_1_0_23;
    wire adder_tree5_alu_output_r_1_0_22;
    wire adder_tree5_alu_output_r_1_0_21;
    wire adder_tree5_alu_output_r_1_0_20;
    wire adder_tree5_alu_output_r_1_0_19;
    wire adder_tree5_alu_output_r_1_0_18;
    wire adder_tree5_alu_output_r_1_0_17;
    wire adder_tree5_alu_output_r_1_0_16;
    wire adder_tree5_alu_output_r_1_0_15;
    wire adder_tree5_alu_output_r_1_0_14;
    wire adder_tree5_alu_output_r_1_0_13;
    wire adder_tree5_alu_output_r_1_0_12;
    wire adder_tree5_alu_output_r_1_0_11;
    wire adder_tree5_alu_output_r_1_0_10;
    wire adder_tree5_alu_output_r_1_0_9;
    wire adder_tree5_alu_output_r_1_0_8;
    wire adder_tree5_alu_output_r_1_0_7;
    wire adder_tree5_alu_output_r_1_0_6;
    wire adder_tree5_alu_output_r_1_0_5;
    wire adder_tree5_alu_output_r_1_0_4;
    wire adder_tree5_alu_output_r_1_0_3;
    wire adder_tree5_alu_output_r_1_0_2;
    wire adder_tree5_alu_output_r_1_0_1;
    wire adder_tree5_alu_output_r_1_0_0;
    wire adder_tree5_alu_signedcin_1_0;
    wire adder_tree5_alu_in_cin_1_0_53;
    wire adder_tree5_alu_in_cin_1_0_52;
    wire adder_tree5_alu_in_cin_1_0_51;
    wire adder_tree5_alu_in_cin_1_0_50;
    wire adder_tree5_alu_in_cin_1_0_49;
    wire adder_tree5_alu_in_cin_1_0_48;
    wire adder_tree5_alu_in_cin_1_0_47;
    wire adder_tree5_alu_in_cin_1_0_46;
    wire adder_tree5_alu_in_cin_1_0_45;
    wire adder_tree5_alu_in_cin_1_0_44;
    wire adder_tree5_alu_in_cin_1_0_43;
    wire adder_tree5_alu_in_cin_1_0_42;
    wire adder_tree5_alu_in_cin_1_0_41;
    wire adder_tree5_alu_in_cin_1_0_40;
    wire adder_tree5_alu_in_cin_1_0_39;
    wire adder_tree5_alu_in_cin_1_0_38;
    wire adder_tree5_alu_in_cin_1_0_37;
    wire adder_tree5_alu_in_cin_1_0_36;
    wire adder_tree5_alu_in_cin_1_0_35;
    wire adder_tree5_alu_in_cin_1_0_34;
    wire adder_tree5_alu_in_cin_1_0_33;
    wire adder_tree5_alu_in_cin_1_0_32;
    wire adder_tree5_alu_in_cin_1_0_31;
    wire adder_tree5_alu_in_cin_1_0_30;
    wire adder_tree5_alu_in_cin_1_0_29;
    wire adder_tree5_alu_in_cin_1_0_28;
    wire adder_tree5_alu_in_cin_1_0_27;
    wire adder_tree5_alu_in_cin_1_0_26;
    wire adder_tree5_alu_in_cin_1_0_25;
    wire adder_tree5_alu_in_cin_1_0_24;
    wire adder_tree5_alu_in_cin_1_0_23;
    wire adder_tree5_alu_in_cin_1_0_22;
    wire adder_tree5_alu_in_cin_1_0_21;
    wire adder_tree5_alu_in_cin_1_0_20;
    wire adder_tree5_alu_in_cin_1_0_19;
    wire adder_tree5_alu_in_cin_1_0_18;
    wire adder_tree5_alu_in_cin_1_0_17;
    wire adder_tree5_alu_in_cin_1_0_16;
    wire adder_tree5_alu_in_cin_1_0_15;
    wire adder_tree5_alu_in_cin_1_0_14;
    wire adder_tree5_alu_in_cin_1_0_13;
    wire adder_tree5_alu_in_cin_1_0_12;
    wire adder_tree5_alu_in_cin_1_0_11;
    wire adder_tree5_alu_in_cin_1_0_10;
    wire adder_tree5_alu_in_cin_1_0_9;
    wire adder_tree5_alu_in_cin_1_0_8;
    wire adder_tree5_alu_in_cin_1_0_7;
    wire adder_tree5_alu_in_cin_1_0_6;
    wire adder_tree5_alu_in_cin_1_0_5;
    wire adder_tree5_alu_in_cin_1_0_4;
    wire adder_tree5_alu_in_cin_1_0_3;
    wire adder_tree5_alu_in_cin_1_0_2;
    wire adder_tree5_alu_in_cin_1_0_1;
    wire adder_tree5_alu_in_cin_1_0_0;
    wire adder_tree5_alu_signedr_2_0;
    wire adder_tree5_alu_output_r_2_0_53;
    wire adder_tree5_alu_output_r_2_0_52;
    wire adder_tree5_alu_output_r_2_0_51;
    wire adder_tree5_alu_output_r_2_0_50;
    wire adder_tree5_alu_output_r_2_0_49;
    wire adder_tree5_alu_output_r_2_0_48;
    wire adder_tree5_alu_output_r_2_0_47;
    wire adder_tree5_alu_output_r_2_0_46;
    wire adder_tree5_alu_output_r_2_0_45;
    wire adder_tree5_alu_output_r_2_0_44;
    wire adder_tree5_alu_output_r_2_0_43;
    wire adder_tree5_alu_output_r_2_0_42;
    wire adder_tree5_alu_output_r_2_0_41;
    wire adder_tree5_alu_output_r_2_0_40;
    wire adder_tree5_alu_output_r_2_0_39;
    wire adder_tree5_alu_output_r_2_0_38;
    wire adder_tree5_alu_output_r_2_0_37;
    wire adder_tree5_alu_output_r_2_0_36;
    wire adder_tree5_alu_output_r_2_0_35;
    wire adder_tree5_alu_output_r_2_0_34;
    wire adder_tree5_alu_output_r_2_0_33;
    wire adder_tree5_alu_output_r_2_0_32;
    wire adder_tree5_alu_output_r_2_0_31;
    wire adder_tree5_alu_output_r_2_0_30;
    wire adder_tree5_alu_output_r_2_0_29;
    wire adder_tree5_alu_output_r_2_0_28;
    wire adder_tree5_alu_output_r_2_0_27;
    wire adder_tree5_alu_output_r_2_0_26;
    wire adder_tree5_alu_output_r_2_0_25;
    wire adder_tree5_alu_output_r_2_0_24;
    wire adder_tree5_alu_output_r_2_0_23;
    wire adder_tree5_alu_output_r_2_0_22;
    wire adder_tree5_alu_output_r_2_0_21;
    wire adder_tree5_alu_output_r_2_0_20;
    wire adder_tree5_alu_output_r_2_0_19;
    wire adder_tree5_alu_output_r_2_0_18;
    wire adder_tree5_alu_output_r_2_0_17;
    wire adder_tree5_alu_output_r_2_0_16;
    wire adder_tree5_alu_output_r_2_0_15;
    wire adder_tree5_alu_output_r_2_0_14;
    wire adder_tree5_alu_output_r_2_0_13;
    wire adder_tree5_alu_output_r_2_0_12;
    wire adder_tree5_alu_output_r_2_0_11;
    wire adder_tree5_alu_output_r_2_0_10;
    wire adder_tree5_alu_output_r_2_0_9;
    wire adder_tree5_alu_output_r_2_0_8;
    wire adder_tree5_alu_output_r_2_0_7;
    wire adder_tree5_alu_output_r_2_0_6;
    wire adder_tree5_alu_output_r_2_0_5;
    wire adder_tree5_alu_output_r_2_0_4;
    wire adder_tree5_alu_output_r_2_0_3;
    wire adder_tree5_alu_output_r_2_0_2;
    wire adder_tree5_alu_output_r_2_0_1;
    wire adder_tree5_alu_output_r_2_0_0;
    wire adder_tree5_0zs;
    wire adder_tree5_0z_53;
    wire adder_tree5_0z_52;
    wire adder_tree5_0z_51;
    wire adder_tree5_0z_50;
    wire adder_tree5_0z_49;
    wire adder_tree5_0z_48;
    wire adder_tree5_0z_47;
    wire adder_tree5_0z_46;
    wire adder_tree5_0z_45;
    wire adder_tree5_0z_44;
    wire adder_tree5_0z_43;
    wire adder_tree5_0z_42;
    wire adder_tree5_0z_41;
    wire adder_tree5_0z_40;
    wire adder_tree5_0z_39;
    wire adder_tree5_0z_38;
    wire adder_tree5_0z_37;
    wire adder_tree5_0z_36;
    wire adder_tree5_0z_35;
    wire adder_tree5_0z_34;
    wire adder_tree5_0z_33;
    wire adder_tree5_0z_32;
    wire adder_tree5_0z_31;
    wire adder_tree5_0z_30;
    wire adder_tree5_0z_29;
    wire adder_tree5_0z_28;
    wire adder_tree5_0z_27;
    wire adder_tree5_0z_26;
    wire adder_tree5_0z_25;
    wire adder_tree5_0z_24;
    wire adder_tree5_0z_23;
    wire adder_tree5_0z_22;
    wire adder_tree5_0z_21;
    wire adder_tree5_0z_20;
    wire adder_tree5_0z_19;
    wire adder_tree5_0z_18;
    wire adder_tree5_0z_17;
    wire adder_tree5_0z_16;
    wire adder_tree5_0z_15;
    wire adder_tree5_0z_14;
    wire adder_tree5_0z_13;
    wire adder_tree5_0z_12;
    wire adder_tree5_0z_11;
    wire adder_tree5_0z_10;
    wire adder_tree5_0z_9;
    wire adder_tree5_0z_8;
    wire adder_tree5_0z_7;
    wire adder_tree5_0z_6;
    wire adder_tree5_0z_5;
    wire adder_tree5_0z_4;
    wire adder_tree5_0z_3;
    wire adder_tree5_0z_2;
    wire adder_tree5_0z_1;
    wire adder_tree5_0z_0;
    wire adder_tree5_0_mult_out_rob_0_17;
    wire adder_tree5_0_mult_out_roa_0_17;
    wire adder_tree5_0_mult_out_rob_0_16;
    wire adder_tree5_0_mult_out_roa_0_16;
    wire adder_tree5_0_mult_out_rob_0_15;
    wire adder_tree5_0_mult_out_roa_0_15;
    wire adder_tree5_0_mult_out_rob_0_14;
    wire adder_tree5_0_mult_out_roa_0_14;
    wire adder_tree5_0_mult_out_rob_0_13;
    wire adder_tree5_0_mult_out_roa_0_13;
    wire adder_tree5_0_mult_out_rob_0_12;
    wire adder_tree5_0_mult_out_roa_0_12;
    wire adder_tree5_0_mult_out_rob_0_11;
    wire adder_tree5_0_mult_out_roa_0_11;
    wire adder_tree5_0_mult_out_rob_0_10;
    wire adder_tree5_0_mult_out_roa_0_10;
    wire adder_tree5_0_mult_out_rob_0_9;
    wire adder_tree5_0_mult_out_roa_0_9;
    wire adder_tree5_0_mult_out_rob_0_8;
    wire adder_tree5_0_mult_out_roa_0_8;
    wire adder_tree5_0_mult_out_rob_0_7;
    wire adder_tree5_0_mult_out_roa_0_7;
    wire adder_tree5_0_mult_out_rob_0_6;
    wire adder_tree5_0_mult_out_roa_0_6;
    wire adder_tree5_0_mult_out_rob_0_5;
    wire adder_tree5_0_mult_out_roa_0_5;
    wire adder_tree5_0_mult_out_rob_0_4;
    wire adder_tree5_0_mult_out_roa_0_4;
    wire adder_tree5_0_mult_out_rob_0_3;
    wire adder_tree5_0_mult_out_roa_0_3;
    wire adder_tree5_0_mult_out_rob_0_2;
    wire adder_tree5_0_mult_out_roa_0_2;
    wire adder_tree5_0_mult_out_rob_0_1;
    wire adder_tree5_0_mult_out_roa_0_1;
    wire adder_tree5_0_mult_out_rob_0_0;
    wire adder_tree5_0_mult_out_roa_0_0;
    wire adder_tree5_0_mult_out_p_0_35;
    wire adder_tree5_0_mult_out_p_0_34;
    wire adder_tree5_0_mult_out_p_0_33;
    wire adder_tree5_0_mult_out_p_0_32;
    wire adder_tree5_0_mult_out_p_0_31;
    wire adder_tree5_0_mult_out_p_0_30;
    wire adder_tree5_0_mult_out_p_0_29;
    wire adder_tree5_0_mult_out_p_0_28;
    wire adder_tree5_0_mult_out_p_0_27;
    wire adder_tree5_0_mult_out_p_0_26;
    wire adder_tree5_0_mult_out_p_0_25;
    wire adder_tree5_0_mult_out_p_0_24;
    wire adder_tree5_0_mult_out_p_0_23;
    wire adder_tree5_0_mult_out_p_0_22;
    wire adder_tree5_0_mult_out_p_0_21;
    wire adder_tree5_0_mult_out_p_0_20;
    wire adder_tree5_0_mult_out_p_0_19;
    wire adder_tree5_0_mult_out_p_0_18;
    wire adder_tree5_0_mult_out_p_0_17;
    wire adder_tree5_0_mult_out_p_0_16;
    wire adder_tree5_0_mult_out_p_0_15;
    wire adder_tree5_0_mult_out_p_0_14;
    wire adder_tree5_0_mult_out_p_0_13;
    wire adder_tree5_0_mult_out_p_0_12;
    wire adder_tree5_0_mult_out_p_0_11;
    wire adder_tree5_0_mult_out_p_0_10;
    wire adder_tree5_0_mult_out_p_0_9;
    wire adder_tree5_0_mult_out_p_0_8;
    wire adder_tree5_0_mult_out_p_0_7;
    wire adder_tree5_0_mult_out_p_0_6;
    wire adder_tree5_0_mult_out_p_0_5;
    wire adder_tree5_0_mult_out_p_0_4;
    wire adder_tree5_0_mult_out_p_0_3;
    wire adder_tree5_0_mult_out_p_0_2;
    wire adder_tree5_0_mult_out_p_0_1;
    wire adder_tree5_0_mult_out_p_0_0;
    wire adder_tree5_0_mult_out_signedp_0;
    wire adder_tree5_0_mult_out_rob_1_17;
    wire adder_tree5_0_mult_out_roa_1_17;
    wire adder_tree5_0_mult_out_rob_1_16;
    wire adder_tree5_0_mult_out_roa_1_16;
    wire adder_tree5_0_mult_out_rob_1_15;
    wire adder_tree5_0_mult_out_roa_1_15;
    wire adder_tree5_0_mult_out_rob_1_14;
    wire adder_tree5_0_mult_out_roa_1_14;
    wire adder_tree5_0_mult_out_rob_1_13;
    wire adder_tree5_0_mult_out_roa_1_13;
    wire adder_tree5_0_mult_out_rob_1_12;
    wire adder_tree5_0_mult_out_roa_1_12;
    wire adder_tree5_0_mult_out_rob_1_11;
    wire adder_tree5_0_mult_out_roa_1_11;
    wire adder_tree5_0_mult_out_rob_1_10;
    wire adder_tree5_0_mult_out_roa_1_10;
    wire adder_tree5_0_mult_out_rob_1_9;
    wire adder_tree5_0_mult_out_roa_1_9;
    wire adder_tree5_0_mult_out_rob_1_8;
    wire adder_tree5_0_mult_out_roa_1_8;
    wire adder_tree5_0_mult_out_rob_1_7;
    wire adder_tree5_0_mult_out_roa_1_7;
    wire adder_tree5_0_mult_out_rob_1_6;
    wire adder_tree5_0_mult_out_roa_1_6;
    wire adder_tree5_0_mult_out_rob_1_5;
    wire adder_tree5_0_mult_out_roa_1_5;
    wire adder_tree5_0_mult_out_rob_1_4;
    wire adder_tree5_0_mult_out_roa_1_4;
    wire adder_tree5_0_mult_out_rob_1_3;
    wire adder_tree5_0_mult_out_roa_1_3;
    wire adder_tree5_0_mult_out_rob_1_2;
    wire adder_tree5_0_mult_out_roa_1_2;
    wire adder_tree5_0_mult_out_rob_1_1;
    wire adder_tree5_0_mult_out_roa_1_1;
    wire adder_tree5_0_mult_out_rob_1_0;
    wire adder_tree5_0_mult_out_roa_1_0;
    wire adder_tree5_0_mult_out_p_1_35;
    wire adder_tree5_0_mult_out_p_1_34;
    wire adder_tree5_0_mult_out_p_1_33;
    wire adder_tree5_0_mult_out_p_1_32;
    wire adder_tree5_0_mult_out_p_1_31;
    wire adder_tree5_0_mult_out_p_1_30;
    wire adder_tree5_0_mult_out_p_1_29;
    wire adder_tree5_0_mult_out_p_1_28;
    wire adder_tree5_0_mult_out_p_1_27;
    wire adder_tree5_0_mult_out_p_1_26;
    wire adder_tree5_0_mult_out_p_1_25;
    wire adder_tree5_0_mult_out_p_1_24;
    wire adder_tree5_0_mult_out_p_1_23;
    wire adder_tree5_0_mult_out_p_1_22;
    wire adder_tree5_0_mult_out_p_1_21;
    wire adder_tree5_0_mult_out_p_1_20;
    wire adder_tree5_0_mult_out_p_1_19;
    wire adder_tree5_0_mult_out_p_1_18;
    wire adder_tree5_0_mult_out_p_1_17;
    wire adder_tree5_0_mult_out_p_1_16;
    wire adder_tree5_0_mult_out_p_1_15;
    wire adder_tree5_0_mult_out_p_1_14;
    wire adder_tree5_0_mult_out_p_1_13;
    wire adder_tree5_0_mult_out_p_1_12;
    wire adder_tree5_0_mult_out_p_1_11;
    wire adder_tree5_0_mult_out_p_1_10;
    wire adder_tree5_0_mult_out_p_1_9;
    wire adder_tree5_0_mult_out_p_1_8;
    wire adder_tree5_0_mult_out_p_1_7;
    wire adder_tree5_0_mult_out_p_1_6;
    wire adder_tree5_0_mult_out_p_1_5;
    wire adder_tree5_0_mult_out_p_1_4;
    wire adder_tree5_0_mult_out_p_1_3;
    wire adder_tree5_0_mult_out_p_1_2;
    wire adder_tree5_0_mult_out_p_1_1;
    wire adder_tree5_0_mult_out_p_1_0;
    wire adder_tree5_0_mult_out_signedp_1;
    wire adder_tree5_1_mult_out_rob_0_17;
    wire adder_tree5_1_mult_out_roa_0_17;
    wire adder_tree5_1_mult_out_rob_0_16;
    wire adder_tree5_1_mult_out_roa_0_16;
    wire adder_tree5_1_mult_out_rob_0_15;
    wire adder_tree5_1_mult_out_roa_0_15;
    wire adder_tree5_1_mult_out_rob_0_14;
    wire adder_tree5_1_mult_out_roa_0_14;
    wire adder_tree5_1_mult_out_rob_0_13;
    wire adder_tree5_1_mult_out_roa_0_13;
    wire adder_tree5_1_mult_out_rob_0_12;
    wire adder_tree5_1_mult_out_roa_0_12;
    wire adder_tree5_1_mult_out_rob_0_11;
    wire adder_tree5_1_mult_out_roa_0_11;
    wire adder_tree5_1_mult_out_rob_0_10;
    wire adder_tree5_1_mult_out_roa_0_10;
    wire adder_tree5_1_mult_out_rob_0_9;
    wire adder_tree5_1_mult_out_roa_0_9;
    wire adder_tree5_1_mult_out_rob_0_8;
    wire adder_tree5_1_mult_out_roa_0_8;
    wire adder_tree5_1_mult_out_rob_0_7;
    wire adder_tree5_1_mult_out_roa_0_7;
    wire adder_tree5_1_mult_out_rob_0_6;
    wire adder_tree5_1_mult_out_roa_0_6;
    wire adder_tree5_1_mult_out_rob_0_5;
    wire adder_tree5_1_mult_out_roa_0_5;
    wire adder_tree5_1_mult_out_rob_0_4;
    wire adder_tree5_1_mult_out_roa_0_4;
    wire adder_tree5_1_mult_out_rob_0_3;
    wire adder_tree5_1_mult_out_roa_0_3;
    wire adder_tree5_1_mult_out_rob_0_2;
    wire adder_tree5_1_mult_out_roa_0_2;
    wire adder_tree5_1_mult_out_rob_0_1;
    wire adder_tree5_1_mult_out_roa_0_1;
    wire adder_tree5_1_mult_out_rob_0_0;
    wire adder_tree5_1_mult_out_roa_0_0;
    wire adder_tree5_1_mult_out_p_0_35;
    wire adder_tree5_1_mult_out_p_0_34;
    wire adder_tree5_1_mult_out_p_0_33;
    wire adder_tree5_1_mult_out_p_0_32;
    wire adder_tree5_1_mult_out_p_0_31;
    wire adder_tree5_1_mult_out_p_0_30;
    wire adder_tree5_1_mult_out_p_0_29;
    wire adder_tree5_1_mult_out_p_0_28;
    wire adder_tree5_1_mult_out_p_0_27;
    wire adder_tree5_1_mult_out_p_0_26;
    wire adder_tree5_1_mult_out_p_0_25;
    wire adder_tree5_1_mult_out_p_0_24;
    wire adder_tree5_1_mult_out_p_0_23;
    wire adder_tree5_1_mult_out_p_0_22;
    wire adder_tree5_1_mult_out_p_0_21;
    wire adder_tree5_1_mult_out_p_0_20;
    wire adder_tree5_1_mult_out_p_0_19;
    wire adder_tree5_1_mult_out_p_0_18;
    wire adder_tree5_1_mult_out_p_0_17;
    wire adder_tree5_1_mult_out_p_0_16;
    wire adder_tree5_1_mult_out_p_0_15;
    wire adder_tree5_1_mult_out_p_0_14;
    wire adder_tree5_1_mult_out_p_0_13;
    wire adder_tree5_1_mult_out_p_0_12;
    wire adder_tree5_1_mult_out_p_0_11;
    wire adder_tree5_1_mult_out_p_0_10;
    wire adder_tree5_1_mult_out_p_0_9;
    wire adder_tree5_1_mult_out_p_0_8;
    wire adder_tree5_1_mult_out_p_0_7;
    wire adder_tree5_1_mult_out_p_0_6;
    wire adder_tree5_1_mult_out_p_0_5;
    wire adder_tree5_1_mult_out_p_0_4;
    wire adder_tree5_1_mult_out_p_0_3;
    wire adder_tree5_1_mult_out_p_0_2;
    wire adder_tree5_1_mult_out_p_0_1;
    wire adder_tree5_1_mult_out_p_0_0;
    wire adder_tree5_1_mult_out_signedp_0;
    wire adder_tree5ar1_3_i_d_15;
    wire adder_tree5ar1_3_i_d_14;
    wire adder_tree5ar1_3_i_d_13;
    wire adder_tree5ar1_3_i_d_12;
    wire adder_tree5ar1_3_i_d_11;
    wire adder_tree5ar1_3_i_d_10;
    wire adder_tree5ar1_3_i_d_9;
    wire adder_tree5ar1_3_i_d_8;
    wire adder_tree5ar1_3_i_d_7;
    wire adder_tree5ar1_3_i_d_6;
    wire adder_tree5ar1_3_i_d_5;
    wire adder_tree5ar1_3_i_d_4;
    wire adder_tree5ar1_3_i_d_3;
    wire adder_tree5ar1_3_i_d_2;
    wire adder_tree5ar1_3_i_d_1;
    wire adder_tree5ar1_3_i_d_0;
    wire adder_tree5_1_mult_out_rob_1_17;
    wire adder_tree5_1_mult_out_roa_1_17;
    wire adder_tree5_1_mult_out_rob_1_16;
    wire adder_tree5_1_mult_out_roa_1_16;
    wire adder_tree5_1_mult_out_rob_1_15;
    wire adder_tree5_1_mult_out_roa_1_15;
    wire adder_tree5_1_mult_out_rob_1_14;
    wire adder_tree5_1_mult_out_roa_1_14;
    wire adder_tree5_1_mult_out_rob_1_13;
    wire adder_tree5_1_mult_out_roa_1_13;
    wire adder_tree5_1_mult_out_rob_1_12;
    wire adder_tree5_1_mult_out_roa_1_12;
    wire adder_tree5_1_mult_out_rob_1_11;
    wire adder_tree5_1_mult_out_roa_1_11;
    wire adder_tree5_1_mult_out_rob_1_10;
    wire adder_tree5_1_mult_out_roa_1_10;
    wire adder_tree5_1_mult_out_rob_1_9;
    wire adder_tree5_1_mult_out_roa_1_9;
    wire adder_tree5_1_mult_out_rob_1_8;
    wire adder_tree5_1_mult_out_roa_1_8;
    wire adder_tree5_1_mult_out_rob_1_7;
    wire adder_tree5_1_mult_out_roa_1_7;
    wire adder_tree5_1_mult_out_rob_1_6;
    wire adder_tree5_1_mult_out_roa_1_6;
    wire adder_tree5_1_mult_out_rob_1_5;
    wire adder_tree5_1_mult_out_roa_1_5;
    wire adder_tree5_1_mult_out_rob_1_4;
    wire adder_tree5_1_mult_out_roa_1_4;
    wire adder_tree5_1_mult_out_rob_1_3;
    wire adder_tree5_1_mult_out_roa_1_3;
    wire adder_tree5_1_mult_out_rob_1_2;
    wire adder_tree5_1_mult_out_roa_1_2;
    wire adder_tree5_1_mult_out_rob_1_1;
    wire adder_tree5_1_mult_out_roa_1_1;
    wire adder_tree5_1_mult_out_rob_1_0;
    wire adder_tree5_1_mult_out_roa_1_0;
    wire adder_tree5_1_mult_out_p_1_35;
    wire adder_tree5_1_mult_out_p_1_34;
    wire adder_tree5_1_mult_out_p_1_33;
    wire adder_tree5_1_mult_out_p_1_32;
    wire adder_tree5_1_mult_out_p_1_31;
    wire adder_tree5_1_mult_out_p_1_30;
    wire adder_tree5_1_mult_out_p_1_29;
    wire adder_tree5_1_mult_out_p_1_28;
    wire adder_tree5_1_mult_out_p_1_27;
    wire adder_tree5_1_mult_out_p_1_26;
    wire adder_tree5_1_mult_out_p_1_25;
    wire adder_tree5_1_mult_out_p_1_24;
    wire adder_tree5_1_mult_out_p_1_23;
    wire adder_tree5_1_mult_out_p_1_22;
    wire adder_tree5_1_mult_out_p_1_21;
    wire adder_tree5_1_mult_out_p_1_20;
    wire adder_tree5_1_mult_out_p_1_19;
    wire adder_tree5_1_mult_out_p_1_18;
    wire adder_tree5_1_mult_out_p_1_17;
    wire adder_tree5_1_mult_out_p_1_16;
    wire adder_tree5_1_mult_out_p_1_15;
    wire adder_tree5_1_mult_out_p_1_14;
    wire adder_tree5_1_mult_out_p_1_13;
    wire adder_tree5_1_mult_out_p_1_12;
    wire adder_tree5_1_mult_out_p_1_11;
    wire adder_tree5_1_mult_out_p_1_10;
    wire adder_tree5_1_mult_out_p_1_9;
    wire adder_tree5_1_mult_out_p_1_8;
    wire adder_tree5_1_mult_out_p_1_7;
    wire adder_tree5_1_mult_out_p_1_6;
    wire adder_tree5_1_mult_out_p_1_5;
    wire adder_tree5_1_mult_out_p_1_4;
    wire adder_tree5_1_mult_out_p_1_3;
    wire adder_tree5_1_mult_out_p_1_2;
    wire adder_tree5_1_mult_out_p_1_1;
    wire adder_tree5_1_mult_out_p_1_0;
    wire adder_tree5_1_mult_out_signedp_1;
    wire scuba_vhi;
    wire scuba_vlo;
    wire adder_tree5ar1_4_i_d_15;
    wire adder_tree5ar1_4_i_d_14;
    wire adder_tree5ar1_4_i_d_13;
    wire adder_tree5ar1_4_i_d_12;
    wire adder_tree5ar1_4_i_d_11;
    wire adder_tree5ar1_4_i_d_10;
    wire adder_tree5ar1_4_i_d_9;
    wire adder_tree5ar1_4_i_d_8;
    wire adder_tree5ar1_4_i_d_7;
    wire adder_tree5ar1_4_i_d_6;
    wire adder_tree5ar1_4_i_d_5;
    wire adder_tree5ar1_4_i_d_4;
    wire adder_tree5ar1_4_i_d_3;
    wire adder_tree5ar1_4_i_d_2;
    wire adder_tree5ar1_4_i_d_1;
    wire adder_tree5ar1_4_i_d_0;

    FD1P3IX FF_31 (.D(i_data_a3[0]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_0))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_30 (.D(i_data_a3[1]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_1))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_29 (.D(i_data_a3[2]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_2))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_28 (.D(i_data_a3[3]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_3))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_27 (.D(i_data_a3[4]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_4))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_26 (.D(i_data_a3[5]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_5))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_25 (.D(i_data_a3[6]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_6))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_24 (.D(i_data_a3[7]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_7))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_23 (.D(i_data_a3[8]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_8))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_22 (.D(i_data_a3[9]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_9))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_21 (.D(i_data_a3[10]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_10))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_20 (.D(i_data_a3[11]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_11))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_19 (.D(i_data_a3[12]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_12))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_18 (.D(i_data_a3[13]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_13))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_17 (.D(i_data_a3[14]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_14))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_16 (.D(i_data_a3[15]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_3_i_d_15))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_15 (.D(i_data_a4[0]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_0))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_14 (.D(i_data_a4[1]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_1))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_13 (.D(i_data_a4[2]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_2))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_12 (.D(i_data_a4[3]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_3))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_11 (.D(i_data_a4[4]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_4))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_10 (.D(i_data_a4[5]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_5))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_9 (.D(i_data_a4[6]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_6))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_8 (.D(i_data_a4[7]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_7))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_7 (.D(i_data_a4[8]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_8))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_6 (.D(i_data_a4[9]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_9))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_5 (.D(i_data_a4[10]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_10))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_4 (.D(i_data_a4[11]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_11))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_3 (.D(i_data_a4[12]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_12))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_2 (.D(i_data_a4[13]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_13))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_1 (.D(i_data_a4[14]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_14))
             /* synthesis GSR="ENABLED" */;

    FD1P3IX FF_0 (.D(i_data_a4[15]), .SP(i_enable), .CK(i_clock), .CD(i_reset), .Q(adder_tree5ar1_4_i_d_15))
             /* synthesis GSR="ENABLED" */;

    defparam dsp_alu_1.CLK3_DIV = "ENABLED" ;
    defparam dsp_alu_1.CLK2_DIV = "ENABLED" ;
    defparam dsp_alu_1.CLK1_DIV = "DISABLED" ;
    defparam dsp_alu_1.CLK0_DIV = "ENABLED" ;
    defparam dsp_alu_1.REG_INPUTCFB_RST = "RST0" ;
    defparam dsp_alu_1.REG_INPUTCFB_CE = "CE0" ;
    defparam dsp_alu_1.REG_INPUTCFB_CLK = "NONE" ;
    defparam dsp_alu_1.REG_OPCODEIN_1_RST = "RST0" ;
    defparam dsp_alu_1.REG_OPCODEIN_1_CE = "CE0" ;
    defparam dsp_alu_1.REG_OPCODEIN_1_CLK = "NONE" ;
    defparam dsp_alu_1.REG_OPCODEIN_0_RST = "RST0" ;
    defparam dsp_alu_1.REG_OPCODEIN_0_CE = "CE0" ;
    defparam dsp_alu_1.REG_OPCODEIN_0_CLK = "NONE" ;
    defparam dsp_alu_1.REG_OPCODEOP1_1_CLK = "NONE" ;
    defparam dsp_alu_1.REG_OPCODEOP1_0_CLK = "NONE" ;
    defparam dsp_alu_1.REG_OPCODEOP0_1_RST = "RST0" ;
    defparam dsp_alu_1.REG_OPCODEOP0_1_CE = "CE0" ;
    defparam dsp_alu_1.REG_OPCODEOP0_1_CLK = "NONE" ;
    defparam dsp_alu_1.REG_OPCODEOP0_0_RST = "RST0" ;
    defparam dsp_alu_1.REG_OPCODEOP0_0_CE = "CE0" ;
    defparam dsp_alu_1.REG_OPCODEOP0_0_CLK = "NONE" ;
    defparam dsp_alu_1.REG_INPUTC1_RST = "RST0" ;
    defparam dsp_alu_1.REG_INPUTC1_CE = "CE0" ;
    defparam dsp_alu_1.REG_INPUTC1_CLK = "CLK1" ;
    defparam dsp_alu_1.REG_INPUTC0_RST = "RST0" ;
    defparam dsp_alu_1.REG_INPUTC0_CE = "CE0" ;
    defparam dsp_alu_1.REG_INPUTC0_CLK = "CLK1" ;
    defparam dsp_alu_1.LEGACY = "DISABLED" ;
    defparam dsp_alu_1.REG_FLAG_RST = "RST0" ;
    defparam dsp_alu_1.REG_FLAG_CE = "CE0" ;
    defparam dsp_alu_1.REG_FLAG_CLK = "NONE" ;
    defparam dsp_alu_1.REG_OUTPUT1_RST = "RST0" ;
    defparam dsp_alu_1.REG_OUTPUT1_CE = "CE0" ;
    defparam dsp_alu_1.REG_OUTPUT1_CLK = "CLK0" ;
    defparam dsp_alu_1.REG_OUTPUT0_RST = "RST0" ;
    defparam dsp_alu_1.REG_OUTPUT0_CE = "CE0" ;
    defparam dsp_alu_1.REG_OUTPUT0_CLK = "CLK0" ;
    defparam dsp_alu_1.MULT9_MODE = "DISABLED" ;
    defparam dsp_alu_1.RNDPAT = "0x00000000000000" ;
    defparam dsp_alu_1.MASKPAT = "0x00000000000000" ;
    defparam dsp_alu_1.MCPAT = "0x00000000000000" ;
    defparam dsp_alu_1.MASK01 = "0x00000000000000" ;
    defparam dsp_alu_1.MASKPAT_SOURCE = "STATIC" ;
    defparam dsp_alu_1.MCPAT_SOURCE = "STATIC" ;
    defparam dsp_alu_1.RESETMODE = "SYNC" ;
    defparam dsp_alu_1.GSR = "ENABLED" ;
    ALU54B dsp_alu_1 (.A35(adder_tree5_0_mult_out_rob_0_17), .A34(adder_tree5_0_mult_out_rob_0_16),
        .A33(adder_tree5_0_mult_out_rob_0_15), .A32(adder_tree5_0_mult_out_rob_0_14),
        .A31(adder_tree5_0_mult_out_rob_0_13), .A30(adder_tree5_0_mult_out_rob_0_12),
        .A29(adder_tree5_0_mult_out_rob_0_11), .A28(adder_tree5_0_mult_out_rob_0_10),
        .A27(adder_tree5_0_mult_out_rob_0_9), .A26(adder_tree5_0_mult_out_rob_0_8),
        .A25(adder_tree5_0_mult_out_rob_0_7), .A24(adder_tree5_0_mult_out_rob_0_6),
        .A23(adder_tree5_0_mult_out_rob_0_5), .A22(adder_tree5_0_mult_out_rob_0_4),
        .A21(adder_tree5_0_mult_out_rob_0_3), .A20(adder_tree5_0_mult_out_rob_0_2),
        .A19(adder_tree5_0_mult_out_rob_0_1), .A18(adder_tree5_0_mult_out_rob_0_0),
        .A17(adder_tree5_0_mult_out_roa_0_17), .A16(adder_tree5_0_mult_out_roa_0_16),
        .A15(adder_tree5_0_mult_out_roa_0_15), .A14(adder_tree5_0_mult_out_roa_0_14),
        .A13(adder_tree5_0_mult_out_roa_0_13), .A12(adder_tree5_0_mult_out_roa_0_12),
        .A11(adder_tree5_0_mult_out_roa_0_11), .A10(adder_tree5_0_mult_out_roa_0_10),
        .A9(adder_tree5_0_mult_out_roa_0_9), .A8(adder_tree5_0_mult_out_roa_0_8),
        .A7(adder_tree5_0_mult_out_roa_0_7), .A6(adder_tree5_0_mult_out_roa_0_6),
        .A5(adder_tree5_0_mult_out_roa_0_5), .A4(adder_tree5_0_mult_out_roa_0_4),
        .A3(adder_tree5_0_mult_out_roa_0_3), .A2(adder_tree5_0_mult_out_roa_0_2),
        .A1(adder_tree5_0_mult_out_roa_0_1), .A0(adder_tree5_0_mult_out_roa_0_0),
        .B35(adder_tree5_0_mult_out_rob_1_17), .B34(adder_tree5_0_mult_out_rob_1_16),
        .B33(adder_tree5_0_mult_out_rob_1_15), .B32(adder_tree5_0_mult_out_rob_1_14),
        .B31(adder_tree5_0_mult_out_rob_1_13), .B30(adder_tree5_0_mult_out_rob_1_12),
        .B29(adder_tree5_0_mult_out_rob_1_11), .B28(adder_tree5_0_mult_out_rob_1_10),
        .B27(adder_tree5_0_mult_out_rob_1_9), .B26(adder_tree5_0_mult_out_rob_1_8),
        .B25(adder_tree5_0_mult_out_rob_1_7), .B24(adder_tree5_0_mult_out_rob_1_6),
        .B23(adder_tree5_0_mult_out_rob_1_5), .B22(adder_tree5_0_mult_out_rob_1_4),
        .B21(adder_tree5_0_mult_out_rob_1_3), .B20(adder_tree5_0_mult_out_rob_1_2),
        .B19(adder_tree5_0_mult_out_rob_1_1), .B18(adder_tree5_0_mult_out_rob_1_0),
        .B17(adder_tree5_0_mult_out_roa_1_17), .B16(adder_tree5_0_mult_out_roa_1_16),
        .B15(adder_tree5_0_mult_out_roa_1_15), .B14(adder_tree5_0_mult_out_roa_1_14),
        .B13(adder_tree5_0_mult_out_roa_1_13), .B12(adder_tree5_0_mult_out_roa_1_12),
        .B11(adder_tree5_0_mult_out_roa_1_11), .B10(adder_tree5_0_mult_out_roa_1_10),
        .B9(adder_tree5_0_mult_out_roa_1_9), .B8(adder_tree5_0_mult_out_roa_1_8),
        .B7(adder_tree5_0_mult_out_roa_1_7), .B6(adder_tree5_0_mult_out_roa_1_6),
        .B5(adder_tree5_0_mult_out_roa_1_5), .B4(adder_tree5_0_mult_out_roa_1_4),
        .B3(adder_tree5_0_mult_out_roa_1_3), .B2(adder_tree5_0_mult_out_roa_1_2),
        .B1(adder_tree5_0_mult_out_roa_1_1), .B0(adder_tree5_0_mult_out_roa_1_0),
        .CFB53(scuba_vlo), .CFB52(scuba_vlo), .CFB51(scuba_vlo), .CFB50(scuba_vlo),
        .CFB49(scuba_vlo), .CFB48(scuba_vlo), .CFB47(scuba_vlo), .CFB46(scuba_vlo),
        .CFB45(scuba_vlo), .CFB44(scuba_vlo), .CFB43(scuba_vlo), .CFB42(scuba_vlo),
        .CFB41(scuba_vlo), .CFB40(scuba_vlo), .CFB39(scuba_vlo), .CFB38(scuba_vlo),
        .CFB37(scuba_vlo), .CFB36(scuba_vlo), .CFB35(scuba_vlo), .CFB34(scuba_vlo),
        .CFB33(scuba_vlo), .CFB32(scuba_vlo), .CFB31(scuba_vlo), .CFB30(scuba_vlo),
        .CFB29(scuba_vlo), .CFB28(scuba_vlo), .CFB27(scuba_vlo), .CFB26(scuba_vlo),
        .CFB25(scuba_vlo), .CFB24(scuba_vlo), .CFB23(scuba_vlo), .CFB22(scuba_vlo),
        .CFB21(scuba_vlo), .CFB20(scuba_vlo), .CFB19(scuba_vlo), .CFB18(scuba_vlo),
        .CFB17(scuba_vlo), .CFB16(scuba_vlo), .CFB15(scuba_vlo), .CFB14(scuba_vlo),
        .CFB13(scuba_vlo), .CFB12(scuba_vlo), .CFB11(scuba_vlo), .CFB10(scuba_vlo),
        .CFB9(scuba_vlo), .CFB8(scuba_vlo), .CFB7(scuba_vlo), .CFB6(scuba_vlo),
        .CFB5(scuba_vlo), .CFB4(scuba_vlo), .CFB3(scuba_vlo), .CFB2(scuba_vlo),
        .CFB1(scuba_vlo), .CFB0(scuba_vlo), .C53(i_data_a0[15]), .C52(i_data_a0[15]),
        .C51(i_data_a0[15]), .C50(i_data_a0[15]), .C49(i_data_a0[15]), .C48(i_data_a0[15]),
        .C47(i_data_a0[15]), .C46(i_data_a0[15]), .C45(i_data_a0[15]), .C44(i_data_a0[15]),
        .C43(i_data_a0[15]), .C42(i_data_a0[15]), .C41(i_data_a0[15]), .C40(i_data_a0[15]),
        .C39(i_data_a0[15]), .C38(i_data_a0[15]), .C37(i_data_a0[15]), .C36(i_data_a0[15]),
        .C35(i_data_a0[15]), .C34(i_data_a0[15]), .C33(i_data_a0[15]), .C32(i_data_a0[15]),
        .C31(i_data_a0[15]), .C30(i_data_a0[15]), .C29(i_data_a0[15]), .C28(i_data_a0[15]),
        .C27(i_data_a0[15]), .C26(i_data_a0[15]), .C25(i_data_a0[15]), .C24(i_data_a0[15]),
        .C23(i_data_a0[15]), .C22(i_data_a0[15]), .C21(i_data_a0[15]), .C20(i_data_a0[15]),
        .C19(i_data_a0[15]), .C18(i_data_a0[15]), .C17(i_data_a0[15]), .C16(i_data_a0[15]),
        .C15(i_data_a0[15]), .C14(i_data_a0[14]), .C13(i_data_a0[13]), .C12(i_data_a0[12]),
        .C11(i_data_a0[11]), .C10(i_data_a0[10]), .C9(i_data_a0[9]), .C8(i_data_a0[8]),
        .C7(i_data_a0[7]), .C6(i_data_a0[6]), .C5(i_data_a0[5]), .C4(i_data_a0[4]),
        .C3(i_data_a0[3]), .C2(i_data_a0[2]), .C1(i_data_a0[1]), .C0(i_data_a0[0]),
        .CE0(i_enable), .CE1(scuba_vhi), .CE2(scuba_vhi), .CE3(scuba_vhi),
        .CLK0(i_clock), .CLK1(i_clock), .CLK2(scuba_vhi), .CLK3(scuba_vhi),
        .RST0(i_reset), .RST1(scuba_vlo), .RST2(scuba_vlo), .RST3(scuba_vlo),
        .SIGNEDIA(adder_tree5_0_mult_out_signedp_0), .SIGNEDIB(adder_tree5_0_mult_out_signedp_1),
        .SIGNEDCIN(adder_tree5_alu_signedcin_1_0), .MA35(adder_tree5_0_mult_out_p_0_35),
        .MA34(adder_tree5_0_mult_out_p_0_34), .MA33(adder_tree5_0_mult_out_p_0_33),
        .MA32(adder_tree5_0_mult_out_p_0_32), .MA31(adder_tree5_0_mult_out_p_0_31),
        .MA30(adder_tree5_0_mult_out_p_0_30), .MA29(adder_tree5_0_mult_out_p_0_29),
        .MA28(adder_tree5_0_mult_out_p_0_28), .MA27(adder_tree5_0_mult_out_p_0_27),
        .MA26(adder_tree5_0_mult_out_p_0_26), .MA25(adder_tree5_0_mult_out_p_0_25),
        .MA24(adder_tree5_0_mult_out_p_0_24), .MA23(adder_tree5_0_mult_out_p_0_23),
        .MA22(adder_tree5_0_mult_out_p_0_22), .MA21(adder_tree5_0_mult_out_p_0_21),
        .MA20(adder_tree5_0_mult_out_p_0_20), .MA19(adder_tree5_0_mult_out_p_0_19),
        .MA18(adder_tree5_0_mult_out_p_0_18), .MA17(adder_tree5_0_mult_out_p_0_17),
        .MA16(adder_tree5_0_mult_out_p_0_16), .MA15(adder_tree5_0_mult_out_p_0_15),
        .MA14(adder_tree5_0_mult_out_p_0_14), .MA13(adder_tree5_0_mult_out_p_0_13),
        .MA12(adder_tree5_0_mult_out_p_0_12), .MA11(adder_tree5_0_mult_out_p_0_11),
        .MA10(adder_tree5_0_mult_out_p_0_10), .MA9(adder_tree5_0_mult_out_p_0_9),
        .MA8(adder_tree5_0_mult_out_p_0_8), .MA7(adder_tree5_0_mult_out_p_0_7),
        .MA6(adder_tree5_0_mult_out_p_0_6), .MA5(adder_tree5_0_mult_out_p_0_5),
        .MA4(adder_tree5_0_mult_out_p_0_4), .MA3(adder_tree5_0_mult_out_p_0_3),
        .MA2(adder_tree5_0_mult_out_p_0_2), .MA1(adder_tree5_0_mult_out_p_0_1),
        .MA0(adder_tree5_0_mult_out_p_0_0), .MB35(adder_tree5_0_mult_out_p_1_35),
        .MB34(adder_tree5_0_mult_out_p_1_34), .MB33(adder_tree5_0_mult_out_p_1_33),
        .MB32(adder_tree5_0_mult_out_p_1_32), .MB31(adder_tree5_0_mult_out_p_1_31),
        .MB30(adder_tree5_0_mult_out_p_1_30), .MB29(adder_tree5_0_mult_out_p_1_29),
        .MB28(adder_tree5_0_mult_out_p_1_28), .MB27(adder_tree5_0_mult_out_p_1_27),
        .MB26(adder_tree5_0_mult_out_p_1_26), .MB25(adder_tree5_0_mult_out_p_1_25),
        .MB24(adder_tree5_0_mult_out_p_1_24), .MB23(adder_tree5_0_mult_out_p_1_23),
        .MB22(adder_tree5_0_mult_out_p_1_22), .MB21(adder_tree5_0_mult_out_p_1_21),
        .MB20(adder_tree5_0_mult_out_p_1_20), .MB19(adder_tree5_0_mult_out_p_1_19),
        .MB18(adder_tree5_0_mult_out_p_1_18), .MB17(adder_tree5_0_mult_out_p_1_17),
        .MB16(adder_tree5_0_mult_out_p_1_16), .MB15(adder_tree5_0_mult_out_p_1_15),
        .MB14(adder_tree5_0_mult_out_p_1_14), .MB13(adder_tree5_0_mult_out_p_1_13),
        .MB12(adder_tree5_0_mult_out_p_1_12), .MB11(adder_tree5_0_mult_out_p_1_11),
        .MB10(adder_tree5_0_mult_out_p_1_10), .MB9(adder_tree5_0_mult_out_p_1_9),
        .MB8(adder_tree5_0_mult_out_p_1_8), .MB7(adder_tree5_0_mult_out_p_1_7),
        .MB6(adder_tree5_0_mult_out_p_1_6), .MB5(adder_tree5_0_mult_out_p_1_5),
        .MB4(adder_tree5_0_mult_out_p_1_4), .MB3(adder_tree5_0_mult_out_p_1_3),
        .MB2(adder_tree5_0_mult_out_p_1_2), .MB1(adder_tree5_0_mult_out_p_1_1),
        .MB0(adder_tree5_0_mult_out_p_1_0), .CIN53(adder_tree5_alu_in_cin_1_0_53),
        .CIN52(adder_tree5_alu_in_cin_1_0_52), .CIN51(adder_tree5_alu_in_cin_1_0_51),
        .CIN50(adder_tree5_alu_in_cin_1_0_50), .CIN49(adder_tree5_alu_in_cin_1_0_49),
        .CIN48(adder_tree5_alu_in_cin_1_0_48), .CIN47(adder_tree5_alu_in_cin_1_0_47),
        .CIN46(adder_tree5_alu_in_cin_1_0_46), .CIN45(adder_tree5_alu_in_cin_1_0_45),
        .CIN44(adder_tree5_alu_in_cin_1_0_44), .CIN43(adder_tree5_alu_in_cin_1_0_43),
        .CIN42(adder_tree5_alu_in_cin_1_0_42), .CIN41(adder_tree5_alu_in_cin_1_0_41),
        .CIN40(adder_tree5_alu_in_cin_1_0_40), .CIN39(adder_tree5_alu_in_cin_1_0_39),
        .CIN38(adder_tree5_alu_in_cin_1_0_38), .CIN37(adder_tree5_alu_in_cin_1_0_37),
        .CIN36(adder_tree5_alu_in_cin_1_0_36), .CIN35(adder_tree5_alu_in_cin_1_0_35),
        .CIN34(adder_tree5_alu_in_cin_1_0_34), .CIN33(adder_tree5_alu_in_cin_1_0_33),
        .CIN32(adder_tree5_alu_in_cin_1_0_32), .CIN31(adder_tree5_alu_in_cin_1_0_31),
        .CIN30(adder_tree5_alu_in_cin_1_0_30), .CIN29(adder_tree5_alu_in_cin_1_0_29),
        .CIN28(adder_tree5_alu_in_cin_1_0_28), .CIN27(adder_tree5_alu_in_cin_1_0_27),
        .CIN26(adder_tree5_alu_in_cin_1_0_26), .CIN25(adder_tree5_alu_in_cin_1_0_25),
        .CIN24(adder_tree5_alu_in_cin_1_0_24), .CIN23(adder_tree5_alu_in_cin_1_0_23),
        .CIN22(adder_tree5_alu_in_cin_1_0_22), .CIN21(adder_tree5_alu_in_cin_1_0_21),
        .CIN20(adder_tree5_alu_in_cin_1_0_20), .CIN19(adder_tree5_alu_in_cin_1_0_19),
        .CIN18(adder_tree5_alu_in_cin_1_0_18), .CIN17(adder_tree5_alu_in_cin_1_0_17),
        .CIN16(adder_tree5_alu_in_cin_1_0_16), .CIN15(adder_tree5_alu_in_cin_1_0_15),
        .CIN14(adder_tree5_alu_in_cin_1_0_14), .CIN13(adder_tree5_alu_in_cin_1_0_13),
        .CIN12(adder_tree5_alu_in_cin_1_0_12), .CIN11(adder_tree5_alu_in_cin_1_0_11),
        .CIN10(adder_tree5_alu_in_cin_1_0_10), .CIN9(adder_tree5_alu_in_cin_1_0_9),
        .CIN8(adder_tree5_alu_in_cin_1_0_8), .CIN7(adder_tree5_alu_in_cin_1_0_7),
        .CIN6(adder_tree5_alu_in_cin_1_0_6), .CIN5(adder_tree5_alu_in_cin_1_0_5),
        .CIN4(adder_tree5_alu_in_cin_1_0_4), .CIN3(adder_tree5_alu_in_cin_1_0_3),
        .CIN2(adder_tree5_alu_in_cin_1_0_2), .CIN1(adder_tree5_alu_in_cin_1_0_1),
        .CIN0(adder_tree5_alu_in_cin_1_0_0), .OP10(scuba_vlo), .OP9(scuba_vhi),
        .OP8(scuba_vlo), .OP7(scuba_vlo), .OP6(scuba_vlo), .OP5(scuba_vhi),
        .OP4(scuba_vhi), .OP3(scuba_vhi), .OP2(scuba_vlo), .OP1(scuba_vhi),
        .OP0(scuba_vlo), .R53(adder_tree5_alu_output_r_1_0_53), .R52(adder_tree5_alu_output_r_1_0_52),
        .R51(adder_tree5_alu_output_r_1_0_51), .R50(adder_tree5_alu_output_r_1_0_50),
        .R49(adder_tree5_alu_output_r_1_0_49), .R48(adder_tree5_alu_output_r_1_0_48),
        .R47(adder_tree5_alu_output_r_1_0_47), .R46(adder_tree5_alu_output_r_1_0_46),
        .R45(adder_tree5_alu_output_r_1_0_45), .R44(adder_tree5_alu_output_r_1_0_44),
        .R43(adder_tree5_alu_output_r_1_0_43), .R42(adder_tree5_alu_output_r_1_0_42),
        .R41(adder_tree5_alu_output_r_1_0_41), .R40(adder_tree5_alu_output_r_1_0_40),
        .R39(adder_tree5_alu_output_r_1_0_39), .R38(adder_tree5_alu_output_r_1_0_38),
        .R37(adder_tree5_alu_output_r_1_0_37), .R36(adder_tree5_alu_output_r_1_0_36),
        .R35(adder_tree5_alu_output_r_1_0_35), .R34(adder_tree5_alu_output_r_1_0_34),
        .R33(adder_tree5_alu_output_r_1_0_33), .R32(adder_tree5_alu_output_r_1_0_32),
        .R31(adder_tree5_alu_output_r_1_0_31), .R30(adder_tree5_alu_output_r_1_0_30),
        .R29(adder_tree5_alu_output_r_1_0_29), .R28(adder_tree5_alu_output_r_1_0_28),
        .R27(adder_tree5_alu_output_r_1_0_27), .R26(adder_tree5_alu_output_r_1_0_26),
        .R25(adder_tree5_alu_output_r_1_0_25), .R24(adder_tree5_alu_output_r_1_0_24),
        .R23(adder_tree5_alu_output_r_1_0_23), .R22(adder_tree5_alu_output_r_1_0_22),
        .R21(adder_tree5_alu_output_r_1_0_21), .R20(adder_tree5_alu_output_r_1_0_20),
        .R19(adder_tree5_alu_output_r_1_0_19), .R18(adder_tree5_alu_output_r_1_0_18),
        .R17(adder_tree5_alu_output_r_1_0_17), .R16(adder_tree5_alu_output_r_1_0_16),
        .R15(adder_tree5_alu_output_r_1_0_15), .R14(adder_tree5_alu_output_r_1_0_14),
        .R13(adder_tree5_alu_output_r_1_0_13), .R12(adder_tree5_alu_output_r_1_0_12),
        .R11(adder_tree5_alu_output_r_1_0_11), .R10(adder_tree5_alu_output_r_1_0_10),
        .R9(adder_tree5_alu_output_r_1_0_9), .R8(adder_tree5_alu_output_r_1_0_8),
        .R7(adder_tree5_alu_output_r_1_0_7), .R6(adder_tree5_alu_output_r_1_0_6),
        .R5(adder_tree5_alu_output_r_1_0_5), .R4(adder_tree5_alu_output_r_1_0_4),
        .R3(adder_tree5_alu_output_r_1_0_3), .R2(adder_tree5_alu_output_r_1_0_2),
        .R1(adder_tree5_alu_output_r_1_0_1), .R0(adder_tree5_alu_output_r_1_0_0),
        .CO53(), .CO52(), .CO51(), .CO50(), .CO49(), .CO48(), .CO47(), .CO46(),
        .CO45(), .CO44(), .CO43(), .CO42(), .CO41(), .CO40(), .CO39(), .CO38(),
        .CO37(), .CO36(), .CO35(), .CO34(), .CO33(), .CO32(), .CO31(), .CO30(),
        .CO29(), .CO28(), .CO27(), .CO26(), .CO25(), .CO24(), .CO23(), .CO22(),
        .CO21(), .CO20(), .CO19(), .CO18(), .CO17(), .CO16(), .CO15(), .CO14(),
        .CO13(), .CO12(), .CO11(), .CO10(), .CO9(), .CO8(), .CO7(), .CO6(),
        .CO5(), .CO4(), .CO3(), .CO2(), .CO1(), .CO0(), .EQZ(), .EQZM(),
        .EQOM(), .EQPAT(), .EQPATB(), .OVER(), .UNDER(), .OVERUNDER(), .SIGNEDR(adder_tree5_alu_signedr_1_0));

    defparam dsp_alu_0.CLK3_DIV = "ENABLED" ;
    defparam dsp_alu_0.CLK2_DIV = "ENABLED" ;
    defparam dsp_alu_0.CLK1_DIV = "DISABLED" ;
    defparam dsp_alu_0.CLK0_DIV = "ENABLED" ;
    defparam dsp_alu_0.REG_INPUTCFB_RST = "RST0" ;
    defparam dsp_alu_0.REG_INPUTCFB_CE = "CE0" ;
    defparam dsp_alu_0.REG_INPUTCFB_CLK = "NONE" ;
    defparam dsp_alu_0.REG_OPCODEIN_1_RST = "RST0" ;
    defparam dsp_alu_0.REG_OPCODEIN_1_CE = "CE0" ;
    defparam dsp_alu_0.REG_OPCODEIN_1_CLK = "NONE" ;
    defparam dsp_alu_0.REG_OPCODEIN_0_RST = "RST0" ;
    defparam dsp_alu_0.REG_OPCODEIN_0_CE = "CE0" ;
    defparam dsp_alu_0.REG_OPCODEIN_0_CLK = "NONE" ;
    defparam dsp_alu_0.REG_OPCODEOP1_1_CLK = "NONE" ;
    defparam dsp_alu_0.REG_OPCODEOP1_0_CLK = "NONE" ;
    defparam dsp_alu_0.REG_OPCODEOP0_1_RST = "RST0" ;
    defparam dsp_alu_0.REG_OPCODEOP0_1_CE = "CE0" ;
    defparam dsp_alu_0.REG_OPCODEOP0_1_CLK = "NONE" ;
    defparam dsp_alu_0.REG_OPCODEOP0_0_RST = "RST0" ;
    defparam dsp_alu_0.REG_OPCODEOP0_0_CE = "CE0" ;
    defparam dsp_alu_0.REG_OPCODEOP0_0_CLK = "NONE" ;
    defparam dsp_alu_0.REG_INPUTC1_RST = "RST0" ;
    defparam dsp_alu_0.REG_INPUTC1_CE = "CE0" ;
    defparam dsp_alu_0.REG_INPUTC1_CLK = "CLK1" ;
    defparam dsp_alu_0.REG_INPUTC0_RST = "RST0" ;
    defparam dsp_alu_0.REG_INPUTC0_CE = "CE0" ;
    defparam dsp_alu_0.REG_INPUTC0_CLK = "CLK1" ;
    defparam dsp_alu_0.LEGACY = "DISABLED" ;
    defparam dsp_alu_0.REG_FLAG_RST = "RST0" ;
    defparam dsp_alu_0.REG_FLAG_CE = "CE0" ;
    defparam dsp_alu_0.REG_FLAG_CLK = "NONE" ;
    defparam dsp_alu_0.REG_OUTPUT1_RST = "RST0" ;
    defparam dsp_alu_0.REG_OUTPUT1_CE = "CE0" ;
    defparam dsp_alu_0.REG_OUTPUT1_CLK = "CLK0" ;
    defparam dsp_alu_0.REG_OUTPUT0_RST = "RST0" ;
    defparam dsp_alu_0.REG_OUTPUT0_CE = "CE0" ;
    defparam dsp_alu_0.REG_OUTPUT0_CLK = "CLK0" ;
    defparam dsp_alu_0.MULT9_MODE = "DISABLED" ;
    defparam dsp_alu_0.RNDPAT = "0x00000000000000" ;
    defparam dsp_alu_0.MASKPAT = "0x00000000000000" ;
    defparam dsp_alu_0.MCPAT = "0x00000000000000" ;
    defparam dsp_alu_0.MASK01 = "0x00000000000000" ;
    defparam dsp_alu_0.MASKPAT_SOURCE = "STATIC" ;
    defparam dsp_alu_0.MCPAT_SOURCE = "STATIC" ;
    defparam dsp_alu_0.RESETMODE = "SYNC" ;
    defparam dsp_alu_0.GSR = "ENABLED" ;
    ALU54B dsp_alu_0 (.A35(adder_tree5_1_mult_out_rob_0_17), .A34(adder_tree5_1_mult_out_rob_0_16),
        .A33(adder_tree5_1_mult_out_rob_0_15), .A32(adder_tree5_1_mult_out_rob_0_14),
        .A31(adder_tree5_1_mult_out_rob_0_13), .A30(adder_tree5_1_mult_out_rob_0_12),
        .A29(adder_tree5_1_mult_out_rob_0_11), .A28(adder_tree5_1_mult_out_rob_0_10),
        .A27(adder_tree5_1_mult_out_rob_0_9), .A26(adder_tree5_1_mult_out_rob_0_8),
        .A25(adder_tree5_1_mult_out_rob_0_7), .A24(adder_tree5_1_mult_out_rob_0_6),
        .A23(adder_tree5_1_mult_out_rob_0_5), .A22(adder_tree5_1_mult_out_rob_0_4),
        .A21(adder_tree5_1_mult_out_rob_0_3), .A20(adder_tree5_1_mult_out_rob_0_2),
        .A19(adder_tree5_1_mult_out_rob_0_1), .A18(adder_tree5_1_mult_out_rob_0_0),
        .A17(adder_tree5_1_mult_out_roa_0_17), .A16(adder_tree5_1_mult_out_roa_0_16),
        .A15(adder_tree5_1_mult_out_roa_0_15), .A14(adder_tree5_1_mult_out_roa_0_14),
        .A13(adder_tree5_1_mult_out_roa_0_13), .A12(adder_tree5_1_mult_out_roa_0_12),
        .A11(adder_tree5_1_mult_out_roa_0_11), .A10(adder_tree5_1_mult_out_roa_0_10),
        .A9(adder_tree5_1_mult_out_roa_0_9), .A8(adder_tree5_1_mult_out_roa_0_8),
        .A7(adder_tree5_1_mult_out_roa_0_7), .A6(adder_tree5_1_mult_out_roa_0_6),
        .A5(adder_tree5_1_mult_out_roa_0_5), .A4(adder_tree5_1_mult_out_roa_0_4),
        .A3(adder_tree5_1_mult_out_roa_0_3), .A2(adder_tree5_1_mult_out_roa_0_2),
        .A1(adder_tree5_1_mult_out_roa_0_1), .A0(adder_tree5_1_mult_out_roa_0_0),
        .B35(adder_tree5_1_mult_out_rob_1_17), .B34(adder_tree5_1_mult_out_rob_1_16),
        .B33(adder_tree5_1_mult_out_rob_1_15), .B32(adder_tree5_1_mult_out_rob_1_14),
        .B31(adder_tree5_1_mult_out_rob_1_13), .B30(adder_tree5_1_mult_out_rob_1_12),
        .B29(adder_tree5_1_mult_out_rob_1_11), .B28(adder_tree5_1_mult_out_rob_1_10),
        .B27(adder_tree5_1_mult_out_rob_1_9), .B26(adder_tree5_1_mult_out_rob_1_8),
        .B25(adder_tree5_1_mult_out_rob_1_7), .B24(adder_tree5_1_mult_out_rob_1_6),
        .B23(adder_tree5_1_mult_out_rob_1_5), .B22(adder_tree5_1_mult_out_rob_1_4),
        .B21(adder_tree5_1_mult_out_rob_1_3), .B20(adder_tree5_1_mult_out_rob_1_2),
        .B19(adder_tree5_1_mult_out_rob_1_1), .B18(adder_tree5_1_mult_out_rob_1_0),
        .B17(adder_tree5_1_mult_out_roa_1_17), .B16(adder_tree5_1_mult_out_roa_1_16),
        .B15(adder_tree5_1_mult_out_roa_1_15), .B14(adder_tree5_1_mult_out_roa_1_14),
        .B13(adder_tree5_1_mult_out_roa_1_13), .B12(adder_tree5_1_mult_out_roa_1_12),
        .B11(adder_tree5_1_mult_out_roa_1_11), .B10(adder_tree5_1_mult_out_roa_1_10),
        .B9(adder_tree5_1_mult_out_roa_1_9), .B8(adder_tree5_1_mult_out_roa_1_8),
        .B7(adder_tree5_1_mult_out_roa_1_7), .B6(adder_tree5_1_mult_out_roa_1_6),
        .B5(adder_tree5_1_mult_out_roa_1_5), .B4(adder_tree5_1_mult_out_roa_1_4),
        .B3(adder_tree5_1_mult_out_roa_1_3), .B2(adder_tree5_1_mult_out_roa_1_2),
        .B1(adder_tree5_1_mult_out_roa_1_1), .B0(adder_tree5_1_mult_out_roa_1_0),
        .CFB53(scuba_vlo), .CFB52(scuba_vlo), .CFB51(scuba_vlo), .CFB50(scuba_vlo),
        .CFB49(scuba_vlo), .CFB48(scuba_vlo), .CFB47(scuba_vlo), .CFB46(scuba_vlo),
        .CFB45(scuba_vlo), .CFB44(scuba_vlo), .CFB43(scuba_vlo), .CFB42(scuba_vlo),
        .CFB41(scuba_vlo), .CFB40(scuba_vlo), .CFB39(scuba_vlo), .CFB38(scuba_vlo),
        .CFB37(scuba_vlo), .CFB36(scuba_vlo), .CFB35(scuba_vlo), .CFB34(scuba_vlo),
        .CFB33(scuba_vlo), .CFB32(scuba_vlo), .CFB31(scuba_vlo), .CFB30(scuba_vlo),
        .CFB29(scuba_vlo), .CFB28(scuba_vlo), .CFB27(scuba_vlo), .CFB26(scuba_vlo),
        .CFB25(scuba_vlo), .CFB24(scuba_vlo), .CFB23(scuba_vlo), .CFB22(scuba_vlo),
        .CFB21(scuba_vlo), .CFB20(scuba_vlo), .CFB19(scuba_vlo), .CFB18(scuba_vlo),
        .CFB17(scuba_vlo), .CFB16(scuba_vlo), .CFB15(scuba_vlo), .CFB14(scuba_vlo),
        .CFB13(scuba_vlo), .CFB12(scuba_vlo), .CFB11(scuba_vlo), .CFB10(scuba_vlo),
        .CFB9(scuba_vlo), .CFB8(scuba_vlo), .CFB7(scuba_vlo), .CFB6(scuba_vlo),
        .CFB5(scuba_vlo), .CFB4(scuba_vlo), .CFB3(scuba_vlo), .CFB2(scuba_vlo),
        .CFB1(scuba_vlo), .CFB0(scuba_vlo), .C53(scuba_vlo), .C52(scuba_vlo),
        .C51(scuba_vlo), .C50(scuba_vlo), .C49(scuba_vlo), .C48(scuba_vlo),
        .C47(scuba_vlo), .C46(scuba_vlo), .C45(scuba_vlo), .C44(scuba_vlo),
        .C43(scuba_vlo), .C42(scuba_vlo), .C41(scuba_vlo), .C40(scuba_vlo),
        .C39(scuba_vlo), .C38(scuba_vlo), .C37(scuba_vlo), .C36(scuba_vlo),
        .C35(scuba_vlo), .C34(scuba_vlo), .C33(scuba_vlo), .C32(scuba_vlo),
        .C31(scuba_vlo), .C30(scuba_vlo), .C29(scuba_vlo), .C28(scuba_vlo),
        .C27(scuba_vlo), .C26(scuba_vlo), .C25(scuba_vlo), .C24(scuba_vlo),
        .C23(scuba_vlo), .C22(scuba_vlo), .C21(scuba_vlo), .C20(scuba_vlo),
        .C19(scuba_vlo), .C18(scuba_vlo), .C17(scuba_vlo), .C16(scuba_vlo),
        .C15(scuba_vlo), .C14(scuba_vlo), .C13(scuba_vlo), .C12(scuba_vlo),
        .C11(scuba_vlo), .C10(scuba_vlo), .C9(scuba_vlo), .C8(scuba_vlo),
        .C7(scuba_vlo), .C6(scuba_vlo), .C5(scuba_vlo), .C4(scuba_vlo),
        .C3(scuba_vlo), .C2(scuba_vlo), .C1(scuba_vlo), .C0(scuba_vlo),
        .CE0(i_enable), .CE1(scuba_vhi), .CE2(scuba_vhi), .CE3(scuba_vhi),
        .CLK0(i_clock), .CLK1(i_clock), .CLK2(scuba_vhi), .CLK3(scuba_vhi),
        .RST0(i_reset), .RST1(scuba_vlo), .RST2(scuba_vlo), .RST3(scuba_vlo),
        .SIGNEDIA(adder_tree5_1_mult_out_signedp_0), .SIGNEDIB(adder_tree5_1_mult_out_signedp_1),
        .SIGNEDCIN(adder_tree5_0zs), .MA35(adder_tree5_1_mult_out_p_0_35),
        .MA34(adder_tree5_1_mult_out_p_0_34), .MA33(adder_tree5_1_mult_out_p_0_33),
        .MA32(adder_tree5_1_mult_out_p_0_32), .MA31(adder_tree5_1_mult_out_p_0_31),
        .MA30(adder_tree5_1_mult_out_p_0_30), .MA29(adder_tree5_1_mult_out_p_0_29),
        .MA28(adder_tree5_1_mult_out_p_0_28), .MA27(adder_tree5_1_mult_out_p_0_27),
        .MA26(adder_tree5_1_mult_out_p_0_26), .MA25(adder_tree5_1_mult_out_p_0_25),
        .MA24(adder_tree5_1_mult_out_p_0_24), .MA23(adder_tree5_1_mult_out_p_0_23),
        .MA22(adder_tree5_1_mult_out_p_0_22), .MA21(adder_tree5_1_mult_out_p_0_21),
        .MA20(adder_tree5_1_mult_out_p_0_20), .MA19(adder_tree5_1_mult_out_p_0_19),
        .MA18(adder_tree5_1_mult_out_p_0_18), .MA17(adder_tree5_1_mult_out_p_0_17),
        .MA16(adder_tree5_1_mult_out_p_0_16), .MA15(adder_tree5_1_mult_out_p_0_15),
        .MA14(adder_tree5_1_mult_out_p_0_14), .MA13(adder_tree5_1_mult_out_p_0_13),
        .MA12(adder_tree5_1_mult_out_p_0_12), .MA11(adder_tree5_1_mult_out_p_0_11),
        .MA10(adder_tree5_1_mult_out_p_0_10), .MA9(adder_tree5_1_mult_out_p_0_9),
        .MA8(adder_tree5_1_mult_out_p_0_8), .MA7(adder_tree5_1_mult_out_p_0_7),
        .MA6(adder_tree5_1_mult_out_p_0_6), .MA5(adder_tree5_1_mult_out_p_0_5),
        .MA4(adder_tree5_1_mult_out_p_0_4), .MA3(adder_tree5_1_mult_out_p_0_3),
        .MA2(adder_tree5_1_mult_out_p_0_2), .MA1(adder_tree5_1_mult_out_p_0_1),
        .MA0(adder_tree5_1_mult_out_p_0_0), .MB35(adder_tree5_1_mult_out_p_1_35),
        .MB34(adder_tree5_1_mult_out_p_1_34), .MB33(adder_tree5_1_mult_out_p_1_33),
        .MB32(adder_tree5_1_mult_out_p_1_32), .MB31(adder_tree5_1_mult_out_p_1_31),
        .MB30(adder_tree5_1_mult_out_p_1_30), .MB29(adder_tree5_1_mult_out_p_1_29),
        .MB28(adder_tree5_1_mult_out_p_1_28), .MB27(adder_tree5_1_mult_out_p_1_27),
        .MB26(adder_tree5_1_mult_out_p_1_26), .MB25(adder_tree5_1_mult_out_p_1_25),
        .MB24(adder_tree5_1_mult_out_p_1_24), .MB23(adder_tree5_1_mult_out_p_1_23),
        .MB22(adder_tree5_1_mult_out_p_1_22), .MB21(adder_tree5_1_mult_out_p_1_21),
        .MB20(adder_tree5_1_mult_out_p_1_20), .MB19(adder_tree5_1_mult_out_p_1_19),
        .MB18(adder_tree5_1_mult_out_p_1_18), .MB17(adder_tree5_1_mult_out_p_1_17),
        .MB16(adder_tree5_1_mult_out_p_1_16), .MB15(adder_tree5_1_mult_out_p_1_15),
        .MB14(adder_tree5_1_mult_out_p_1_14), .MB13(adder_tree5_1_mult_out_p_1_13),
        .MB12(adder_tree5_1_mult_out_p_1_12), .MB11(adder_tree5_1_mult_out_p_1_11),
        .MB10(adder_tree5_1_mult_out_p_1_10), .MB9(adder_tree5_1_mult_out_p_1_9),
        .MB8(adder_tree5_1_mult_out_p_1_8), .MB7(adder_tree5_1_mult_out_p_1_7),
        .MB6(adder_tree5_1_mult_out_p_1_6), .MB5(adder_tree5_1_mult_out_p_1_5),
        .MB4(adder_tree5_1_mult_out_p_1_4), .MB3(adder_tree5_1_mult_out_p_1_3),
        .MB2(adder_tree5_1_mult_out_p_1_2), .MB1(adder_tree5_1_mult_out_p_1_1),
        .MB0(adder_tree5_1_mult_out_p_1_0), .CIN53(adder_tree5_0z_53), .CIN52(adder_tree5_0z_52),
        .CIN51(adder_tree5_0z_51), .CIN50(adder_tree5_0z_50), .CIN49(adder_tree5_0z_49),
        .CIN48(adder_tree5_0z_48), .CIN47(adder_tree5_0z_47), .CIN46(adder_tree5_0z_46),
        .CIN45(adder_tree5_0z_45), .CIN44(adder_tree5_0z_44), .CIN43(adder_tree5_0z_43),
        .CIN42(adder_tree5_0z_42), .CIN41(adder_tree5_0z_41), .CIN40(adder_tree5_0z_40),
        .CIN39(adder_tree5_0z_39), .CIN38(adder_tree5_0z_38), .CIN37(adder_tree5_0z_37),
        .CIN36(adder_tree5_0z_36), .CIN35(adder_tree5_0z_35), .CIN34(adder_tree5_0z_34),
        .CIN33(adder_tree5_0z_33), .CIN32(adder_tree5_0z_32), .CIN31(adder_tree5_0z_31),
        .CIN30(adder_tree5_0z_30), .CIN29(adder_tree5_0z_29), .CIN28(adder_tree5_0z_28),
        .CIN27(adder_tree5_0z_27), .CIN26(adder_tree5_0z_26), .CIN25(adder_tree5_0z_25),
        .CIN24(adder_tree5_0z_24), .CIN23(adder_tree5_0z_23), .CIN22(adder_tree5_0z_22),
        .CIN21(adder_tree5_0z_21), .CIN20(adder_tree5_0z_20), .CIN19(adder_tree5_0z_19),
        .CIN18(adder_tree5_0z_18), .CIN17(adder_tree5_0z_17), .CIN16(adder_tree5_0z_16),
        .CIN15(adder_tree5_0z_15), .CIN14(adder_tree5_0z_14), .CIN13(adder_tree5_0z_13),
        .CIN12(adder_tree5_0z_12), .CIN11(adder_tree5_0z_11), .CIN10(adder_tree5_0z_10),
        .CIN9(adder_tree5_0z_9), .CIN8(adder_tree5_0z_8), .CIN7(adder_tree5_0z_7),
        .CIN6(adder_tree5_0z_6), .CIN5(adder_tree5_0z_5), .CIN4(adder_tree5_0z_4),
        .CIN3(adder_tree5_0z_3), .CIN2(adder_tree5_0z_2), .CIN1(adder_tree5_0z_1),
        .CIN0(adder_tree5_0z_0), .OP10(scuba_vlo), .OP9(scuba_vhi), .OP8(scuba_vlo),
        .OP7(scuba_vlo), .OP6(scuba_vlo), .OP5(scuba_vhi), .OP4(scuba_vlo),
        .OP3(scuba_vhi), .OP2(scuba_vlo), .OP1(scuba_vhi), .OP0(scuba_vlo),
        .R53(adder_tree5_alu_output_r_2_0_53), .R52(adder_tree5_alu_output_r_2_0_52),
        .R51(adder_tree5_alu_output_r_2_0_51), .R50(adder_tree5_alu_output_r_2_0_50),
        .R49(adder_tree5_alu_output_r_2_0_49), .R48(adder_tree5_alu_output_r_2_0_48),
        .R47(adder_tree5_alu_output_r_2_0_47), .R46(adder_tree5_alu_output_r_2_0_46),
        .R45(adder_tree5_alu_output_r_2_0_45), .R44(adder_tree5_alu_output_r_2_0_44),
        .R43(adder_tree5_alu_output_r_2_0_43), .R42(adder_tree5_alu_output_r_2_0_42),
        .R41(adder_tree5_alu_output_r_2_0_41), .R40(adder_tree5_alu_output_r_2_0_40),
        .R39(adder_tree5_alu_output_r_2_0_39), .R38(adder_tree5_alu_output_r_2_0_38),
        .R37(adder_tree5_alu_output_r_2_0_37), .R36(adder_tree5_alu_output_r_2_0_36),
        .R35(adder_tree5_alu_output_r_2_0_35), .R34(adder_tree5_alu_output_r_2_0_34),
        .R33(adder_tree5_alu_output_r_2_0_33), .R32(adder_tree5_alu_output_r_2_0_32),
        .R31(adder_tree5_alu_output_r_2_0_31), .R30(adder_tree5_alu_output_r_2_0_30),
        .R29(adder_tree5_alu_output_r_2_0_29), .R28(adder_tree5_alu_output_r_2_0_28),
        .R27(adder_tree5_alu_output_r_2_0_27), .R26(adder_tree5_alu_output_r_2_0_26),
        .R25(adder_tree5_alu_output_r_2_0_25), .R24(adder_tree5_alu_output_r_2_0_24),
        .R23(adder_tree5_alu_output_r_2_0_23), .R22(adder_tree5_alu_output_r_2_0_22),
        .R21(adder_tree5_alu_output_r_2_0_21), .R20(adder_tree5_alu_output_r_2_0_20),
        .R19(adder_tree5_alu_output_r_2_0_19), .R18(adder_tree5_alu_output_r_2_0_18),
        .R17(adder_tree5_alu_output_r_2_0_17), .R16(adder_tree5_alu_output_r_2_0_16),
        .R15(adder_tree5_alu_output_r_2_0_15), .R14(adder_tree5_alu_output_r_2_0_14),
        .R13(adder_tree5_alu_output_r_2_0_13), .R12(adder_tree5_alu_output_r_2_0_12),
        .R11(adder_tree5_alu_output_r_2_0_11), .R10(adder_tree5_alu_output_r_2_0_10),
        .R9(adder_tree5_alu_output_r_2_0_9), .R8(adder_tree5_alu_output_r_2_0_8),
        .R7(adder_tree5_alu_output_r_2_0_7), .R6(adder_tree5_alu_output_r_2_0_6),
        .R5(adder_tree5_alu_output_r_2_0_5), .R4(adder_tree5_alu_output_r_2_0_4),
        .R3(adder_tree5_alu_output_r_2_0_3), .R2(adder_tree5_alu_output_r_2_0_2),
        .R1(adder_tree5_alu_output_r_2_0_1), .R0(adder_tree5_alu_output_r_2_0_0),
        .CO53(), .CO52(), .CO51(), .CO50(), .CO49(), .CO48(), .CO47(), .CO46(),
        .CO45(), .CO44(), .CO43(), .CO42(), .CO41(), .CO40(), .CO39(), .CO38(),
        .CO37(), .CO36(), .CO35(), .CO34(), .CO33(), .CO32(), .CO31(), .CO30(),
        .CO29(), .CO28(), .CO27(), .CO26(), .CO25(), .CO24(), .CO23(), .CO22(),
        .CO21(), .CO20(), .CO19(), .CO18(), .CO17(), .CO16(), .CO15(), .CO14(),
        .CO13(), .CO12(), .CO11(), .CO10(), .CO9(), .CO8(), .CO7(), .CO6(),
        .CO5(), .CO4(), .CO3(), .CO2(), .CO1(), .CO0(), .EQZ(), .EQZM(),
        .EQOM(), .EQPAT(), .EQPATB(), .OVER(), .UNDER(), .OVERUNDER(), .SIGNEDR(adder_tree5_alu_signedr_2_0));

    defparam dsp_mult_3.CLK3_DIV = "ENABLED" ;
    defparam dsp_mult_3.CLK2_DIV = "ENABLED" ;
    defparam dsp_mult_3.CLK1_DIV = "DISABLED" ;
    defparam dsp_mult_3.CLK0_DIV = "ENABLED" ;
    defparam dsp_mult_3.HIGHSPEED_CLK = "NONE" ;
    defparam dsp_mult_3.REG_INPUTC_RST = "RST0" ;
    defparam dsp_mult_3.REG_INPUTC_CE = "CE0" ;
    defparam dsp_mult_3.REG_INPUTC_CLK = "NONE" ;
    defparam dsp_mult_3.SOURCEB_MODE = "B_SHIFT" ;
    defparam dsp_mult_3.MULT_BYPASS = "ENABLED" ;
    defparam dsp_mult_3.CAS_MATCH_REG = "FALSE" ;
    defparam dsp_mult_3.RESETMODE = "SYNC" ;
    defparam dsp_mult_3.GSR = "ENABLED" ;
    defparam dsp_mult_3.REG_OUTPUT_RST = "RST0" ;
    defparam dsp_mult_3.REG_OUTPUT_CE = "CE0" ;
    defparam dsp_mult_3.REG_OUTPUT_CLK = "NONE" ;
    defparam dsp_mult_3.REG_PIPELINE_RST = "RST0" ;
    defparam dsp_mult_3.REG_PIPELINE_CE = "CE0" ;
    defparam dsp_mult_3.REG_PIPELINE_CLK = "NONE" ;
    defparam dsp_mult_3.REG_INPUTB_RST = "RST0" ;
    defparam dsp_mult_3.REG_INPUTB_CE = "CE0" ;
    defparam dsp_mult_3.REG_INPUTB_CLK = "CLK0" ;
    defparam dsp_mult_3.REG_INPUTA_RST = "RST0" ;
    defparam dsp_mult_3.REG_INPUTA_CE = "CE0" ;
    defparam dsp_mult_3.REG_INPUTA_CLK = "CLK0" ;
    MULT18X18D dsp_mult_3 (.A17(scuba_vlo), .A16(scuba_vlo), .A15(i_data_a1[15]),
        .A14(i_data_a1[14]), .A13(i_data_a1[13]), .A12(i_data_a1[12]), .A11(i_data_a1[11]),
        .A10(i_data_a1[10]), .A9(i_data_a1[9]), .A8(i_data_a1[8]), .A7(i_data_a1[7]),
        .A6(i_data_a1[6]), .A5(i_data_a1[5]), .A4(i_data_a1[4]), .A3(i_data_a1[3]),
        .A2(i_data_a1[2]), .A1(i_data_a1[1]), .A0(i_data_a1[0]), .B17(scuba_vlo),
        .B16(scuba_vlo), .B15(scuba_vlo), .B14(scuba_vlo), .B13(scuba_vlo),
        .B12(scuba_vlo), .B11(scuba_vlo), .B10(scuba_vlo), .B9(scuba_vlo),
        .B8(scuba_vlo), .B7(scuba_vlo), .B6(scuba_vlo), .B5(scuba_vlo),
        .B4(scuba_vlo), .B3(scuba_vlo), .B2(scuba_vlo), .B1(scuba_vlo),
        .B0(scuba_vlo), .C17(scuba_vlo), .C16(scuba_vlo), .C15(scuba_vlo),
        .C14(scuba_vlo), .C13(scuba_vlo), .C12(scuba_vlo), .C11(scuba_vlo),
        .C10(scuba_vlo), .C9(scuba_vlo), .C8(scuba_vlo), .C7(scuba_vlo),
        .C6(scuba_vlo), .C5(scuba_vlo), .C4(scuba_vlo), .C3(scuba_vlo),
        .C2(scuba_vlo), .C1(scuba_vlo), .C0(scuba_vlo), .SIGNEDA(scuba_vhi),
        .SIGNEDB(scuba_vhi), .SOURCEA(scuba_vlo), .SOURCEB(scuba_vlo), .CE0(i_enable),
        .CE1(scuba_vhi), .CE2(scuba_vhi), .CE3(scuba_vhi), .CLK0(i_clock),
        .CLK1(scuba_vhi), .CLK2(scuba_vhi), .CLK3(scuba_vhi), .RST0(i_reset),
        .RST1(scuba_vlo), .RST2(scuba_vlo), .RST3(scuba_vlo), .SRIA17(scuba_vlo),
        .SRIA16(scuba_vlo), .SRIA15(scuba_vlo), .SRIA14(scuba_vlo), .SRIA13(scuba_vlo),
        .SRIA12(scuba_vlo), .SRIA11(scuba_vlo), .SRIA10(scuba_vlo), .SRIA9(scuba_vlo),
        .SRIA8(scuba_vlo), .SRIA7(scuba_vlo), .SRIA6(scuba_vlo), .SRIA5(scuba_vlo),
        .SRIA4(scuba_vlo), .SRIA3(scuba_vlo), .SRIA2(scuba_vlo), .SRIA1(scuba_vlo),
        .SRIA0(scuba_vlo), .SRIB17(scuba_vlo), .SRIB16(scuba_vlo), .SRIB15(scuba_vlo),
        .SRIB14(scuba_vlo), .SRIB13(scuba_vlo), .SRIB12(scuba_vlo), .SRIB11(scuba_vlo),
        .SRIB10(scuba_vlo), .SRIB9(scuba_vlo), .SRIB8(scuba_vlo), .SRIB7(scuba_vlo),
        .SRIB6(scuba_vlo), .SRIB5(scuba_vlo), .SRIB4(scuba_vlo), .SRIB3(scuba_vlo),
        .SRIB2(scuba_vlo), .SRIB1(scuba_vlo), .SRIB0(scuba_vlo), .SROA17(),
        .SROA16(), .SROA15(), .SROA14(), .SROA13(), .SROA12(), .SROA11(),
        .SROA10(), .SROA9(), .SROA8(), .SROA7(), .SROA6(), .SROA5(), .SROA4(),
        .SROA3(), .SROA2(), .SROA1(), .SROA0(), .SROB17(), .SROB16(), .SROB15(),
        .SROB14(), .SROB13(), .SROB12(), .SROB11(), .SROB10(), .SROB9(),
        .SROB8(), .SROB7(), .SROB6(), .SROB5(), .SROB4(), .SROB3(), .SROB2(),
        .SROB1(), .SROB0(), .ROA17(adder_tree5_0_mult_out_roa_0_17), .ROA16(adder_tree5_0_mult_out_roa_0_16),
        .ROA15(adder_tree5_0_mult_out_roa_0_15), .ROA14(adder_tree5_0_mult_out_roa_0_14),
        .ROA13(adder_tree5_0_mult_out_roa_0_13), .ROA12(adder_tree5_0_mult_out_roa_0_12),
        .ROA11(adder_tree5_0_mult_out_roa_0_11), .ROA10(adder_tree5_0_mult_out_roa_0_10),
        .ROA9(adder_tree5_0_mult_out_roa_0_9), .ROA8(adder_tree5_0_mult_out_roa_0_8),
        .ROA7(adder_tree5_0_mult_out_roa_0_7), .ROA6(adder_tree5_0_mult_out_roa_0_6),
        .ROA5(adder_tree5_0_mult_out_roa_0_5), .ROA4(adder_tree5_0_mult_out_roa_0_4),
        .ROA3(adder_tree5_0_mult_out_roa_0_3), .ROA2(adder_tree5_0_mult_out_roa_0_2),
        .ROA1(adder_tree5_0_mult_out_roa_0_1), .ROA0(adder_tree5_0_mult_out_roa_0_0),
        .ROB17(adder_tree5_0_mult_out_rob_0_17), .ROB16(adder_tree5_0_mult_out_rob_0_16),
        .ROB15(adder_tree5_0_mult_out_rob_0_15), .ROB14(adder_tree5_0_mult_out_rob_0_14),
        .ROB13(adder_tree5_0_mult_out_rob_0_13), .ROB12(adder_tree5_0_mult_out_rob_0_12),
        .ROB11(adder_tree5_0_mult_out_rob_0_11), .ROB10(adder_tree5_0_mult_out_rob_0_10),
        .ROB9(adder_tree5_0_mult_out_rob_0_9), .ROB8(adder_tree5_0_mult_out_rob_0_8),
        .ROB7(adder_tree5_0_mult_out_rob_0_7), .ROB6(adder_tree5_0_mult_out_rob_0_6),
        .ROB5(adder_tree5_0_mult_out_rob_0_5), .ROB4(adder_tree5_0_mult_out_rob_0_4),
        .ROB3(adder_tree5_0_mult_out_rob_0_3), .ROB2(adder_tree5_0_mult_out_rob_0_2),
        .ROB1(adder_tree5_0_mult_out_rob_0_1), .ROB0(adder_tree5_0_mult_out_rob_0_0),
        .ROC17(), .ROC16(), .ROC15(), .ROC14(), .ROC13(), .ROC12(), .ROC11(),
        .ROC10(), .ROC9(), .ROC8(), .ROC7(), .ROC6(), .ROC5(), .ROC4(),
        .ROC3(), .ROC2(), .ROC1(), .ROC0(), .P35(adder_tree5_0_mult_out_p_0_35),
        .P34(adder_tree5_0_mult_out_p_0_34), .P33(adder_tree5_0_mult_out_p_0_33),
        .P32(adder_tree5_0_mult_out_p_0_32), .P31(adder_tree5_0_mult_out_p_0_31),
        .P30(adder_tree5_0_mult_out_p_0_30), .P29(adder_tree5_0_mult_out_p_0_29),
        .P28(adder_tree5_0_mult_out_p_0_28), .P27(adder_tree5_0_mult_out_p_0_27),
        .P26(adder_tree5_0_mult_out_p_0_26), .P25(adder_tree5_0_mult_out_p_0_25),
        .P24(adder_tree5_0_mult_out_p_0_24), .P23(adder_tree5_0_mult_out_p_0_23),
        .P22(adder_tree5_0_mult_out_p_0_22), .P21(adder_tree5_0_mult_out_p_0_21),
        .P20(adder_tree5_0_mult_out_p_0_20), .P19(adder_tree5_0_mult_out_p_0_19),
        .P18(adder_tree5_0_mult_out_p_0_18), .P17(adder_tree5_0_mult_out_p_0_17),
        .P16(adder_tree5_0_mult_out_p_0_16), .P15(adder_tree5_0_mult_out_p_0_15),
        .P14(adder_tree5_0_mult_out_p_0_14), .P13(adder_tree5_0_mult_out_p_0_13),
        .P12(adder_tree5_0_mult_out_p_0_12), .P11(adder_tree5_0_mult_out_p_0_11),
        .P10(adder_tree5_0_mult_out_p_0_10), .P9(adder_tree5_0_mult_out_p_0_9),
        .P8(adder_tree5_0_mult_out_p_0_8), .P7(adder_tree5_0_mult_out_p_0_7),
        .P6(adder_tree5_0_mult_out_p_0_6), .P5(adder_tree5_0_mult_out_p_0_5),
        .P4(adder_tree5_0_mult_out_p_0_4), .P3(adder_tree5_0_mult_out_p_0_3),
        .P2(adder_tree5_0_mult_out_p_0_2), .P1(adder_tree5_0_mult_out_p_0_1),
        .P0(adder_tree5_0_mult_out_p_0_0), .SIGNEDP(adder_tree5_0_mult_out_signedp_0));

    defparam dsp_mult_2.CLK3_DIV = "ENABLED" ;
    defparam dsp_mult_2.CLK2_DIV = "ENABLED" ;
    defparam dsp_mult_2.CLK1_DIV = "DISABLED" ;
    defparam dsp_mult_2.CLK0_DIV = "ENABLED" ;
    defparam dsp_mult_2.HIGHSPEED_CLK = "NONE" ;
    defparam dsp_mult_2.REG_INPUTC_RST = "RST0" ;
    defparam dsp_mult_2.REG_INPUTC_CE = "CE0" ;
    defparam dsp_mult_2.REG_INPUTC_CLK = "NONE" ;
    defparam dsp_mult_2.SOURCEB_MODE = "B_SHIFT" ;
    defparam dsp_mult_2.MULT_BYPASS = "ENABLED" ;
    defparam dsp_mult_2.CAS_MATCH_REG = "FALSE" ;
    defparam dsp_mult_2.RESETMODE = "SYNC" ;
    defparam dsp_mult_2.GSR = "ENABLED" ;
    defparam dsp_mult_2.REG_OUTPUT_RST = "RST0" ;
    defparam dsp_mult_2.REG_OUTPUT_CE = "CE0" ;
    defparam dsp_mult_2.REG_OUTPUT_CLK = "NONE" ;
    defparam dsp_mult_2.REG_PIPELINE_RST = "RST0" ;
    defparam dsp_mult_2.REG_PIPELINE_CE = "CE0" ;
    defparam dsp_mult_2.REG_PIPELINE_CLK = "NONE" ;
    defparam dsp_mult_2.REG_INPUTB_RST = "RST0" ;
    defparam dsp_mult_2.REG_INPUTB_CE = "CE0" ;
    defparam dsp_mult_2.REG_INPUTB_CLK = "CLK0" ;
    defparam dsp_mult_2.REG_INPUTA_RST = "RST0" ;
    defparam dsp_mult_2.REG_INPUTA_CE = "CE0" ;
    defparam dsp_mult_2.REG_INPUTA_CLK = "CLK0" ;
    MULT18X18D dsp_mult_2 (.A17(scuba_vlo), .A16(scuba_vlo), .A15(i_data_a2[15]),
        .A14(i_data_a2[14]), .A13(i_data_a2[13]), .A12(i_data_a2[12]), .A11(i_data_a2[11]),
        .A10(i_data_a2[10]), .A9(i_data_a2[9]), .A8(i_data_a2[8]), .A7(i_data_a2[7]),
        .A6(i_data_a2[6]), .A5(i_data_a2[5]), .A4(i_data_a2[4]), .A3(i_data_a2[3]),
        .A2(i_data_a2[2]), .A1(i_data_a2[1]), .A0(i_data_a2[0]), .B17(scuba_vlo),
        .B16(scuba_vlo), .B15(scuba_vlo), .B14(scuba_vlo), .B13(scuba_vlo),
        .B12(scuba_vlo), .B11(scuba_vlo), .B10(scuba_vlo), .B9(scuba_vlo),
        .B8(scuba_vlo), .B7(scuba_vlo), .B6(scuba_vlo), .B5(scuba_vlo),
        .B4(scuba_vlo), .B3(scuba_vlo), .B2(scuba_vlo), .B1(scuba_vlo),
        .B0(scuba_vlo), .C17(scuba_vlo), .C16(scuba_vlo), .C15(scuba_vlo),
        .C14(scuba_vlo), .C13(scuba_vlo), .C12(scuba_vlo), .C11(scuba_vlo),
        .C10(scuba_vlo), .C9(scuba_vlo), .C8(scuba_vlo), .C7(scuba_vlo),
        .C6(scuba_vlo), .C5(scuba_vlo), .C4(scuba_vlo), .C3(scuba_vlo),
        .C2(scuba_vlo), .C1(scuba_vlo), .C0(scuba_vlo), .SIGNEDA(scuba_vlo),
        .SIGNEDB(scuba_vlo), .SOURCEA(scuba_vlo), .SOURCEB(scuba_vlo), .CE0(i_enable),
        .CE1(scuba_vhi), .CE2(scuba_vhi), .CE3(scuba_vhi), .CLK0(i_clock),
        .CLK1(scuba_vhi), .CLK2(scuba_vhi), .CLK3(scuba_vhi), .RST0(i_reset),
        .RST1(scuba_vlo), .RST2(scuba_vlo), .RST3(scuba_vlo), .SRIA17(scuba_vlo),
        .SRIA16(scuba_vlo), .SRIA15(scuba_vlo), .SRIA14(scuba_vlo), .SRIA13(scuba_vlo),
        .SRIA12(scuba_vlo), .SRIA11(scuba_vlo), .SRIA10(scuba_vlo), .SRIA9(scuba_vlo),
        .SRIA8(scuba_vlo), .SRIA7(scuba_vlo), .SRIA6(scuba_vlo), .SRIA5(scuba_vlo),
        .SRIA4(scuba_vlo), .SRIA3(scuba_vlo), .SRIA2(scuba_vlo), .SRIA1(scuba_vlo),
        .SRIA0(scuba_vlo), .SRIB17(scuba_vlo), .SRIB16(scuba_vlo), .SRIB15(scuba_vlo),
        .SRIB14(scuba_vlo), .SRIB13(scuba_vlo), .SRIB12(scuba_vlo), .SRIB11(scuba_vlo),
        .SRIB10(scuba_vlo), .SRIB9(scuba_vlo), .SRIB8(scuba_vlo), .SRIB7(scuba_vlo),
        .SRIB6(scuba_vlo), .SRIB5(scuba_vlo), .SRIB4(scuba_vlo), .SRIB3(scuba_vlo),
        .SRIB2(scuba_vlo), .SRIB1(scuba_vlo), .SRIB0(scuba_vlo), .SROA17(),
        .SROA16(), .SROA15(), .SROA14(), .SROA13(), .SROA12(), .SROA11(),
        .SROA10(), .SROA9(), .SROA8(), .SROA7(), .SROA6(), .SROA5(), .SROA4(),
        .SROA3(), .SROA2(), .SROA1(), .SROA0(), .SROB17(), .SROB16(), .SROB15(),
        .SROB14(), .SROB13(), .SROB12(), .SROB11(), .SROB10(), .SROB9(),
        .SROB8(), .SROB7(), .SROB6(), .SROB5(), .SROB4(), .SROB3(), .SROB2(),
        .SROB1(), .SROB0(), .ROA17(adder_tree5_0_mult_out_roa_1_17), .ROA16(adder_tree5_0_mult_out_roa_1_16),
        .ROA15(adder_tree5_0_mult_out_roa_1_15), .ROA14(adder_tree5_0_mult_out_roa_1_14),
        .ROA13(adder_tree5_0_mult_out_roa_1_13), .ROA12(adder_tree5_0_mult_out_roa_1_12),
        .ROA11(adder_tree5_0_mult_out_roa_1_11), .ROA10(adder_tree5_0_mult_out_roa_1_10),
        .ROA9(adder_tree5_0_mult_out_roa_1_9), .ROA8(adder_tree5_0_mult_out_roa_1_8),
        .ROA7(adder_tree5_0_mult_out_roa_1_7), .ROA6(adder_tree5_0_mult_out_roa_1_6),
        .ROA5(adder_tree5_0_mult_out_roa_1_5), .ROA4(adder_tree5_0_mult_out_roa_1_4),
        .ROA3(adder_tree5_0_mult_out_roa_1_3), .ROA2(adder_tree5_0_mult_out_roa_1_2),
        .ROA1(adder_tree5_0_mult_out_roa_1_1), .ROA0(adder_tree5_0_mult_out_roa_1_0),
        .ROB17(adder_tree5_0_mult_out_rob_1_17), .ROB16(adder_tree5_0_mult_out_rob_1_16),
        .ROB15(adder_tree5_0_mult_out_rob_1_15), .ROB14(adder_tree5_0_mult_out_rob_1_14),
        .ROB13(adder_tree5_0_mult_out_rob_1_13), .ROB12(adder_tree5_0_mult_out_rob_1_12),
        .ROB11(adder_tree5_0_mult_out_rob_1_11), .ROB10(adder_tree5_0_mult_out_rob_1_10),
        .ROB9(adder_tree5_0_mult_out_rob_1_9), .ROB8(adder_tree5_0_mult_out_rob_1_8),
        .ROB7(adder_tree5_0_mult_out_rob_1_7), .ROB6(adder_tree5_0_mult_out_rob_1_6),
        .ROB5(adder_tree5_0_mult_out_rob_1_5), .ROB4(adder_tree5_0_mult_out_rob_1_4),
        .ROB3(adder_tree5_0_mult_out_rob_1_3), .ROB2(adder_tree5_0_mult_out_rob_1_2),
        .ROB1(adder_tree5_0_mult_out_rob_1_1), .ROB0(adder_tree5_0_mult_out_rob_1_0),
        .ROC17(), .ROC16(), .ROC15(), .ROC14(), .ROC13(), .ROC12(), .ROC11(),
        .ROC10(), .ROC9(), .ROC8(), .ROC7(), .ROC6(), .ROC5(), .ROC4(),
        .ROC3(), .ROC2(), .ROC1(), .ROC0(), .P35(adder_tree5_0_mult_out_p_1_35),
        .P34(adder_tree5_0_mult_out_p_1_34), .P33(adder_tree5_0_mult_out_p_1_33),
        .P32(adder_tree5_0_mult_out_p_1_32), .P31(adder_tree5_0_mult_out_p_1_31),
        .P30(adder_tree5_0_mult_out_p_1_30), .P29(adder_tree5_0_mult_out_p_1_29),
        .P28(adder_tree5_0_mult_out_p_1_28), .P27(adder_tree5_0_mult_out_p_1_27),
        .P26(adder_tree5_0_mult_out_p_1_26), .P25(adder_tree5_0_mult_out_p_1_25),
        .P24(adder_tree5_0_mult_out_p_1_24), .P23(adder_tree5_0_mult_out_p_1_23),
        .P22(adder_tree5_0_mult_out_p_1_22), .P21(adder_tree5_0_mult_out_p_1_21),
        .P20(adder_tree5_0_mult_out_p_1_20), .P19(adder_tree5_0_mult_out_p_1_19),
        .P18(adder_tree5_0_mult_out_p_1_18), .P17(adder_tree5_0_mult_out_p_1_17),
        .P16(adder_tree5_0_mult_out_p_1_16), .P15(adder_tree5_0_mult_out_p_1_15),
        .P14(adder_tree5_0_mult_out_p_1_14), .P13(adder_tree5_0_mult_out_p_1_13),
        .P12(adder_tree5_0_mult_out_p_1_12), .P11(adder_tree5_0_mult_out_p_1_11),
        .P10(adder_tree5_0_mult_out_p_1_10), .P9(adder_tree5_0_mult_out_p_1_9),
        .P8(adder_tree5_0_mult_out_p_1_8), .P7(adder_tree5_0_mult_out_p_1_7),
        .P6(adder_tree5_0_mult_out_p_1_6), .P5(adder_tree5_0_mult_out_p_1_5),
        .P4(adder_tree5_0_mult_out_p_1_4), .P3(adder_tree5_0_mult_out_p_1_3),
        .P2(adder_tree5_0_mult_out_p_1_2), .P1(adder_tree5_0_mult_out_p_1_1),
        .P0(adder_tree5_0_mult_out_p_1_0), .SIGNEDP(adder_tree5_0_mult_out_signedp_1));

    defparam dsp_mult_1.CLK3_DIV = "ENABLED" ;
    defparam dsp_mult_1.CLK2_DIV = "ENABLED" ;
    defparam dsp_mult_1.CLK1_DIV = "DISABLED" ;
    defparam dsp_mult_1.CLK0_DIV = "ENABLED" ;
    defparam dsp_mult_1.HIGHSPEED_CLK = "NONE" ;
    defparam dsp_mult_1.REG_INPUTC_RST = "RST0" ;
    defparam dsp_mult_1.REG_INPUTC_CE = "CE0" ;
    defparam dsp_mult_1.REG_INPUTC_CLK = "NONE" ;
    defparam dsp_mult_1.SOURCEB_MODE = "B_SHIFT" ;
    defparam dsp_mult_1.MULT_BYPASS = "ENABLED" ;
    defparam dsp_mult_1.CAS_MATCH_REG = "FALSE" ;
    defparam dsp_mult_1.RESETMODE = "SYNC" ;
    defparam dsp_mult_1.GSR = "ENABLED" ;
    defparam dsp_mult_1.REG_OUTPUT_RST = "RST0" ;
    defparam dsp_mult_1.REG_OUTPUT_CE = "CE0" ;
    defparam dsp_mult_1.REG_OUTPUT_CLK = "NONE" ;
    defparam dsp_mult_1.REG_PIPELINE_RST = "RST0" ;
    defparam dsp_mult_1.REG_PIPELINE_CE = "CE0" ;
    defparam dsp_mult_1.REG_PIPELINE_CLK = "NONE" ;
    defparam dsp_mult_1.REG_INPUTB_RST = "RST0" ;
    defparam dsp_mult_1.REG_INPUTB_CE = "CE0" ;
    defparam dsp_mult_1.REG_INPUTB_CLK = "CLK0" ;
    defparam dsp_mult_1.REG_INPUTA_RST = "RST0" ;
    defparam dsp_mult_1.REG_INPUTA_CE = "CE0" ;
    defparam dsp_mult_1.REG_INPUTA_CLK = "CLK0" ;
    MULT18X18D dsp_mult_1 (.A17(scuba_vlo), .A16(scuba_vlo), .A15(adder_tree5ar1_3_i_d_15),
        .A14(adder_tree5ar1_3_i_d_14), .A13(adder_tree5ar1_3_i_d_13), .A12(adder_tree5ar1_3_i_d_12),
        .A11(adder_tree5ar1_3_i_d_11), .A10(adder_tree5ar1_3_i_d_10), .A9(adder_tree5ar1_3_i_d_9),
        .A8(adder_tree5ar1_3_i_d_8), .A7(adder_tree5ar1_3_i_d_7), .A6(adder_tree5ar1_3_i_d_6),
        .A5(adder_tree5ar1_3_i_d_5), .A4(adder_tree5ar1_3_i_d_4), .A3(adder_tree5ar1_3_i_d_3),
        .A2(adder_tree5ar1_3_i_d_2), .A1(adder_tree5ar1_3_i_d_1), .A0(adder_tree5ar1_3_i_d_0),
        .B17(scuba_vlo), .B16(scuba_vlo), .B15(scuba_vlo), .B14(scuba_vlo),
        .B13(scuba_vlo), .B12(scuba_vlo), .B11(scuba_vlo), .B10(scuba_vlo),
        .B9(scuba_vlo), .B8(scuba_vlo), .B7(scuba_vlo), .B6(scuba_vlo),
        .B5(scuba_vlo), .B4(scuba_vlo), .B3(scuba_vlo), .B2(scuba_vlo),
        .B1(scuba_vlo), .B0(scuba_vlo), .C17(scuba_vlo), .C16(scuba_vlo),
        .C15(scuba_vlo), .C14(scuba_vlo), .C13(scuba_vlo), .C12(scuba_vlo),
        .C11(scuba_vlo), .C10(scuba_vlo), .C9(scuba_vlo), .C8(scuba_vlo),
        .C7(scuba_vlo), .C6(scuba_vlo), .C5(scuba_vlo), .C4(scuba_vlo),
        .C3(scuba_vlo), .C2(scuba_vlo), .C1(scuba_vlo), .C0(scuba_vlo),
        .SIGNEDA(scuba_vhi), .SIGNEDB(scuba_vhi), .SOURCEA(scuba_vlo), .SOURCEB(scuba_vlo),
        .CE0(i_enable), .CE1(scuba_vhi), .CE2(scuba_vhi), .CE3(scuba_vhi),
        .CLK0(i_clock), .CLK1(scuba_vhi), .CLK2(scuba_vhi), .CLK3(scuba_vhi),
        .RST0(i_reset), .RST1(scuba_vlo), .RST2(scuba_vlo), .RST3(scuba_vlo),
        .SRIA17(scuba_vlo), .SRIA16(scuba_vlo), .SRIA15(scuba_vlo), .SRIA14(scuba_vlo),
        .SRIA13(scuba_vlo), .SRIA12(scuba_vlo), .SRIA11(scuba_vlo), .SRIA10(scuba_vlo),
        .SRIA9(scuba_vlo), .SRIA8(scuba_vlo), .SRIA7(scuba_vlo), .SRIA6(scuba_vlo),
        .SRIA5(scuba_vlo), .SRIA4(scuba_vlo), .SRIA3(scuba_vlo), .SRIA2(scuba_vlo),
        .SRIA1(scuba_vlo), .SRIA0(scuba_vlo), .SRIB17(scuba_vlo), .SRIB16(scuba_vlo),
        .SRIB15(scuba_vlo), .SRIB14(scuba_vlo), .SRIB13(scuba_vlo), .SRIB12(scuba_vlo),
        .SRIB11(scuba_vlo), .SRIB10(scuba_vlo), .SRIB9(scuba_vlo), .SRIB8(scuba_vlo),
        .SRIB7(scuba_vlo), .SRIB6(scuba_vlo), .SRIB5(scuba_vlo), .SRIB4(scuba_vlo),
        .SRIB3(scuba_vlo), .SRIB2(scuba_vlo), .SRIB1(scuba_vlo), .SRIB0(scuba_vlo),
        .SROA17(), .SROA16(), .SROA15(), .SROA14(), .SROA13(), .SROA12(),
        .SROA11(), .SROA10(), .SROA9(), .SROA8(), .SROA7(), .SROA6(), .SROA5(),
        .SROA4(), .SROA3(), .SROA2(), .SROA1(), .SROA0(), .SROB17(), .SROB16(),
        .SROB15(), .SROB14(), .SROB13(), .SROB12(), .SROB11(), .SROB10(),
        .SROB9(), .SROB8(), .SROB7(), .SROB6(), .SROB5(), .SROB4(), .SROB3(),
        .SROB2(), .SROB1(), .SROB0(), .ROA17(adder_tree5_1_mult_out_roa_0_17),
        .ROA16(adder_tree5_1_mult_out_roa_0_16), .ROA15(adder_tree5_1_mult_out_roa_0_15),
        .ROA14(adder_tree5_1_mult_out_roa_0_14), .ROA13(adder_tree5_1_mult_out_roa_0_13),
        .ROA12(adder_tree5_1_mult_out_roa_0_12), .ROA11(adder_tree5_1_mult_out_roa_0_11),
        .ROA10(adder_tree5_1_mult_out_roa_0_10), .ROA9(adder_tree5_1_mult_out_roa_0_9),
        .ROA8(adder_tree5_1_mult_out_roa_0_8), .ROA7(adder_tree5_1_mult_out_roa_0_7),
        .ROA6(adder_tree5_1_mult_out_roa_0_6), .ROA5(adder_tree5_1_mult_out_roa_0_5),
        .ROA4(adder_tree5_1_mult_out_roa_0_4), .ROA3(adder_tree5_1_mult_out_roa_0_3),
        .ROA2(adder_tree5_1_mult_out_roa_0_2), .ROA1(adder_tree5_1_mult_out_roa_0_1),
        .ROA0(adder_tree5_1_mult_out_roa_0_0), .ROB17(adder_tree5_1_mult_out_rob_0_17),
        .ROB16(adder_tree5_1_mult_out_rob_0_16), .ROB15(adder_tree5_1_mult_out_rob_0_15),
        .ROB14(adder_tree5_1_mult_out_rob_0_14), .ROB13(adder_tree5_1_mult_out_rob_0_13),
        .ROB12(adder_tree5_1_mult_out_rob_0_12), .ROB11(adder_tree5_1_mult_out_rob_0_11),
        .ROB10(adder_tree5_1_mult_out_rob_0_10), .ROB9(adder_tree5_1_mult_out_rob_0_9),
        .ROB8(adder_tree5_1_mult_out_rob_0_8), .ROB7(adder_tree5_1_mult_out_rob_0_7),
        .ROB6(adder_tree5_1_mult_out_rob_0_6), .ROB5(adder_tree5_1_mult_out_rob_0_5),
        .ROB4(adder_tree5_1_mult_out_rob_0_4), .ROB3(adder_tree5_1_mult_out_rob_0_3),
        .ROB2(adder_tree5_1_mult_out_rob_0_2), .ROB1(adder_tree5_1_mult_out_rob_0_1),
        .ROB0(adder_tree5_1_mult_out_rob_0_0), .ROC17(), .ROC16(), .ROC15(),
        .ROC14(), .ROC13(), .ROC12(), .ROC11(), .ROC10(), .ROC9(), .ROC8(),
        .ROC7(), .ROC6(), .ROC5(), .ROC4(), .ROC3(), .ROC2(), .ROC1(), .ROC0(),
        .P35(adder_tree5_1_mult_out_p_0_35), .P34(adder_tree5_1_mult_out_p_0_34),
        .P33(adder_tree5_1_mult_out_p_0_33), .P32(adder_tree5_1_mult_out_p_0_32),
        .P31(adder_tree5_1_mult_out_p_0_31), .P30(adder_tree5_1_mult_out_p_0_30),
        .P29(adder_tree5_1_mult_out_p_0_29), .P28(adder_tree5_1_mult_out_p_0_28),
        .P27(adder_tree5_1_mult_out_p_0_27), .P26(adder_tree5_1_mult_out_p_0_26),
        .P25(adder_tree5_1_mult_out_p_0_25), .P24(adder_tree5_1_mult_out_p_0_24),
        .P23(adder_tree5_1_mult_out_p_0_23), .P22(adder_tree5_1_mult_out_p_0_22),
        .P21(adder_tree5_1_mult_out_p_0_21), .P20(adder_tree5_1_mult_out_p_0_20),
        .P19(adder_tree5_1_mult_out_p_0_19), .P18(adder_tree5_1_mult_out_p_0_18),
        .P17(adder_tree5_1_mult_out_p_0_17), .P16(adder_tree5_1_mult_out_p_0_16),
        .P15(adder_tree5_1_mult_out_p_0_15), .P14(adder_tree5_1_mult_out_p_0_14),
        .P13(adder_tree5_1_mult_out_p_0_13), .P12(adder_tree5_1_mult_out_p_0_12),
        .P11(adder_tree5_1_mult_out_p_0_11), .P10(adder_tree5_1_mult_out_p_0_10),
        .P9(adder_tree5_1_mult_out_p_0_9), .P8(adder_tree5_1_mult_out_p_0_8),
        .P7(adder_tree5_1_mult_out_p_0_7), .P6(adder_tree5_1_mult_out_p_0_6),
        .P5(adder_tree5_1_mult_out_p_0_5), .P4(adder_tree5_1_mult_out_p_0_4),
        .P3(adder_tree5_1_mult_out_p_0_3), .P2(adder_tree5_1_mult_out_p_0_2),
        .P1(adder_tree5_1_mult_out_p_0_1), .P0(adder_tree5_1_mult_out_p_0_0),
        .SIGNEDP(adder_tree5_1_mult_out_signedp_0));

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    defparam dsp_mult_0.CLK3_DIV = "ENABLED" ;
    defparam dsp_mult_0.CLK2_DIV = "ENABLED" ;
    defparam dsp_mult_0.CLK1_DIV = "DISABLED" ;
    defparam dsp_mult_0.CLK0_DIV = "ENABLED" ;
    defparam dsp_mult_0.HIGHSPEED_CLK = "NONE" ;
    defparam dsp_mult_0.REG_INPUTC_RST = "RST0" ;
    defparam dsp_mult_0.REG_INPUTC_CE = "CE0" ;
    defparam dsp_mult_0.REG_INPUTC_CLK = "NONE" ;
    defparam dsp_mult_0.SOURCEB_MODE = "B_SHIFT" ;
    defparam dsp_mult_0.MULT_BYPASS = "ENABLED" ;
    defparam dsp_mult_0.CAS_MATCH_REG = "FALSE" ;
    defparam dsp_mult_0.RESETMODE = "SYNC" ;
    defparam dsp_mult_0.GSR = "ENABLED" ;
    defparam dsp_mult_0.REG_OUTPUT_RST = "RST0" ;
    defparam dsp_mult_0.REG_OUTPUT_CE = "CE0" ;
    defparam dsp_mult_0.REG_OUTPUT_CLK = "NONE" ;
    defparam dsp_mult_0.REG_PIPELINE_RST = "RST0" ;
    defparam dsp_mult_0.REG_PIPELINE_CE = "CE0" ;
    defparam dsp_mult_0.REG_PIPELINE_CLK = "NONE" ;
    defparam dsp_mult_0.REG_INPUTB_RST = "RST0" ;
    defparam dsp_mult_0.REG_INPUTB_CE = "CE0" ;
    defparam dsp_mult_0.REG_INPUTB_CLK = "CLK0" ;
    defparam dsp_mult_0.REG_INPUTA_RST = "RST0" ;
    defparam dsp_mult_0.REG_INPUTA_CE = "CE0" ;
    defparam dsp_mult_0.REG_INPUTA_CLK = "CLK0" ;
    MULT18X18D dsp_mult_0 (.A17(scuba_vlo), .A16(scuba_vlo), .A15(adder_tree5ar1_4_i_d_15),
        .A14(adder_tree5ar1_4_i_d_14), .A13(adder_tree5ar1_4_i_d_13), .A12(adder_tree5ar1_4_i_d_12),
        .A11(adder_tree5ar1_4_i_d_11), .A10(adder_tree5ar1_4_i_d_10), .A9(adder_tree5ar1_4_i_d_9),
        .A8(adder_tree5ar1_4_i_d_8), .A7(adder_tree5ar1_4_i_d_7), .A6(adder_tree5ar1_4_i_d_6),
        .A5(adder_tree5ar1_4_i_d_5), .A4(adder_tree5ar1_4_i_d_4), .A3(adder_tree5ar1_4_i_d_3),
        .A2(adder_tree5ar1_4_i_d_2), .A1(adder_tree5ar1_4_i_d_1), .A0(adder_tree5ar1_4_i_d_0),
        .B17(scuba_vlo), .B16(scuba_vlo), .B15(scuba_vlo), .B14(scuba_vlo),
        .B13(scuba_vlo), .B12(scuba_vlo), .B11(scuba_vlo), .B10(scuba_vlo),
        .B9(scuba_vlo), .B8(scuba_vlo), .B7(scuba_vlo), .B6(scuba_vlo),
        .B5(scuba_vlo), .B4(scuba_vlo), .B3(scuba_vlo), .B2(scuba_vlo),
        .B1(scuba_vlo), .B0(scuba_vlo), .C17(scuba_vlo), .C16(scuba_vlo),
        .C15(scuba_vlo), .C14(scuba_vlo), .C13(scuba_vlo), .C12(scuba_vlo),
        .C11(scuba_vlo), .C10(scuba_vlo), .C9(scuba_vlo), .C8(scuba_vlo),
        .C7(scuba_vlo), .C6(scuba_vlo), .C5(scuba_vlo), .C4(scuba_vlo),
        .C3(scuba_vlo), .C2(scuba_vlo), .C1(scuba_vlo), .C0(scuba_vlo),
        .SIGNEDA(scuba_vlo), .SIGNEDB(scuba_vlo), .SOURCEA(scuba_vlo), .SOURCEB(scuba_vlo),
        .CE0(i_enable), .CE1(scuba_vhi), .CE2(scuba_vhi), .CE3(scuba_vhi),
        .CLK0(i_clock), .CLK1(scuba_vhi), .CLK2(scuba_vhi), .CLK3(scuba_vhi),
        .RST0(i_reset), .RST1(scuba_vlo), .RST2(scuba_vlo), .RST3(scuba_vlo),
        .SRIA17(scuba_vlo), .SRIA16(scuba_vlo), .SRIA15(scuba_vlo), .SRIA14(scuba_vlo),
        .SRIA13(scuba_vlo), .SRIA12(scuba_vlo), .SRIA11(scuba_vlo), .SRIA10(scuba_vlo),
        .SRIA9(scuba_vlo), .SRIA8(scuba_vlo), .SRIA7(scuba_vlo), .SRIA6(scuba_vlo),
        .SRIA5(scuba_vlo), .SRIA4(scuba_vlo), .SRIA3(scuba_vlo), .SRIA2(scuba_vlo),
        .SRIA1(scuba_vlo), .SRIA0(scuba_vlo), .SRIB17(scuba_vlo), .SRIB16(scuba_vlo),
        .SRIB15(scuba_vlo), .SRIB14(scuba_vlo), .SRIB13(scuba_vlo), .SRIB12(scuba_vlo),
        .SRIB11(scuba_vlo), .SRIB10(scuba_vlo), .SRIB9(scuba_vlo), .SRIB8(scuba_vlo),
        .SRIB7(scuba_vlo), .SRIB6(scuba_vlo), .SRIB5(scuba_vlo), .SRIB4(scuba_vlo),
        .SRIB3(scuba_vlo), .SRIB2(scuba_vlo), .SRIB1(scuba_vlo), .SRIB0(scuba_vlo),
        .SROA17(), .SROA16(), .SROA15(), .SROA14(), .SROA13(), .SROA12(),
        .SROA11(), .SROA10(), .SROA9(), .SROA8(), .SROA7(), .SROA6(), .SROA5(),
        .SROA4(), .SROA3(), .SROA2(), .SROA1(), .SROA0(), .SROB17(), .SROB16(),
        .SROB15(), .SROB14(), .SROB13(), .SROB12(), .SROB11(), .SROB10(),
        .SROB9(), .SROB8(), .SROB7(), .SROB6(), .SROB5(), .SROB4(), .SROB3(),
        .SROB2(), .SROB1(), .SROB0(), .ROA17(adder_tree5_1_mult_out_roa_1_17),
        .ROA16(adder_tree5_1_mult_out_roa_1_16), .ROA15(adder_tree5_1_mult_out_roa_1_15),
        .ROA14(adder_tree5_1_mult_out_roa_1_14), .ROA13(adder_tree5_1_mult_out_roa_1_13),
        .ROA12(adder_tree5_1_mult_out_roa_1_12), .ROA11(adder_tree5_1_mult_out_roa_1_11),
        .ROA10(adder_tree5_1_mult_out_roa_1_10), .ROA9(adder_tree5_1_mult_out_roa_1_9),
        .ROA8(adder_tree5_1_mult_out_roa_1_8), .ROA7(adder_tree5_1_mult_out_roa_1_7),
        .ROA6(adder_tree5_1_mult_out_roa_1_6), .ROA5(adder_tree5_1_mult_out_roa_1_5),
        .ROA4(adder_tree5_1_mult_out_roa_1_4), .ROA3(adder_tree5_1_mult_out_roa_1_3),
        .ROA2(adder_tree5_1_mult_out_roa_1_2), .ROA1(adder_tree5_1_mult_out_roa_1_1),
        .ROA0(adder_tree5_1_mult_out_roa_1_0), .ROB17(adder_tree5_1_mult_out_rob_1_17),
        .ROB16(adder_tree5_1_mult_out_rob_1_16), .ROB15(adder_tree5_1_mult_out_rob_1_15),
        .ROB14(adder_tree5_1_mult_out_rob_1_14), .ROB13(adder_tree5_1_mult_out_rob_1_13),
        .ROB12(adder_tree5_1_mult_out_rob_1_12), .ROB11(adder_tree5_1_mult_out_rob_1_11),
        .ROB10(adder_tree5_1_mult_out_rob_1_10), .ROB9(adder_tree5_1_mult_out_rob_1_9),
        .ROB8(adder_tree5_1_mult_out_rob_1_8), .ROB7(adder_tree5_1_mult_out_rob_1_7),
        .ROB6(adder_tree5_1_mult_out_rob_1_6), .ROB5(adder_tree5_1_mult_out_rob_1_5),
        .ROB4(adder_tree5_1_mult_out_rob_1_4), .ROB3(adder_tree5_1_mult_out_rob_1_3),
        .ROB2(adder_tree5_1_mult_out_rob_1_2), .ROB1(adder_tree5_1_mult_out_rob_1_1),
        .ROB0(adder_tree5_1_mult_out_rob_1_0), .ROC17(), .ROC16(), .ROC15(),
        .ROC14(), .ROC13(), .ROC12(), .ROC11(), .ROC10(), .ROC9(), .ROC8(),
        .ROC7(), .ROC6(), .ROC5(), .ROC4(), .ROC3(), .ROC2(), .ROC1(), .ROC0(),
        .P35(adder_tree5_1_mult_out_p_1_35), .P34(adder_tree5_1_mult_out_p_1_34),
        .P33(adder_tree5_1_mult_out_p_1_33), .P32(adder_tree5_1_mult_out_p_1_32),
        .P31(adder_tree5_1_mult_out_p_1_31), .P30(adder_tree5_1_mult_out_p_1_30),
        .P29(adder_tree5_1_mult_out_p_1_29), .P28(adder_tree5_1_mult_out_p_1_28),
        .P27(adder_tree5_1_mult_out_p_1_27), .P26(adder_tree5_1_mult_out_p_1_26),
        .P25(adder_tree5_1_mult_out_p_1_25), .P24(adder_tree5_1_mult_out_p_1_24),
        .P23(adder_tree5_1_mult_out_p_1_23), .P22(adder_tree5_1_mult_out_p_1_22),
        .P21(adder_tree5_1_mult_out_p_1_21), .P20(adder_tree5_1_mult_out_p_1_20),
        .P19(adder_tree5_1_mult_out_p_1_19), .P18(adder_tree5_1_mult_out_p_1_18),
        .P17(adder_tree5_1_mult_out_p_1_17), .P16(adder_tree5_1_mult_out_p_1_16),
        .P15(adder_tree5_1_mult_out_p_1_15), .P14(adder_tree5_1_mult_out_p_1_14),
        .P13(adder_tree5_1_mult_out_p_1_13), .P12(adder_tree5_1_mult_out_p_1_12),
        .P11(adder_tree5_1_mult_out_p_1_11), .P10(adder_tree5_1_mult_out_p_1_10),
        .P9(adder_tree5_1_mult_out_p_1_9), .P8(adder_tree5_1_mult_out_p_1_8),
        .P7(adder_tree5_1_mult_out_p_1_7), .P6(adder_tree5_1_mult_out_p_1_6),
        .P5(adder_tree5_1_mult_out_p_1_5), .P4(adder_tree5_1_mult_out_p_1_4),
        .P3(adder_tree5_1_mult_out_p_1_3), .P2(adder_tree5_1_mult_out_p_1_2),
        .P1(adder_tree5_1_mult_out_p_1_1), .P0(adder_tree5_1_mult_out_p_1_0),
        .SIGNEDP(adder_tree5_1_mult_out_signedp_1));

    assign adder_tree5_0z_0 = adder_tree5_alu_output_r_1_0_0;
    assign adder_tree5_0z_1 = adder_tree5_alu_output_r_1_0_1;
    assign adder_tree5_0z_2 = adder_tree5_alu_output_r_1_0_2;
    assign adder_tree5_0z_3 = adder_tree5_alu_output_r_1_0_3;
    assign adder_tree5_0z_4 = adder_tree5_alu_output_r_1_0_4;
    assign adder_tree5_0z_5 = adder_tree5_alu_output_r_1_0_5;
    assign adder_tree5_0z_6 = adder_tree5_alu_output_r_1_0_6;
    assign adder_tree5_0z_7 = adder_tree5_alu_output_r_1_0_7;
    assign adder_tree5_0z_8 = adder_tree5_alu_output_r_1_0_8;
    assign adder_tree5_0z_9 = adder_tree5_alu_output_r_1_0_9;
    assign adder_tree5_0z_10 = adder_tree5_alu_output_r_1_0_10;
    assign adder_tree5_0z_11 = adder_tree5_alu_output_r_1_0_11;
    assign adder_tree5_0z_12 = adder_tree5_alu_output_r_1_0_12;
    assign adder_tree5_0z_13 = adder_tree5_alu_output_r_1_0_13;
    assign adder_tree5_0z_14 = adder_tree5_alu_output_r_1_0_14;
    assign adder_tree5_0z_15 = adder_tree5_alu_output_r_1_0_15;
    assign adder_tree5_0z_16 = adder_tree5_alu_output_r_1_0_16;
    assign adder_tree5_0z_17 = adder_tree5_alu_output_r_1_0_17;
    assign adder_tree5_0z_18 = adder_tree5_alu_output_r_1_0_18;
    assign adder_tree5_0z_19 = adder_tree5_alu_output_r_1_0_19;
    assign adder_tree5_0z_20 = adder_tree5_alu_output_r_1_0_20;
    assign adder_tree5_0z_21 = adder_tree5_alu_output_r_1_0_21;
    assign adder_tree5_0z_22 = adder_tree5_alu_output_r_1_0_22;
    assign adder_tree5_0z_23 = adder_tree5_alu_output_r_1_0_23;
    assign adder_tree5_0z_24 = adder_tree5_alu_output_r_1_0_24;
    assign adder_tree5_0z_25 = adder_tree5_alu_output_r_1_0_25;
    assign adder_tree5_0z_26 = adder_tree5_alu_output_r_1_0_26;
    assign adder_tree5_0z_27 = adder_tree5_alu_output_r_1_0_27;
    assign adder_tree5_0z_28 = adder_tree5_alu_output_r_1_0_28;
    assign adder_tree5_0z_29 = adder_tree5_alu_output_r_1_0_29;
    assign adder_tree5_0z_30 = adder_tree5_alu_output_r_1_0_30;
    assign adder_tree5_0z_31 = adder_tree5_alu_output_r_1_0_31;
    assign adder_tree5_0z_32 = adder_tree5_alu_output_r_1_0_32;
    assign adder_tree5_0z_33 = adder_tree5_alu_output_r_1_0_33;
    assign adder_tree5_0z_34 = adder_tree5_alu_output_r_1_0_34;
    assign adder_tree5_0z_35 = adder_tree5_alu_output_r_1_0_35;
    assign adder_tree5_0z_36 = adder_tree5_alu_output_r_1_0_36;
    assign adder_tree5_0z_37 = adder_tree5_alu_output_r_1_0_37;
    assign adder_tree5_0z_38 = adder_tree5_alu_output_r_1_0_38;
    assign adder_tree5_0z_39 = adder_tree5_alu_output_r_1_0_39;
    assign adder_tree5_0z_40 = adder_tree5_alu_output_r_1_0_40;
    assign adder_tree5_0z_41 = adder_tree5_alu_output_r_1_0_41;
    assign adder_tree5_0z_42 = adder_tree5_alu_output_r_1_0_42;
    assign adder_tree5_0z_43 = adder_tree5_alu_output_r_1_0_43;
    assign adder_tree5_0z_44 = adder_tree5_alu_output_r_1_0_44;
    assign adder_tree5_0z_45 = adder_tree5_alu_output_r_1_0_45;
    assign adder_tree5_0z_46 = adder_tree5_alu_output_r_1_0_46;
    assign adder_tree5_0z_47 = adder_tree5_alu_output_r_1_0_47;
    assign adder_tree5_0z_48 = adder_tree5_alu_output_r_1_0_48;
    assign adder_tree5_0z_49 = adder_tree5_alu_output_r_1_0_49;
    assign adder_tree5_0z_50 = adder_tree5_alu_output_r_1_0_50;
    assign adder_tree5_0z_51 = adder_tree5_alu_output_r_1_0_51;
    assign adder_tree5_0z_52 = adder_tree5_alu_output_r_1_0_52;
    assign adder_tree5_0z_53 = adder_tree5_alu_output_r_1_0_53;
    assign adder_tree5_0zs = adder_tree5_alu_signedr_1_0;
    assign o_result[0] = adder_tree5_alu_output_r_2_0_0;
    assign o_result[1] = adder_tree5_alu_output_r_2_0_1;
    assign o_result[2] = adder_tree5_alu_output_r_2_0_2;
    assign o_result[3] = adder_tree5_alu_output_r_2_0_3;
    assign o_result[4] = adder_tree5_alu_output_r_2_0_4;
    assign o_result[5] = adder_tree5_alu_output_r_2_0_5;
    assign o_result[6] = adder_tree5_alu_output_r_2_0_6;
    assign o_result[7] = adder_tree5_alu_output_r_2_0_7;
    assign o_result[8] = adder_tree5_alu_output_r_2_0_8;
    assign o_result[9] = adder_tree5_alu_output_r_2_0_9;
    assign o_result[10] = adder_tree5_alu_output_r_2_0_10;
    assign o_result[11] = adder_tree5_alu_output_r_2_0_11;
    assign o_result[12] = adder_tree5_alu_output_r_2_0_12;
    assign o_result[13] = adder_tree5_alu_output_r_2_0_13;
    assign o_result[14] = adder_tree5_alu_output_r_2_0_14;
    assign o_result[15] = adder_tree5_alu_output_r_2_0_15;


    // exemplar begin
    // exemplar attribute FF_31 GSR ENABLED
    // exemplar attribute FF_30 GSR ENABLED
    // exemplar attribute FF_29 GSR ENABLED
    // exemplar attribute FF_28 GSR ENABLED
    // exemplar attribute FF_27 GSR ENABLED
    // exemplar attribute FF_26 GSR ENABLED
    // exemplar attribute FF_25 GSR ENABLED
    // exemplar attribute FF_24 GSR ENABLED
    // exemplar attribute FF_23 GSR ENABLED
    // exemplar attribute FF_22 GSR ENABLED
    // exemplar attribute FF_21 GSR ENABLED
    // exemplar attribute FF_20 GSR ENABLED
    // exemplar attribute FF_19 GSR ENABLED
    // exemplar attribute FF_18 GSR ENABLED
    // exemplar attribute FF_17 GSR ENABLED
    // exemplar attribute FF_16 GSR ENABLED
    // exemplar attribute FF_15 GSR ENABLED
    // exemplar attribute FF_14 GSR ENABLED
    // exemplar attribute FF_13 GSR ENABLED
    // exemplar attribute FF_12 GSR ENABLED
    // exemplar attribute FF_11 GSR ENABLED
    // exemplar attribute FF_10 GSR ENABLED
    // exemplar attribute FF_9 GSR ENABLED
    // exemplar attribute FF_8 GSR ENABLED
    // exemplar attribute FF_7 GSR ENABLED
    // exemplar attribute FF_6 GSR ENABLED
    // exemplar attribute FF_5 GSR ENABLED
    // exemplar attribute FF_4 GSR ENABLED
    // exemplar attribute FF_3 GSR ENABLED
    // exemplar attribute FF_2 GSR ENABLED
    // exemplar attribute FF_1 GSR ENABLED
    // exemplar attribute FF_0 GSR ENABLED
    // exemplar end

endmodule
