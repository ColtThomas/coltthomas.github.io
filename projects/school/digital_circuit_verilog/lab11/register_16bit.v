`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:00:52 03/26/2014 
// Design Name: 
// Module Name:    register_16bit 
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
module register_16bit(
    output [15:0] Q,
    input [15:0] D,
    input EN,
    input Clk,
	 input reset
    );
	
	wire [15:0] current_state;

	FF_DCE registerbit_0(current_state[0] ,Clk , D[0] ,1'b0 , EN);
	FF_DCE registerbit_1(current_state[1] ,Clk , D[1] ,1'b0 , EN);
	FF_DCE registerbit_2(current_state[2] ,Clk , D[2] ,1'b0 , EN);
	FF_DCE registerbit_3(current_state[3] ,Clk , D[3] ,1'b0 , EN);
	FF_DCE registerbit_4(current_state[4] ,Clk , D[4] ,1'b0 , EN);
	FF_DCE registerbit_5(current_state[5] ,Clk , D[5] ,1'b0 , EN);
	FF_DCE registerbit_6(current_state[6] ,Clk , D[6] ,1'b0 , EN);
	FF_DCE registerbit_7(current_state[7] ,Clk , D[7] ,1'b0 , EN);
	FF_DCE registerbit_8(current_state[8] ,Clk , D[8] ,1'b0 , EN);
	FF_DCE registerbit_9(current_state[9] ,Clk , D[9] ,1'b0 , EN);
	FF_DCE registerbit_10(current_state[10] ,Clk , D[10] ,1'b0 , EN);
	FF_DCE registerbit_11(current_state[11] ,Clk , D[11] ,1'b0 , EN);
	FF_DCE registerbit_12(current_state[12] ,Clk , D[12] ,1'b0 , EN);
	FF_DCE registerbit_13(current_state[13] ,Clk , D[13] ,1'b0 , EN);
	FF_DCE registerbit_14(current_state[14] ,Clk , D[14] ,1'b0 , EN);
	FF_DCE registerbit_15(current_state[15] ,Clk , D[15] ,1'b0 , EN);
	

	assign Q = 	current_state;
endmodule
