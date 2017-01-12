function Compile-Verilog
{
	param( [string]$Filename)
	vlog -work work -sv2k12 -dbg $Filename

	if ($LastExitCode -ne 0) {
		echo "                                                                "
		echo "            ####################################################"
		echo "             Compilation of tb_dual_diagonal_backsub.sv failed! "
		echo "            ####################################################"
		echo "                                                                "
		exit
	}
}

# Create the Work Library
vlib work

# Compile the Verilog Files
Compile-Verilog tb_dual_diagonal_backsub.sv
Compile-Verilog dual_diagonal_backsub_with_backpressure.sv

# Execute the Simulation
vsimsa -do dosim.do
