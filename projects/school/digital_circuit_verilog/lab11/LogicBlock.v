`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:15:50 04/01/2014 
// Design Name: 
// Module Name:    LogicBlock 
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
module LogicBlock(
	 input[2:0] q,
    input Start,
    input Stop,
    input Reset,
    input CNTdone,
    input MSrollover,
    output LED,
    output CNTstart,
    output SCupdate,
    output MSreset,
	 output[2:0] n
    );
//check the cnt start and the cnt done, since the game keeps asserting load

assign n[2] = !Reset && ((CNTdone && q[1]) || (!Stop && !MSrollover && q[2]) );
assign n[1] = !Reset && ((Start && q[0]) || (!CNTdone && q[1]));
assign n[0] = Reset || !Reset && ((!Start && q[0])||(!Stop && MSrollover && q[2]) || (Stop && MSrollover && q[2]) || (Stop && !MSrollover && q[2]));

assign LED = q[2];
assign SCupdate = !Reset && (Stop && !MSrollover && q[2]);
assign CNTstart = !Reset && (Start && q[0]);
assign MSreset = !Reset && (CNTdone && q[1]);


endmodule
