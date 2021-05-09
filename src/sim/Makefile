#
# Makefile
# gins, 2021-04-27 10:09
#


# VIVADO_DIR = /home/gins/fpga/vivado_lib/2020.1/data/verilog/src
# VIVADO_LIB = -y$(VIVADO_DIR) -y$(VIVADO_DIR)/retarget -y$(VIVADO_DIR)/unifast -y$(VIVADO_DIR)/unimacro -y$(VIVADO_DIR)/unisims -y$(VIVADO_DIR)/xeclib

MEM_SRC := $(wildcard ../../ip/*)
MAC_SRC := ./mul_tb_beh.sv ../design/MAC_pipeline_beh.sv ../design/CLZ.sv
LOAD_SRC := ./load_tb.sv ../design/load_AB.sv $(MEM_SRC)
CONTROL_SRC := ./control_C_tb.sv ../design/control_C.sv ../../ip/sdp_sram.v
TOP_SRC := ./top_tb.sv $(wildcard ../design/*.sv) $(MEM_SRC)
TOP_SRC := $(filter-out ../design/MAC_pipeline.sv ../design/load_valid_control.sv, $(TOP_SRC))
BUILD_DIR := ./build

#---------------------------------------------------
# top behavioral sim
top: top_wave.vcd
	gtkwave $(BUILD_DIR)/top_wave.vcd

top_wave.vcd: top_tb.out
	vvp $(BUILD_DIR)/top_tb.out

top_tb.out: $(TOP_SRC)
	iverilog -g2012 -o $(BUILD_DIR)/top_tb.out $(TOP_SRC)

#---------------------------------------------------
# control C behavioral sim
control: control_C_wave.vcd
	gtkwave $(BUILD_DIR)/control_C_wave.vcd

control_C_wave.vcd: control_C_tb.out
	vvp $(BUILD_DIR)/control_C_tb.out

control_C_tb.out: $(CONTROL_SRC)
	iverilog -g2012 -o $(BUILD_DIR)/control_C_tb.out $(CONTROL_SRC)

#---------------------------------------------------
# load_AB behavioral sim
load: load_wave.vcd
	gtkwave $(BUILD_DIR)/load_wave.vcd

load_wave.vcd: load_tb.out
	vvp $(BUILD_DIR)/load_tb.out

load_tb.out: $(LOAD_SRC)
	iverilog -g2012 -o $(BUILD_DIR)/load_tb.out $(LOAD_SRC)

#---------------------------------------------------
# MAC_pipeline behavioral sim
mac: mac_wave.vcd
	gtkwave $(BUILD_DIR)/mac_wave.vcd

mac_wave.vcd: mul_tb.out
	vvp $(BUILD_DIR)/mul_tb.out

mul_tb.out: $(MAC_SRC)
	iverilog -g2012 -o $(BUILD_DIR)/mul_tb.out $(MAC_SRC)	

#---------------------------------------------------
clean:
	rm -f $(BUILD_DIR)/*

# vim:ft=make
#
