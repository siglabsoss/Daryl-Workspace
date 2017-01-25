function Compile-Verilog
{
	param( [string]$Filename )
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

function Compile-Verilog-Primitive
{
	param( [string]$Primitive )
	$diamond = "C:\lscc"
	$subdir = "diamond\3.8_x64\cae_library\simulation\verilog\ecp5u"
	$srcname = $diamond + "\" + $subdir + "\" + $primitive + ".v"
	Compile-Verilog $srcname
}

# Create the Work Library
vlib work

# Compile the Verilog Files
Compile-Verilog tb_sys_dsp_tests.sv
Compile-Verilog sys_dsp_tests.sv

Compile-Verilog-Primitive GSR
Compile-Verilog-Primitive PUR
Compile-Verilog-Primitive PRADD18A

# Execute the Simulation
vsimsa -do dosim.do
#vsim -do dosim.do