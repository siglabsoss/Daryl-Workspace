vsim -c -log sim.log +access +r -lib work tb_concatenator
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit
