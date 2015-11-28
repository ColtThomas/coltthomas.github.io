`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:34:55 03/11/2014 
// Design Name: 
// Module Name:    FF_DC 
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
module FF_DC(
     q,
     clk,
     clr,
     d
    );
	input clk, clr, d;
	output reg q;

	always @(posedge clk)
		if (clr) q <= 0;
		else q <= d;

endmodule
