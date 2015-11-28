`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:45:15 02/11/2014 
// Design Name: 
// Module Name:    mux2by1 
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
module mux21(q, sel, a, b); 
 input sel, a, b; 
 output q; 
 wire selbar, a1, a2; 
 
 not(selbar, sel); 
 and(a1, selbar, a); 
 and(a2, sel, b); 
 or(q, a1, a2);
	
endmodule
