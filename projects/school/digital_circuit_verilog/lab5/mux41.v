`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:49:02 02/11/2014 
// Design Name: 
// Module Name:    mux41 
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
module mux41(q, sel, a, b, c, d); 
 input[1:0] sel; 
 input a, b, c, d; 
 output q; 
 wire tmp1, tmp2; 
 
 mux21 M0(tmp1, sel[0], a, b); 
 mux21 M1(tmp2, sel[0], c, d); 
 mux21 M2(q, sel[1], tmp1, tmp2); 

    

endmodule
