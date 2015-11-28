`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:43:44 03/26/2014 
// Design Name: 
// Module Name:    FF_DCE 
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
module FF_DCE(q, clk, d, clr, en); 
 input clk, clr, en, d; 
 output reg q; 
 
 always @(posedge clk) 
 if (clr) q <= 0; 
 else if (en) q <= d; 
 
endmodule
