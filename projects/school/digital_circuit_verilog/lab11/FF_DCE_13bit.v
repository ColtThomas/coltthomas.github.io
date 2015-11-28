`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:40 03/29/2014 
// Design Name: 
// Module Name:    FF_DCE_13bit 
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
module FF_DCE_13bit(
    output [12:0] q,
    input clk,
    input [12:0] d,
    input clr,
    input en
    );


FF_DCE Bit_0(q[0] , clk , d[0] , clr , en);
FF_DCE Bit_1(q[1] , clk , d[1] , clr , en);
FF_DCE Bit_2(q[2] , clk , d[2] , clr , en);
FF_DCE Bit_3(q[3] , clk , d[3] , clr , en);
FF_DCE Bit_4(q[4] , clk , d[4] , clr , en);
FF_DCE Bit_5(q[5] , clk , d[5] , clr , en);
FF_DCE Bit_6(q[6] , clk , d[6] , clr , en);
FF_DCE Bit_7(q[7] , clk , d[7] , clr , en);
FF_DCE Bit_8(q[8] , clk , d[8] , clr , en);
FF_DCE Bit_9(q[9] , clk , d[9] , clr , en);
FF_DCE Bit_10(q[10] , clk , d[10] , clr , en);
FF_DCE Bit_11(q[11] , clk , d[11] , clr , en);
FF_DCE Bit_12(q[12] , clk , d[12] , clr , en);

endmodule
