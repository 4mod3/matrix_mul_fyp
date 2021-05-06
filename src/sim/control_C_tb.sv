`timescale 1ns / 1ps

module control_C_tb;

reg clk;
reg rst;
parameter CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk = ~clk;

logic load_pos_bit_in;
logic store_pos_bit_in;
logic [63:0] wr_data_in;
logic [63:0] rd_data_out;
logic [31:0] N_in;

// res_out res_out_ports(clk);

// Si=8, P=2, Sj=8
control_C #(
    64,1,2
) control_C_inst (
    .clk, .rst, .load_pos_bit_in, .store_pos_bit_in, .wr_data_in, .rd_data_out, .N_in,
    .res_clk(clk)
);

initial begin
    $dumpfile("./build/control_C_wave.vcd");
    $dumpvars(0,control_C_tb);
end
integer j;
initial begin
    clk = 0; rst = 1; #10;
    rst = 0; N_in = 32'd2; 
    store_pos_bit_in = 1'b0;
    load_pos_bit_in = 1'b0;
    #10;
    
    for(j=0; j<64; j++)begin
        if(j == 4)begin
            load_pos_bit_in = 0;
            store_pos_bit_in = 0;
        end else begin
            load_pos_bit_in = 1'b1;
            if(j > 0)begin
                store_pos_bit_in = 1'b1;
                wr_data_in = j;
            end
        end        
        #10;
    end
    store_pos_bit_in = 1'b1;
    wr_data_in = j;
    #30;$finish;
end

endmodule