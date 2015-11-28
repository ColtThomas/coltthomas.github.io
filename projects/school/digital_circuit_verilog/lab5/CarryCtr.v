`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:27:03 10/08/2014 
// Design Name: 
// Module Name:    CarryCtr 
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
module CarryCtr(
    input Carry,
    input [0:1] C,
    output Cout
    );
wire temp0, temp1;
not(temp0 , C[0]);
and(temp1,temp0,C[1]);
and(Cout,Carry,temp1);
endmodule
