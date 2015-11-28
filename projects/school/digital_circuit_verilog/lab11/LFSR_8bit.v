`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:42:38 03/26/2014 
// Design Name: 
// Module Name:    LFSR_8bit 
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
module LFSR_8bit(q, clk , reset); 
 input clk,reset; 
 output reg[7:0] q; 





always @ (posedge clk)


if (reset)
	q[7:0] <= 8'b00000001;
else
	begin
	q[0] <= q[7];
	q[1] <= q[0];
	q[2] <= q[1];
	q[3] <= q[2] ^ q[0];
	q[4] <= q[3] ^ q[0];
	q[5] <= q[4] ^ q[0];
	q[6] <= q[5];
	q[7] <= q[6];


	end

endmodule
