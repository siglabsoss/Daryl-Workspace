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
Compile-Verilog tb_fixed_ddsx2.sv
Compile-Verilog fixed_ddsx2.sv

# Clean up the output before processing next run
Remove-Item outvec.txt -ErrorAction SilentlyContinue

# Execute the Simulation
vsimsa -do dosim.do

# Run Python data analysis on output
python .\python\test_data.py