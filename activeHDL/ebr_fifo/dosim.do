vsim -c -log sim.log +access +r -lib work tb_ebr_fifo
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit
