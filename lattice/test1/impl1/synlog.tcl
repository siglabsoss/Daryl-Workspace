source "C:/Users/user/AppData/Local/Synplicity/scm_perforce.tcl"
history clear
run_tcl -fg //SIGLABSMACHINE/shared/Daryl-Workspace/lattice/test1/impl1/launch_synplify.tcl
project -run synthesis_check //SIGLABSMACHINE/shared/Daryl-Workspace/lattice/test1/impl1/source/skid.sv
project -run synthesis -clean 
project -close //SIGLABSMACHINE/shared/Daryl-Workspace/lattice/test1/impl1/impl1_syn.prj
