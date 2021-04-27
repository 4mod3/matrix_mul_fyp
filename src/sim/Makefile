#
# Makefile
# gins, 2021-04-27 10:09
#
VIVADO_DIR = /home/gins/fpga/vivado_lib/2020.1/data/verilog/src
VIVADO_LIB = -y$(VIVADO_DIR) -y$(VIVADO_DIR)/retarget -y$(VIVADO_DIR)/unifast -y$(VIVADO_DIR)/unimacro -y$(VIVADO_DIR)/unisims -y$(VIVADO_DIR)/xeclib

SRC = ./mul_tb_beh.sv ../design/MAC_pipeline_beh.sv ../design/CLZ.sv

display: wave.vcd
	gtkwave wave.vcd

wave.vcd : mul_tb
	vvp ./mul_tb

mul_tb: $(SRC) 
	iverilog -g2012 -o mul_tb $(SRC)	

clean:
	rm -f wave.vcd mul_tb

# vim:ft=make
#
