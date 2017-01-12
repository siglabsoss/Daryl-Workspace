vsim -c -log sim.log +access +r -lib work tb_skid
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit