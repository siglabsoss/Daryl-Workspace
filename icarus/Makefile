SIM=iverilog
HDL_DIR=hdl
TEST_DIR=test
BUILD_DIR=icsim
LIB_DIR=/usr/local/diamond/3.8_x64/cae_library/simulation/verilog/ecp5u
OPTS=-g2012 -DSIMULATION

all: test tb_skid

test: $(HDL_DIR)/test.sv
	$(SIM) $(LIB_DIR)/LUT4.v $(LIB_DIR)/lut_mux4.v $(OPTS) -o $(BUILD_DIR)/$@ -s $@ $<

tb_skid: $(TEST_DIR)/tb_skid.sv $(HDL_DIR)/skid.sv
	$(SIM) $(OPTS) -o $(BUILD_DIR)/$@ -s $@ $(TEST_DIR)/tb_skid.sv $(HDL_DIR)/skid.sv

clean:
	@rm -f $(BUILD_DIR)/test
	@rm -f $(BUILD_DIR)/tb_skid
	@rm -f *.vcd *.lxt2
