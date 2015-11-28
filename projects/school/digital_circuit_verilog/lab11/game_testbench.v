`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:06 04/01/2014 
// Design Name: 
// Module Name:    game_testbench 
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
module game_testbench(
    input Start,
    input Stop,
    input BestScore,
	 input Reset,
	 input Clk,   //not like MSen
    output [7:0] C,
    output DD,
    output [3:0] AN,
	 output LED
    );
	 
Game pwnage(Start, Stop, BestScore, Reset, Clk, C, DD, AN, LED);


endmodule
