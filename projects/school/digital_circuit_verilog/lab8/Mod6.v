`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:16:21 03/22/2014 
// Design Name: 
// Module Name:    Mod6 
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
module mod6 ( input clk, reset, inc, 
 output count10, output reg[3:0] q); 
 
 
 
 always @(posedge clk) 
 if (reset || (inc && q==5)) q <= 0; 
 else if (inc) q <= q+1; 
	
 assign count10 = inc & (q == 5); 
 
endmodule
