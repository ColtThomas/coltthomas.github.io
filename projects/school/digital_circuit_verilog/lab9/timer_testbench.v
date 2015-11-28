`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:56:09 03/17/2014 
// Design Name: 
// Module Name:    timer_testbench 
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
module timer_testbench(
    input clk,
    input reset,
    input clken,
    input [23:0] load_number,
    output [23:0] counter,
    output zero,
    output tp
    );

	prog_timer timer(clk, reset, clken , 24'd4950000, counter, zero, tp);

	
endmodule
