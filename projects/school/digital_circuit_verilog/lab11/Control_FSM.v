`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:01:13 04/01/2014 
// Design Name: 
// Module Name:    Control_FSM 
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
module Control_FSM(
    input Start,
    input Stop,
    input CNTdone,
    input MSrollover,
	 input Reset,
	 input Clk,
    output LED,
    output CNTstart,
    output SCupdate,
    output MSreset
    );

	wire [2:0] d , q;
LogicBlock LFC(q, Start, Stop, Reset, CNTdone, MSrollover, LED, CNTstart, SCupdate, MSreset, d);
FF_DCE_2bit State(q , Clk ,d , 1'b0 , 1'b1);

//warning: reset might put the FSM into state 00000 instead of 10000

endmodule
