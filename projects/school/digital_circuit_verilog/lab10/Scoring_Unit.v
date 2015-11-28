`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:30:36 03/26/2014 
// Design Name: 
// Module Name:    Scoring_Unit 
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
module Scoring_Unit(
    output [15:0] SCout,
    input SCupdate,
    input [15:0] SCin,
    input BESTSCORE,
	 input Clk,
	 input reset
    );

	wire [15:0] Q_Last , Q_Best;

register_16bit Last_time_register(Q_Last,SCin,SCupdate,Clk,reset);
assign Q_Best = (reset==1'b1)?16'h9999:
					 (Q_Last < Q_Best)?Q_Last:
					 Q_Best;

assign SCout = (BESTSCORE==1'b0)?Q_Last:
					Q_Best;
endmodule
