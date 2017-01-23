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
Compile-SystemVerilog tb_adder_trees.sv
Compile-SystemVerilog adder_trees.sv
Compile-Verilog adder_tree3.v
Compile-Verilog adder_tree5.v

$primitives = @(
	"GSR",
	"PUR",
	"ALU54B",
	"MULT18X18D",
	"VHI",
	"VLO",
	"FD1P3IX",
	"UDFDL5SC_UDP_X")

foreach ($primitive in $primitives)
{
	Compile-Verilog-Primitive $primitive
}

# Compile-Verilog-Primitive GSR
# Compile-Verilog-Primitive PUR
# Compile-Verilog-Primitive ALU54B
# Compile-Verilog-Primitive MULT18X18D
# Compile-Verilog-Primitive VHI
# Compile-Verilog-Primitive VLO

# Execute the Simulation
vsimsa -do dosim.do
