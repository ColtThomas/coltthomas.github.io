`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:23:01 02/25/2014 
// Design Name: 
// Module Name:    toggle_circuit 
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
module toggle_circuit(
    input gclk,
    input clr,
    output qout,
    output clk_out
    );
	 
	wire qnot , buffer;
		not(qnot , qout);
		buf(clk_out, gclk);
	
	flipflopD FF_DC(qnot , gclk , clr , qout);

endmodule
