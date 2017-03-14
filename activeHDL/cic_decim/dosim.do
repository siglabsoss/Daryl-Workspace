vsim -c -log sim.log +access +r -lib work tb_cic_decim
trace i_inph_data
trace i_quad_data
trace i_valid
trace -rec uut2/*
run -all
# asdb2vcd wave.asdb wave.vcd
exit
