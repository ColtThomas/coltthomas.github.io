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
	wire CEn , CE_not ,zero;
	wire [23:0] counter;
	wire tp_fake , zero_fake;	 
	wire Dp0, Dp1, Dp2, Dp3;
	assign Dp3 = 1'b1;
	assign Dp2 = 1'b0;
	assign Dp1 = 1'b1;
	assign Dp0 = 1'b0;
	
	SR_latch latch(Stop , Start, CEn , CE_not);
	prog_timer timer(SysClk, Reset, CEn , 24'd4950000, counter, zero, tp);
	
	
	CounterBlock counter_block(zero , Reset , SysClk , Sec_Tenths , Sec_Ones , Sec_Tens, Min_Ones);
	SegmentController4x7 Seg_Ctr(Min_Ones , Sec_Tens , Sec_Ones , Sec_Tenths, SysClk , 1'b0 ,Dp0 , Dp1, Dp2, Dp3, Ca , Cb , Cc , Cd , Ce , Cf , Cg , AN0 , AN1 ,AN2 , AN3, DP ,Q1 , Q0 , tp_fake , zero_fake );
	assign zero_out = zero;
endmodule
