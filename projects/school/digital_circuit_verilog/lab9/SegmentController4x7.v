`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:53 03/17/2014 
// Design Name: 
// Module Name:    SegmentController4x7 
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
module SegmentController4x7(Digit1 , Digit2, Digit3, Digit4 , SysClk, Reset, Dp0 , Dp1, Dp2, Dp3,Ca , Cb , Cc , Cd , Ce , Cf , Cg , AN0 , AN1 ,AN2 , AN3, DP ,Q1 , Q0 , tp , zero );

input [3:0] Digit1 , Digit2 , Digit3 , Digit4;
input SysClk, Reset, Dp0, Dp1, Dp2, Dp3;
output  AN0, AN1, AN2, AN3;
output DP, Ca , Cb , Cc , Cd  ,Ce , Cf ,Cg;
//test signals for the clock
output Q1 , Q0;
output tp , zero;
wire [1:0] adrr;
wire[23:0] counter;
wire [3:0] Digit_Out;
wire [3:0] AN;

//since inc = '1', we just put 1'b1 for that input.  Reset will start it over
prog_timer Timer(SysClk , Reset , 1'b1 , 24'd250000 , counter,zero , tp);
mod4 Mod_4(zero, Reset, SysClk , adrr);

assign Q1 = adrr[1];
assign Q0 = adrr[0];
assign AN3 = AN[3];
assign AN2 = AN[2];
assign AN1 = AN[1];
assign AN0 = AN[0];
mux16to4 MUX16_4(Digit_Out , adrr , Digit1 , Digit2 , Digit3 , Digit4);
TestBench Seven_Seg_Decoder(Digit_Out , Ca , Cc ,Cf , Cg, Cb , Ce , Cd ) ;

Decoder24 Decoder(adrr , AN );
mux41 MUX_41( DP, adrr , Dp3 , Dp2 , Dp1 , Dp0);

endmodule
