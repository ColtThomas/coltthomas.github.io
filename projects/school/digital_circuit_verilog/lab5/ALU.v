`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:04:29 02/11/2014 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input A,
    input B,
    input Cin,
    input [1:0]C,
    output Cout,
    output Result

    );
		 wire sum , Aout , AandB , Anot,Carry; 
FullAdder1 FA(A , B , Cin , Carry , sum);
CarryCtr CC (Carry,C,Cout);
OtherLogic OL (A , B , AandB , Anot , Aout);
mux41 MO (Result , C, Aout , sum , AandB, Anot);

endmodule
