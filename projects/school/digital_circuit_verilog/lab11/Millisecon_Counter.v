`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:20:45 04/01/2014 
// Design Name: 
// Module Name:    Millisecon_Counter 
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
module Millisecond_Counter(
    output MSrollover,
    output [15:0] SCin,
    input MSreset,
    input MSen,
	 input Clk

    );

wire tenths_roll, ones_roll, tens_roll, hunds_roll; 
wire[3:0] tenth_value,one_value, tens_value , hunds_value;
mod10 tenths(Clk, MSreset, MSen ,tenths_roll,tenth_value);
mod10 ones(Clk, MSreset, tenths_roll , ones_roll ,one_value);
mod10 tens(Clk, MSreset, ones_roll , tens_roll,tens_value);
mod10 hund(Clk, MSreset, tens_roll ,hunds_roll,hunds_value);

assign SCin = { hunds_value, tens_value , one_value , tenth_value};
assign MSrollover = hunds_roll;
endmodule
