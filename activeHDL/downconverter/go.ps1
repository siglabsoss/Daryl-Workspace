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
Compile-Verilog tb_downconverter.sv
Compile-Verilog downconverter.sv
Compile-Verilog ddc_ddsx2.sv
Compile-Verilog ddc_hb_cascade.sv
Compile-Verilog ddc_hb_decim_fir_h1.sv
Compile-Verilog ddc_hb_decim_fir_h2.sv
Compile-Verilog ddc_hb_decim_firx2_h0.sv

# Execute the Simulation
vsimsa -do dosim.do
