vsim -c -log sim.log +access +r -lib work tb_hb_decim_fir
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit
