function Compile-Verilog
{
	param( [string]$Filename)
	vlog -work work -sv2k12 -dbg $Filename

	if ($LastExitCode -ne 0) {
		echo "                                                                "
		echo "    ############################################################"
		$msg = "      Compilation of " + $Filename + " failed! "
		echo $msg
		echo "    ############################################################"
		echo "                                                                "
		exit
	}
}

# Create the Work Library
vlib work

# Compile the Verilog Files
Compile-Verilog tb_sparse_mult_by_A.sv
Compile-Verilog sparse_mult_by_A.sv

# Execute the Simulation
vsimsa -do dosim.do
