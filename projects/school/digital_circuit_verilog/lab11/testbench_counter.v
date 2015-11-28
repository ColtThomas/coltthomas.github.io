`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:56:23 03/24/2014 
// Design Name: 
// Module Name:    testbench_counter 
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
module testbench_counter(
    input SysClk,
    input Start,
    input Stop,
    input Reset,
	 input Dp0, Dp1, Dp2, Dp3,
	 output tp, zero_out,
	 output  AN0, AN1, AN2, AN3,
	output DP, Ca , Cb , Cc , Cd  ,Ce , Cf ,Cg,
//test signals for the clock
output Q1 , Q0
    );
	 wire [3:0] Min_Ones;
    wire[3:0] Sec_Tens;
    wire [3:0] Sec_Ones;
    wire [3:0] Sec_Tenths;
	wire CE , CE_not ,zero;
	wire [23:0] counter;
	wire tp_fake , zero_fake;
	SR_latch latch(Stop , Start, CE , CE_not);
	prog_timer timer(SysClk, Reset, CE , 24'd4950000, counter, zero, tp);
	
	CounterBlock counter_block(zero , Reset , SysClk , Sec_Tenths , Sec_Ones , Sec_Tens, Min_Ones);
	SegmentController4x7 Seg_Ctr(4'b0000 , 4'b0000 , 4'b0000 , 4'b0000, SysClk , 1'b0 , Ca , Cb , Cc , Cd , Ce , Cf , Cg , AN0 , AN1 ,AN2 , AN3, DP ,Q1 , Q0 , tp_fake , zero_fake );
	assign zero_out = zero;
endmodule
