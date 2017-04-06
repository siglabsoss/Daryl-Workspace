# Build the Synplify project
project -new test.prj

# Device Options
set_option -technology ECP5U
set_option -part LFE5U_85F
set_option -package BG756C
set_option -speed_grade -8

# Compilation / Mapping Options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true
set_option -vlog_std v2001
set_option -frequency auto
set_option -maxfan 1000
set_option -auto_constrain_io 0
set_option -disable_io_insertion false
set_option -retiming false; set_option -pipe true
set_option -force_gsr false
set_option -compiler_compatible 0
set_option -dup false

set_option -default_enum_encoding default
set_option -write_apr_constraint 1

set synthesis_files [list
    ../hdl/top_level.sv
    ../hdl/test1.sv
    ../hdl/test2.v
]

set constraint_files [list
    ../constraints/test.sdc
]

set ip_files [list
    ../ip/testmem.sbx
]

for synfile synthesis_files {
    add_file $file
}

for cfile constraint_files {
    add_file $cfile
}

for ipfile ip_files {
    add_file $ipfile
}

project -save
