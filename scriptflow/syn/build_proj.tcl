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

set verilog_files [list \
    [ file normalize "../hdl/top_level.sv" ] \
    [ file normalize "../hdl/test1.sv" ] \
    [ file normalize "../hdl/test2.v" ] \
]

set sysverilog_files [list \
    [ file normalize "../hdl/top_level.sv" ] \
    [ file normalize "../hdl/test1.sv" ] \
]

set constraint_files [list \
    [ file normalize "../constraints/test.sdc"] \
]

set ip_files [list \
    [ file normalize "../ip/testmem.sbx" ] \
]

foreach synfile $verilog_files {
    add_file -verilog "$synfile"
}

foreach synfile $sysverilog_files {
    add_file -verilog -vlog_std sysv "$synfile"
}

foreach cfile $constraint_files {
    add_file -constraint "$cfile"
}

# foreach ipfile [lindex ip_files] {
#     add_file -verilog "$ipfile"
# }

project -save
