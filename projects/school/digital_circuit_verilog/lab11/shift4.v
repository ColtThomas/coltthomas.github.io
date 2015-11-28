`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:43:03 03/26/2014 
// Design Name: 
// Module Name:    shift4 
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
module shift4(
    input [7:0] Din,
    output [12:0] Dout
    );

	assign Dout = { 4'b0000 , Din};
	
endmodule
