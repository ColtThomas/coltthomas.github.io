`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:06:42 03/04/2014 
// Design Name: 
// Module Name:    mux16to4 
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
module mux16to4(RegFile_out , Adrr , Reg_3 ,Reg_2 ,Reg_1 ,Reg_0 );
	parameter WID = 4;
    input [WID-1:0] Reg_3;
    input [WID-1:0] Reg_2;
    input [WID-1:0] Reg_1;
    input [WID-1:0] Reg_0;
    input [1:0] Adrr;
    output [WID-1:0] RegFile_out;

	assign RegFile_out = 	(Adrr==2'b00)?Reg_3:
									(Adrr==2'b01)?Reg_2:
									(Adrr==2'b10)?Reg_1:
									Reg_0;
	
endmodule
