`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:34:00 03/11/2014 
// Design Name: 
// Module Name:    mod4 
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
module mod4(
    input Inc,
    input Reset,
    input Clk,
    output[1:0] Q
    );
		wire [1:0] N;

		//assign N = {~Reset&(~Inc&Q[1]|Q[1]&~Q[0]|~Q[1]&Q[0]),~Reset&(~Inc&Q[0]|Inc&~Q[0])};
		
		LFC Logic( Inc , Q , N);	
		FF_DC D_1(Q[1] , Clk , Reset , N[1]);
		FF_DC D_0(Q[0] , Clk , Reset , N[0]);
			
		
		

endmodule
