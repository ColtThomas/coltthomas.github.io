`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:43 03/26/2014 
// Design Name: 
// Module Name:    count_down_13bit 
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
module count_down_13bit(
    input [12:0] Din,
    input Load,
    input EN,
	 input Clk,
    output reg Zero,
	 output[12:0] TP
    );
	
	
	reg[12:0] current; 
	
	always @ (posedge Clk)
	if (Load)
		begin
			current <= Din;	
			Zero <= 0;
		end
	else if (current == 13'b0000000000000)
		begin
			Zero <= 1;
		end
	else if (EN && !Load)
		begin
			current <= current - 1;
		end
assign TP = current;
endmodule
