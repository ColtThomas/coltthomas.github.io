`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:42:21 04/08/2014 
// Design Name: 
// Module Name:    Best_Register 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Best_Register(
    output reg[15:0] Q,
    input [15:0] D,
    input EN,
    input Clk,
    input Reset
    );

always@(posedge Clk)
if (Reset) Q <= 16'h9999;
else if (EN) Q <= D;


endmodule
