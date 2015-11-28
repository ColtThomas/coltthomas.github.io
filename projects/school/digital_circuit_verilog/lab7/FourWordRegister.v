`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:11:53 03/04/2014 
// Design Name: 
// Module Name:    FourWordRegister 
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
module FourWordRegister(
    input [3:0] Din,
    input Write,
    input [1:0] Adrr,
    input Clk,
	 input Clr,
    output [15:0] Dout
    );
		wire[3:0] reg_3 , reg_2 , reg_1 , reg_0 , Sel;
		wire write_3 , write_2 , write_1 , write_0;
		wire [15:0] To_Out;
		
		//this is our decoder which selects which 4-bit reg to write to
		Decoder24 Decode(Adrr , Sel);
		
		//this is the logic to select the write operation
		and(write_3 , Sel[3] , Write);
		and(write_2 , Sel[2] , Write);
		and(write_1 , Sel[1] , Write);
		and(write_0 , Sel[0] , Write);
		
		//these are the 4-bit registers
		RegisterFourBit Reg3(Din, write_3, Clr, Clk, reg_3);
		RegisterFourBit Reg2(Din, write_2, Clr, Clk, reg_2);
		RegisterFourBit Reg1(Din, write_1, Clr, Clk, reg_1);
		RegisterFourBit Reg0(Din, write_0, Clr, Clk, reg_0);
		
		//we concatenate the outputs into a 16 bit output
		assign To_Out = {reg_3 , reg_2 , reg_1 , reg_0};
		assign Dout = To_Out;
		
		
endmodule
