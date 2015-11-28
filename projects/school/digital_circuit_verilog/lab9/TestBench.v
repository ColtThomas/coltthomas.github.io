`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:58:11 03/17/2014 
// Design Name: 
// Module Name:    TestBench 
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
module TestBench(
    input [3:0]N,
    output CA,
    output CC,
    output CF,
    output CG,
    output CB,
    output CE,
    output CD
    );
	
//the hierchy of this represents the original .sch files, even though the main seems redundant

	Main block(N , CA , CC ,CF , CG, CB , CE , CD);

endmodule
