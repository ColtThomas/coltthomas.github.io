`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:27:53 03/04/2014 
// Design Name: 
// Module Name:    RegisterFile 
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
module RegisterFile(
    output [3:0] Dout,
    input [3:0] Din,
    input Clk,
	 input Clr,
    input Write,
    input [1:0] Adrr_Read,
	 input [1:0] Adrr_Write
    );
	wire [15:0] Reg_Out;
	wire [3:0] Reg_3, Reg_2, Reg_1, Reg_0;
	FourWordRegister Reg(Din , Write , Adrr_Write, Clk, Clr, Reg_Out);
	
	assign Reg_3 = {Reg_Out[15], Reg_Out[14], Reg_Out[13], Reg_Out[12]};
	assign Reg_2 = {Reg_Out[11], Reg_Out[10], Reg_Out[9], Reg_Out[8]};
	assign Reg_1 = {Reg_Out[7], Reg_Out[6], Reg_Out[5], Reg_Out[4]};
	assign Reg_0 = {Reg_Out[3], Reg_Out[2], Reg_Out[1], Reg_Out[0]};
	mux16to4 mux(Dout , Adrr_Read , Reg_3, Reg_2, Reg_1, Reg_0);

endmodule
