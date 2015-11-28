`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:55:12 02/11/2014 
// Design Name: 
// Module Name:    OtherLogic 
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
module OtherLogic(A,B,AandB,Anot,Apass);
    input  A;
    input  B;
    output  AandB;
    output  Anot;
	 output Apass;
    

	and(AandB , A , B);
	not(Anot , A);
	not(Apass , Anot);
endmodule
