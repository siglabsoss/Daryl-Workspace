/* Verilog netlist generated by SCUBA Diamond (64-bit) 3.8.0.115.3 */
/* Module Version: 6.5 */
/* C:\lscc\diamond\3.8_x64\ispfpga\bin\nt64\scuba.exe -w -n testmem1 -lang verilog -synth synplify -bus_exp 7 -bb -arch sa5p00 -type bram -wp 10 -rp 0011 -rdata_width 36 -data_width 36 -num_rows 512 -outdata REGISTERED -cascade -1 -resetmode SYNC -sync_reset -mem_init0 -fdc Z:/ClarityDesignerProjects/testmem/testmem1/testmem1.fdc  */
/* Thu Apr 06 15:23:23 2017 */


`timescale 1 ns / 1 ps
module testmem1 (WrAddress, RdAddress, Data, WE, RdClock, RdClockEn, 
    Reset, WrClock, WrClockEn, Q)/* synthesis NGD_DRC_MASK=1 */;
    input wire [8:0] WrAddress;
    input wire [8:0] RdAddress;
    input wire [35:0] Data;
    input wire WE;
    input wire RdClock;
    input wire RdClockEn;
    input wire Reset;
    input wire WrClock;
    input wire WrClockEn;
    output wire [35:0] Q;

    wire scuba_vhi;
    wire scuba_vlo;

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    defparam testmem1_0_0_0.INIT_DATA = "STATIC" ;
    defparam testmem1_0_0_0.ASYNC_RESET_RELEASE = "SYNC" ;
    defparam testmem1_0_0_0.INITVAL_3F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_3E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_3D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_3C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_3B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_3A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_39 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_38 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_37 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_36 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_35 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_34 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_33 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_32 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_31 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_30 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_2F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_2E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_2D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_2C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_2B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_2A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_29 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_28 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_27 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_26 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_25 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_24 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_23 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_22 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_21 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_20 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_1F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_1E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_1D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_1C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_1B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_1A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_19 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_18 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_17 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_16 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_15 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_14 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_13 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_12 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_11 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_10 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_0F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_0E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_0D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_0C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_0B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_0A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_09 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_08 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_07 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_06 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_05 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_04 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_03 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_02 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_01 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.INITVAL_00 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000" ;
    defparam testmem1_0_0_0.CSDECODE_R = "0b000" ;
    defparam testmem1_0_0_0.CSDECODE_W = "0b001" ;
    defparam testmem1_0_0_0.GSR = "ENABLED" ;
    defparam testmem1_0_0_0.RESETMODE = "SYNC" ;
    defparam testmem1_0_0_0.REGMODE = "OUTREG" ;
    defparam testmem1_0_0_0.DATA_WIDTH_R = 36 ;
    defparam testmem1_0_0_0.DATA_WIDTH_W = 36 ;
    PDPW16KD testmem1_0_0_0 (.DI35(Data[35]), .DI34(Data[34]), .DI33(Data[33]), 
        .DI32(Data[32]), .DI31(Data[31]), .DI30(Data[30]), .DI29(Data[29]), 
        .DI28(Data[28]), .DI27(Data[27]), .DI26(Data[26]), .DI25(Data[25]), 
        .DI24(Data[24]), .DI23(Data[23]), .DI22(Data[22]), .DI21(Data[21]), 
        .DI20(Data[20]), .DI19(Data[19]), .DI18(Data[18]), .DI17(Data[17]), 
        .DI16(Data[16]), .DI15(Data[15]), .DI14(Data[14]), .DI13(Data[13]), 
        .DI12(Data[12]), .DI11(Data[11]), .DI10(Data[10]), .DI9(Data[9]), 
        .DI8(Data[8]), .DI7(Data[7]), .DI6(Data[6]), .DI5(Data[5]), .DI4(Data[4]), 
        .DI3(Data[3]), .DI2(Data[2]), .DI1(Data[1]), .DI0(Data[0]), .ADW8(WrAddress[8]), 
        .ADW7(WrAddress[7]), .ADW6(WrAddress[6]), .ADW5(WrAddress[5]), .ADW4(WrAddress[4]), 
        .ADW3(WrAddress[3]), .ADW2(WrAddress[2]), .ADW1(WrAddress[1]), .ADW0(WrAddress[0]), 
        .BE3(scuba_vhi), .BE2(scuba_vhi), .BE1(scuba_vhi), .BE0(scuba_vhi), 
        .CEW(WrClockEn), .CLKW(WrClock), .CSW2(scuba_vlo), .CSW1(scuba_vlo), 
        .CSW0(WE), .ADR13(RdAddress[8]), .ADR12(RdAddress[7]), .ADR11(RdAddress[6]), 
        .ADR10(RdAddress[5]), .ADR9(RdAddress[4]), .ADR8(RdAddress[3]), 
        .ADR7(RdAddress[2]), .ADR6(RdAddress[1]), .ADR5(RdAddress[0]), .ADR4(scuba_vlo), 
        .ADR3(scuba_vlo), .ADR2(scuba_vlo), .ADR1(scuba_vlo), .ADR0(scuba_vlo), 
        .CER(RdClockEn), .OCER(RdClockEn), .CLKR(RdClock), .CSR2(scuba_vlo), 
        .CSR1(scuba_vlo), .CSR0(scuba_vlo), .RST(Reset), .DO35(Q[17]), .DO34(Q[16]), 
        .DO33(Q[15]), .DO32(Q[14]), .DO31(Q[13]), .DO30(Q[12]), .DO29(Q[11]), 
        .DO28(Q[10]), .DO27(Q[9]), .DO26(Q[8]), .DO25(Q[7]), .DO24(Q[6]), 
        .DO23(Q[5]), .DO22(Q[4]), .DO21(Q[3]), .DO20(Q[2]), .DO19(Q[1]), 
        .DO18(Q[0]), .DO17(Q[35]), .DO16(Q[34]), .DO15(Q[33]), .DO14(Q[32]), 
        .DO13(Q[31]), .DO12(Q[30]), .DO11(Q[29]), .DO10(Q[28]), .DO9(Q[27]), 
        .DO8(Q[26]), .DO7(Q[25]), .DO6(Q[24]), .DO5(Q[23]), .DO4(Q[22]), 
        .DO3(Q[21]), .DO2(Q[20]), .DO1(Q[19]), .DO0(Q[18]))
             /* synthesis MEM_LPC_FILE="testmem1.lpc" */
             /* synthesis MEM_INIT_FILE="INIT_ALL_0s" */;



    // exemplar begin
    // exemplar attribute testmem1_0_0_0 MEM_LPC_FILE testmem1.lpc
    // exemplar attribute testmem1_0_0_0 MEM_INIT_FILE INIT_ALL_0s
    // exemplar end

endmodule
