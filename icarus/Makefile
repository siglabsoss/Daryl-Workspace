SIM=iverilog
HDL_DIR=hdl
BUILD_DIR=sim
LIB_DIR=/usr/local/diamond/3.8_x64/cae_library/simulation/verilog/ecp5u
OPTS=-g2012

test: $(HDL_DIR)/test.sv
	$(SIM) $< $(LIB_DIR)/LUT4.v $(LIB_DIR)/lut_mux4.v $(OPTS) -o $(BUILD_DIR)/$@ -s $@

clean:
	@rm -f $(BUILD_DIR)/test
