vsim -c -log sim.log +access +r -lib work tb_cic_decim
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit
