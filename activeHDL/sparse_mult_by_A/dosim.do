vsim -c -log sim.log +access +r -lib work tb_sparse_mult_by_A
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit
