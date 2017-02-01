vsim -c -log sim.log +access +r -lib work tb_mimo_fifo_8
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit
