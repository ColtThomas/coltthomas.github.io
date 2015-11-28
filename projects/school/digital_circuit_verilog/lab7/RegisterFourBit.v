`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:05:51 03/04/2014 
// Design Name: 
// Module Name:    RegisterFourBit 
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
module RegisterFourBit(
    input [3:0] Din,
    input Write,
    input Clr,
    input Clk,
    output [3:0] Dout
    );

	RegisterOneBit R0(Din[0], Write, Clk, Clr, Dout[0]); 
	RegisterOneBit R1(Din[1], Write, Clk, Clr, Dout[1]);
	RegisterOneBit R2(Din[2], Write, Clk, Clr, Dout[2]);
	RegisterOneBit R3(Din[3], Write, Clk, Clr, Dout[3]);
endmodule
