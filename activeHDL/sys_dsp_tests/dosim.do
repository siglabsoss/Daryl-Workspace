vsim -c -log sim.log +access +r -lib work tb_sys_dsp_tests
trace -rec *
run -all
asdb2vcd wave.asdb wave.vcd
exit