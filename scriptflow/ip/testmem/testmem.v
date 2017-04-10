/* synthesis translate_off*/
`define SBP_SIMULATION
/* synthesis translate_on*/
`ifndef SBP_SIMULATION
`define SBP_SYNTHESIS
`endif

//
// Verific Verilog Description of module testmem
//
module testmem (testmem1_Data, testmem1_Q, testmem1_RdAddress, testmem1_WrAddress, 
            testmem1_RdClock, testmem1_RdClockEn, testmem1_Reset, testmem1_WE, 
            testmem1_WrClock, testmem1_WrClockEn) /* synthesis sbp_module=true */ ;
    input [35:0]testmem1_Data;
    output [35:0]testmem1_Q;
    input [8:0]testmem1_RdAddress;
    input [8:0]testmem1_WrAddress;
    input testmem1_RdClock;
    input testmem1_RdClockEn;
    input testmem1_Reset;
    input testmem1_WE;
    input testmem1_WrClock;
    input testmem1_WrClockEn;
    
    
    testmem1 testmem1_inst (.Data({testmem1_Data}), .Q({testmem1_Q}), .RdAddress({testmem1_RdAddress}), 
            .WrAddress({testmem1_WrAddress}), .RdClock(testmem1_RdClock), 
            .RdClockEn(testmem1_RdClockEn), .Reset(testmem1_Reset), .WE(testmem1_WE), 
            .WrClock(testmem1_WrClock), .WrClockEn(testmem1_WrClockEn));
    
endmodule

