function Compile-Verilog
{
	param( [string]$Filename)
	vlog -work work -dbg $Filename

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

function Compile-SystemVerilog
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

function Compile-Verilog-Primitive
{
	param( [string]$Primitive)
	$Filename = "C:\lscc\diamond\3.8_x64\cae_library\simulation\verilog\ecp5u"
	$Filename += "\" + $Primitive + ".v"
	Compile-Verilog $Filename
}

# Create the Work Library
vlib work

# Compile the Verilog Files
$sv_files = @(
	"tb_adder_trees.sv",
	"adder_trees.sv",
	"swapper.sv")

$v_files = @(
	"adder_tree3.v",
	"adder_tree5.v")

$primitives = @(
	"GSR", "PUR", "ALU54B", "MULT18X18D",
	"VHI", "VLO", "FD1P3IX", "UDFDL5SC_UDP_X")

foreach ($sv_file in $sv_files)
{
	Compile-SystemVerilog $sv_file
}

foreach ($v_file in $v_files)
{
	Compile-Verilog $v_file
}

foreach ($primitive in $primitives)
{
	Compile-Verilog-Primitive $primitive
}

# Execute the Simulation
vsimsa -do dosim.do
