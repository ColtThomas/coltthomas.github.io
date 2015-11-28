`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:33 03/22/2014 
// Design Name: 
// Module Name:    CounterBlock 
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
module CounterBlock(
    input inc,
    input Reset,
    input SysClk,
    output [3:0] sec_tenths,
    output [3:0] sec_ones,
    output [3:0] sec_tens,
    output [3:0] min_ones
    );

wire rolloverTo_ones , rolloverTo_tens, rolloverTo_min, rolloverTo_ground;


mod10 tenths(SysClk , Reset, inc, rolloverTo_ones , sec_tenths);
mod10 ones(SysClk , Reset, rolloverTo_ones, rolloverTo_tens , sec_ones);
mod6 tens(SysClk , Reset, rolloverTo_tens, rolloverTo_min , sec_tens);
mod10 min(SysClk , Reset, rolloverTo_min, rolloverTo_ground, min_ones);




endmodule
