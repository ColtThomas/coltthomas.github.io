`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:07:10 04/01/2014 
// Design Name: 
// Module Name:    FF_DCE_5bit 
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
module FF_DCE_2bit(
    output [2:0] q,
    input clk,
    input [2:0] d,
    input clr,
    input en
    );

FF_DCE bit0(q[0], clk , d[0] , clr , en);
FF_DCE bit1(q[1], clk , d[1] , clr , en);
FF_DCE bit2(q[2], clk , d[2] , clr , en);

endmodule
