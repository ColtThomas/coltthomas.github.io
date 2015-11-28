`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:19:34 03/17/2014 
// Design Name: 
// Module Name:    ROMs 
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
module ROMs_Combo(
    input [3:0] N,
    output CA,
    output CC,
    output CF,
    output CG,
	 output CB,
	 output CD,
	 output CE
    );

	//for the sake of simplicity, the code below is instanciated using 16x1 ROMS
	assign CA = (N==4'b0001)?1'b1:
					(N==4'b0100)?1'b1:
					(N==4'b1011)?1'b1:
					(N==4'b1101)?1'b1:
					1'b0;
	assign CC = (N==4'b0010)?1'b1:
					(N==4'b1100)?1'b1:
					(N==4'b1110)?1'b1:
					(N==4'b1111)?1'b1:
					1'b0;
	assign CF = (N==4'b0001)?1'b1:
					(N==4'b0010)?1'b1:
					(N==4'b0011)?1'b1:
					(N==4'b0111)?1'b1:
					(N==4'b1101)?1'b1:
					1'b0;
	assign CG = (N==4'b0000)?1'b1:
					(N==4'b0001)?1'b1:
					(N==4'b0111)?1'b1:
					(N==4'b1100)?1'b1:
					1'b0;
	//the code below would be the combinational logic without ROMS
	assign CB = (N==4'b0101)?1'b1:
					(N==4'b0110)?1'b1:
					(N==4'b1011)?1'b1:
					(N==4'b1100)?1'b1:
					(N==4'b1110)?1'b1:
					(N==4'b1111)?1'b1:
					1'b0;
	assign CD = (N==4'b0001)?1'b1:
					(N==4'b0100)?1'b1:
					(N==4'b0111)?1'b1:
					(N==4'b1010)?1'b1:
					(N==4'b1111)?1'b1:
					1'b0;
	assign CE = (N==4'b0001)?1'b1:
					(N==4'b0011)?1'b1:
					(N==4'b0100)?1'b1:
					(N==4'b0101)?1'b1:
					(N==4'b0111)?1'b1:
					(N==4'b1001)?1'b1:
					1'b0;
endmodule
