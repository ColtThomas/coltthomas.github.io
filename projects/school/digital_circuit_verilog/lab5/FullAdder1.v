`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:59:00 02/11/2014 
// Design Name: 
// Module Name:    FullAdder1 
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
module FullAdder1(
    input  A,
    input  B,
    input  Cin,
    output  Cout,
    output  Sum

    );
	 
	 	  wire AB , AC , BC;
	xor(Sum , A , B , Cin);
	and(AB , A , B);
	and(AC , A , Cin);
	and(BC , B , Cin);
	or(Cout , AB , AC , BC);
	

endmodule
