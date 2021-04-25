`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2021 03:29:41 PM
// Design Name: 
// Module Name: mul_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mul_tb;

parameter clk_period = 10;  
reg clk;  
logic valid_in = 1'b1;
logic [63:0] TA_in = 64'h4025000000000000;
logic [63:0] TB_in = 64'h4003800000000000;
logic [63:0] TC = 64'h4003800000000000; //1.5

logic [63:0] res_out;
bit store_valid;
bit load_valid;
logic error_flag;

MAC_pipeline mac_tb(
    .clk(clk),
    .valid_in(valid_in),
    .C_in(TC),
    .TA_in(TA_in),
    .TB_in(TB_in),
    .res_out(res_out),
    .error_flag(error_flag),
    .load_valid(load_valid),
    .store_valid(store_valid)
);
logic [10:0] temp;
assign temp = TA_in[62 -: 11] + TB_in[62 -: 11];

initial begin
    clk = 0; 
    # 10;
    TA_in = '0;
    TB_in = '0;
    valid_in = 0;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    # 10;
    $stop;
end


always #(clk_period/2) clk = ~clk;

endmodule
