`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:18:28 02/25/2014 
// Design Name: 
// Module Name:    flipflopD 
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
module flipflopD(
    input d,
    input clk,
    input clr,
    output reg q
    );
	 
	 always @(posedge clk)
		if (clr) q <= 0;
		else q <= d;


endmodule
