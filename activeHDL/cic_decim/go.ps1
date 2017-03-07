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
Compile-Verilog tb_cic_decim.sv
Compile-Verilog cic_decim.sv
Compile-Verilog cic_integrator.sv
Compile-Verilog cic_comb.sv

# Remove output files
del /Q test3.txt
del /Q test4.txt

# Execute the Simulation
vsimsa -do dosim.do