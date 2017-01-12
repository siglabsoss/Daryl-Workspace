vsim -c -log sim.log +access +r -lib work tb_dual_diagonal_backsub
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit