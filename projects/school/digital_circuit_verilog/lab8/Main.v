`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:06 03/17/2014 
// Design Name: 
// Module Name:    Main 
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
module Main(
    input [3:0] N,
    output CA,
    output CC,
    output CF,
    output CG,
    output CB,
    output CE,
    output CD
    );

ROMs_Combo The_Logic(N , CA , CC ,CF , CG, CB , CD , CE);

endmodule
