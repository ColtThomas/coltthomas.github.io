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
	wire EN;

assign EN = reset||(SCupdate && (Q_Best > SCin) );


Best_Register Best(Q_Best , SCin , EN , Clk , reset);
Last_Register Last(Q_Last , SCin , SCupdate , Clk , reset);
assign SCout = (BESTSCORE==1'b1)?Q_Best:
					Q_Last;
endmodule
