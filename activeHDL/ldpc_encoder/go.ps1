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
Compile-Verilog tb_ldpc_encoder.sv
Compile-Verilog ldpc_encoder.sv
Compile-Verilog ldpc_adder_gf2/ldpc_adder_gf2.sv
Compile-Verilog ldpc_adder_gf2/ldpc_adder_gf2_skid.sv
Compile-Verilog ldpc_concatenator/ldpc_concatenator.sv
Compile-Verilog ldpc_concatenator/ldpc_concatenator_ebr_fifo.sv
Compile-Verilog ldpc_delay_fifo/ldpc_delay_fifo.sv
Compile-Verilog ldpc_dual_diagonal_backsub/ldpc_dual_diagonal_backsub.sv
Compile-Verilog ldpc_sparse_mult/ldpc_sparse_mult_by_A.sv
Compile-Verilog ldpc_sparse_mult/ldpc_sparse_mult_by_B.sv
Compile-Verilog ldpc_sparse_mult/ldpc_sparse_mult_by_C.sv
Compile-Verilog ldpc_sparse_mult/ldpc_sparse_mult_by_E.sv

# Execute the Simulation
vsimsa -do dosim.do
