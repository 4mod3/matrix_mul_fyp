`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 07:24:13 PM
// Design Name: 
// Module Name: clt_tb
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


module clt_tb;

logic [63:0] in = 64'h02ffffffffffffff;
logic [5:0] out;

CLZ clz_instant(
    .in(in),
    .out(out)
);

initial begin
    # 100;
    $stop;
end


endmodule
