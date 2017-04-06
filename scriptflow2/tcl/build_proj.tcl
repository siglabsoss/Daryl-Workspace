# Build the Synplify project
project -new ./test.prj

# set synthesis_files [list
#     top_level.sv
#     test1.sv
#     test2.sv
#     test.sdc
# ]

# for synfile synthesis_files {
#     add_file $file
# }

# set_option -technology {{ ECP5G }}
# set_option -part {{ PART NUMBER }}
# set_option -package {{ PACKAGE }}

project -save
