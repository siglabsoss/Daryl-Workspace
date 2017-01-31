vsim -c -log sim.log +access +r -lib work tb_ldpc_minsigner
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit
