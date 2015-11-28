`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:00:59 02/11/2014 
// Design Name: 
// Module Name:    ALU4bit 
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
module ALU4bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input [1:0] Ctrl,
    output [3:0] R,
    output Cout 
	 );
	 
	 
	 wire Cy0 ,Cy1 , Cy2 ;
ALU ALU1(A[0],B[0],Cin ,Ctrl, Cy0 , R[0]);
ALU ALU2(A[1],B[1],Cy0 ,Ctrl, Cy1 , R[1]);
ALU ALU3(A[2],B[2],Cy1 ,Ctrl, Cy2 , R[2]);
ALU ALU4(A[3],B[3],Cy2 ,Ctrl, Cout , R[3]);

endmodule
