vsim -c -log sim.log +access +r -lib work tb_adder_trees
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit
