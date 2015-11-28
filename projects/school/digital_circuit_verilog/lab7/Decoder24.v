`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:08:53 03/04/2014 
// Design Name: 
// Module Name:    Decoder24 
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
module Decoder24(
    input [1:0] Adrr,
    output [3:0] Sel
    );

	assign Sel = (Adrr==2'b11) ?4'b0001:
					(Adrr==2'b10) ?4'b0010:
					(Adrr==2'b01) ?4'b0100:
					4'b1000;
					
endmodule
