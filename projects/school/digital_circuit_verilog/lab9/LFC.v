`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:36:30 03/11/2014 
// Design Name: 
// Module Name:    LFC 
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
module LFC(

    input Inc,
    input [1:0] Q,
    output [1:0] N
    );
		wire a_1 , b_1 , c_1 , a_0 , b_0;
		wire final_1 , final_0;
	
		
		//potential errors: the ~ doesn't negate
		and(a_1, !Inc , Q[1]);
		and(b_1, Q[1] , !Q[0]);
		and(c_1, Inc , !Q[1], Q[0]);
		
		and(a_0 , !Inc, Q[0]);
		and(b_0 , Inc  , !Q[0]);
		
		or (final_1 , a_1 , b_1 , c_1);
		or (final_0 , a_0 , b_0);
		
		assign N[0] = final_0;
		assign N[1] = final_1;
		
endmodule
