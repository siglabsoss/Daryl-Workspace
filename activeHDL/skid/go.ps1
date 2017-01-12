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
Compile-Verilog tb_skid.sv
Compile-Verilog skid.sv

# Execute the Simulation
vsimsa -do dosim.do
