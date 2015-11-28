`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:50:19 04/08/2014 
// Design Name: 
// Module Name:    Last_Register 
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
module Last_Register(
    output reg[15:0] Q,
    input [15:0] D,
    input EN,
    input Clk,
    input Reset
    );

always@(posedge Clk)
if (EN) Q <= D;
else if (Reset) Q <= 16'h9999;

endmodule