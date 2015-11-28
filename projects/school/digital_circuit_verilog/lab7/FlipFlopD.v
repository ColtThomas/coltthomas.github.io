`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:58:12 03/04/2014 
// Design Name: 
// Module Name:    OneBitRegister 
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
module FlipFlopD(
    input clk,
    input clr,
    input d,
    output reg q
    );
	always @(negedge clk)  //this is a falling edge FlipFlopD
	
	if(clr) q <=0 ;
	else q <= d;
	
endmodule
