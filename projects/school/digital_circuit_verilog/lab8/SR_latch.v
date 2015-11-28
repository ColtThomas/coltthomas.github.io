`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:18:59 03/22/2014 
// Design Name: 
// Module Name:    SR_latch 
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
module SR_latch(
    input S,
    input R,
    output Q,
	 output Q_not
    );

	assign Q = ~(R | Q_not);
	assign Q_not = ~( S | Q);
	


endmodule
