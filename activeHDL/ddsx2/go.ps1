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

function Compile-Verilog-PMI
{
	Compile-Verilog C:\lscc\diamond\3.8_x64\cae_library\simulation\verilog\pmi\pmi_ram_dp_true.v
	Compile-Verilog C:\lscc\diamond\3.8_x64\cae_library\simulation\verilog\ecp5u\GSR.v
	Compile-Verilog C:\lscc\diamond\3.8_x64\cae_library\simulation\verilog\ecp5u\PUR.v
}

# Create the Work Library
vlib work

# Compile the Verilog Files
Compile-Verilog tb_ddsx2.sv
Compile-Verilog ddsx2.sv
Compile-Verilog-PMI

# Execute the Simulation
vsimsa -do dosim.do
