setenv SIM_WORKING_FOLDER .
set newDesign 0
if {![file exists "Z:/Daryl-Workspace/lattice/test1/ahdl_test/ahdl_test.adf"]} { 
	design create ahdl_test "Z:/Daryl-Workspace/lattice/test1"
  set newDesign 1
}
design open "Z:/Daryl-Workspace/lattice/test1/ahdl_test"
cd "Z:/Daryl-Workspace/lattice/test1"
designverincludedir -clear
designverlibrarysim -PL -clear
designverlibrarysim -L -clear
designverlibrarysim -PL pmi_work
designverlibrarysim ovi_ecp5um
designverdefinemacro -clear
if {$newDesign == 0} { 
  removefile -Y -D *
}
addfile "Z:/Daryl-Workspace/lattice/test1/impl1/source/skid.v"
vlib "Z:/Daryl-Workspace/lattice/test1/ahdl_test/work"
set worklib work
adel -all
vlog -dbg -work work "Z:/Daryl-Workspace/lattice/test1/impl1/source/skid.v"
vsim  +access +r    -PL pmi_work -L ovi_ecp5um
add wave *
run 1000ns
