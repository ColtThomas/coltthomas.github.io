`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:52:29 04/01/2014 
// Design Name: 
// Module Name:    Synchronizer 
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
module Synchronizer(
    output q,
    input clk,
    input d ,
    input clr,
    input en
    );

	wire middle;
FF_DCE First(middle, clk , d , clr , en);
FF_DCE Second(q, clk , middle , clr , en);
endmodule
