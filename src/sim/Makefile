#
# Makefile
# gins, 2021-04-27 10:09
#


# VIVADO_DIR = /home/gins/fpga/vivado_lib/2020.1/data/verilog/src
# VIVADO_LIB = -y$(VIVADO_DIR) -y$(VIVADO_DIR)/retarget -y$(VIVADO_DIR)/unifast -y$(VIVADO_DIR)/unimacro -y$(VIVADO_DIR)/unisims -y$(VIVADO_DIR)/xeclib

MAC_SRC = ./mul_tb_beh.sv ../design/MAC_pipeline_beh.sv ../design/CLZ.sv
LOAD_SRC = ./load_tb.sv ../design/load_AB.sv ../../ip/sdp_sram.v ../../ip/sync_fifo.sv
CONTROL_SRC = ./control_C_tb.sv ../design/control_C.sv ../../ip/sdp_sram.v
# BUILD_DIR = ./build

#---------------------------------------------------
# control C behavioral sim
control: control_C_wave.vcd
	gtkwave ./control_C_wave.vcd

control_C_wave.vcd: control_C_tb.out
	vvp ./control_C_tb.out

control_C_tb.out: $(CONTROL_SRC)
	iverilog -g2012 -o ./control_C_tb.out $(CONTROL_SRC)

#---------------------------------------------------
# load_AB behavioral sim
load: load_wave.vcd
	gtkwave load_wave.vcd

load_wave.vcd: load_tb.out
	vvp ./load_tb.out

load_tb.out: $(LOAD_SRC)
	iverilog -g2012 -o ./load_tb.out $(LOAD_SRC)

#---------------------------------------------------
# MAC_pipeline behavioral sim
mac: mac_wave.vcd
	gtkwave mac_wave.vcd

mac_wave.vcd: mul_tb.out
	vvp ./mul_tb.out

mul_tb.out: $(MAC_SRC)
	iverilog -g2012 -o ./mul_tb.out $(MAC_SRC)	

#---------------------------------------------------
clean:
	rm -f mac_wave.vcd mul_tb.out load_tb.out load_wave.vcd control_C_tb.out control_C_wave.vcd

# vim:ft=make
#
