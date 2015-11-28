`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:35:05 03/26/2014 
// Design Name: 
// Module Name:    adder-13bit 
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
module adder_13bit(
    input [12:0] Ain,
    input [12:0] Bin,
    output [12:0] Sum
    );

	assign Sum = (Ain + Bin);
endmodule
