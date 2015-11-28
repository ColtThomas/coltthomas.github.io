`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:05:59 03/04/2014 
// Design Name: 
// Module Name:    RegisterOneBit 
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
module RegisterOneBit(
    input Din,
    input Write,
    input Clk,
    input Clr,
    output Dout
    );
	 wire D_0;
	 
	mux21 mx_1(Dout , Din, Write , D_0);
	FlipFlopD fl_d(Clk, Clr, D_0 , Dout);
	

endmodule
