`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:48:01 03/26/2014 
// Design Name: 
// Module Name:    Delay_Timer 
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
module Delay_Timer(
    input CNTstart,
    input MSen,
	 input Clk,
	 input Reset,
    output CNTdone
    );

	wire [7:0] Q;
	wire [12:0] Q_13, Din;
	wire [12:0] TP;
LFSR_8bit LFSR(Q , Clk , Reset);
shift4 shift(Q , Q_13);
adder_13bit adder(Q_13 , 13'd1000 , Din);
count_down_13bit counter(Din , CNTstart , MSen , Clk , CNTdone, TP);
endmodule
