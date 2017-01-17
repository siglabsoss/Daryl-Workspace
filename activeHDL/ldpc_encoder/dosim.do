vsim -c -log sim.log +access +r -lib work tb_ldpc_encoder
trace /tb_ldpc_encoder/*
trace /tb_ldpc_encoder/uut/concatenator_inst/*
trace /tb_ldpc_encoder/uut/concatenator_inst/concatenator_ebr_fifo_1_inst/*
run -all
asdb2vcd wave.asdb wave.vcd
exit
