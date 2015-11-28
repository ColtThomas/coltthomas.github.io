`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:25:18 03/18/2014 
// Design Name: 
// Module Name:    testbench_SegCtrl4x7 
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
module testbench_SegCtrl4x7(

    input SysClk,
    input Reset,
    input Dp0,
    input Dp1,
    input Dp2,
    input Dp3,
    output AN0,
    output AN1,
    output AN2,
    output AN3,
    output DP,
    output Ca,
    output Cb,
    output Cc,
    output Cd,
    output Ce,
    output Cf,
    output Cg,
    output Q1,
    output Q0,
    output tp,
    output zero
    );
	 wire [3:0] Digit1;
    wire [3:0] Digit2;
    wire [3:0] Digit3;
    wire [3:0] Digit4;
assign Digit1 = 4'b0001;
assign Digit2 = 4'b1010;
assign Digit3 = 4'b1011;
assign Digit4 = 4'b1000;

SegmentController4x7 thing(Digit1 , Digit2 , Digit3 , Digit4 , SysClk , Reset , Dp0, Dp1, Dp2, Dp3, Ca , Cb , Cc , Cd , Ce ,Cf , Cg ,AN0, AN1, AN2, AN3, DP , Q1 , Q0 , tp , zero);

endmodule
