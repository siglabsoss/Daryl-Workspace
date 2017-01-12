function Compile-Verilog
{
	param( [string]$Filename)
	vlog -work work -sv2k12 -dbg $Filename

	if ($LastExitCode -ne 0) {
		echo "                                                                "
		echo "    ############################################################"
		echo "      Compilation of " + $Filename + " failed! "
		echo "    ############################################################"
		echo "                                                                "
		exit
	}
}

# Create the Work Library
vlib work

# Compile the Verilog Files
Compile-Verilog tb_adder_gf2.sv
Compile-Verilog adder_gf2.sv
Compile-Verilog adder_gf2.sv

# Execute the Simulation
vsimsa -do dosim.do
