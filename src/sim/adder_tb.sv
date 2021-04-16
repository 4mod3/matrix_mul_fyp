`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2021 07:06:13 PM
// Design Name: 
// Module Name: adder_tb
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


module adder_tb;

logic [1:0] A = 2'b01;
logic [1:0] B = 2'b01;
logic [2:0] S;

c_addsub_test adder_inst (
  .A(A),  // input wire [88 : 0] A
  .B(B),  // input wire [88 : 0] B
  .S(S)  // output wire [88 : 0] S
);

endmodule
