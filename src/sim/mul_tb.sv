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
logic [63:0] TA_in = 64'hBFFA000000000000;
logic [63:0] TB_in = 64'h4004CCCCCCCCCCCD;
logic [89:0] MAB_mul_res_signed = '0;
logic error_flag;

MAC_pipeline mac_tb(
    .clk(clk),
    .TA_in(TA_in),
    .TB_in(TB_in),
    .MAB_mul_res_signed(MAB_mul_res_signed),
    .error_flag(error_flag)
);

initial begin
    clk = 0; 
    # 100;
    $stop;
end


always #(clk_period/2) clk = ~clk;

endmodule
