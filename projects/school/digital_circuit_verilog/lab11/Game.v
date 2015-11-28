`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:49:23 04/01/2014 
// Design Name: 
// Module Name:    Game 
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
module Game(
    input Start,
    input Stop,
    input BestScore,
	 input Reset,
	 input Clk,   //not like MSen
    output [7:0] C,
    output DD,
    output [3:0] AN,
	 output LED
    );
	wire Start_Synch, Stop_Synch, CNTstart , CNTdone , SCupdate , MSrollover , MSreset, MSen;
	wire [15:0] SCin , SCout;
	//seven segment display wires
	wire Dp0 , Dp1, Dp2, Dp3,Ca , Cb , Cc , Cd , Ce , Cf , Cg , AN0 , AN1 ,AN2 , AN3, DP /*,Q1 , Q0*/;
	wire [3:0] Digit1 ,  Digit2, Digit3, Digit4;
	//wires for needless outputs
	wire tp1 , tp2, zero1 ,zero2;
	wire [23:0] counter;
	
//Synchronizers
Synchronizer Input_Start( Start_Synch, Clk, Start , Reset, 1'b1);
Synchronizer Input_Stop( Stop_Synch, Clk, Stop , Reset, 1'b1);

//Programmable timer with timer value of 50000
prog_timer Programmable_Timer(Clk, Reset, 1'b1, 24'd50 , counter, MSen, tp1);

//FSM Control module
Control_FSM Control( Start_Synch, Stop_Synch, CNTdone, MSrollover, Reset, Clk, LED, CNTstart, SCupdate, MSreset);

//The random number generator and timer countdown
Delay_Timer Delay( CNTstart, MSen, Clk, Reset, CNTdone);

//Millisecond counter
Millisecond_Counter Count( MSrollover, SCin, MSreset, MSen, Clk);

//Scoring unit
Scoring_Unit Score( SCout, SCupdate, SCin, BestScore, Clk, Reset);


//These are the digits to be displayed on the seven segment decoder
assign Digit4 = {SCout[15] , SCout[14] ,SCout[13] ,SCout[12]};
assign Digit3 = {SCout[11] , SCout[10] ,SCout[9] ,SCout[8]};
assign Digit2 = {SCout[7] , SCout[6] ,SCout[5] ,SCout[4]};
assign Digit1 = {SCout[3] , SCout[2] ,SCout[1] ,SCout[0]};

//we only want the leftmost decimal point to appear, so we set Dp0 to be high
assign Dp0 = 1'b1;
assign Dp1 = 1'b0;
assign Dp2 = 1'b0;
assign Dp3 = 1'b0;

//This displays SCout
SegmentController4x7 Seven_Seg_Disp_Ctrl(Digit1 , Digit2, Digit3, Digit4 , Clk, 1'b0, Dp0 , Dp1, Dp2, Dp3,Ca , Cb , Cc , Cd , Ce , Cf , Cg , AN0 , AN1 ,AN2 , AN3, DP /*,Q1 , Q0 */, tp2 , zero2 );
assign C = {Ca , Cb , Cc , Cd , Ce , Cf , Cg};
assign DD = DP;
assign AN = {AN0 , AN1 ,AN2 , AN3};

endmodule
