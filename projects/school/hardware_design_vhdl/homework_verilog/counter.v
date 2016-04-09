`timescale 1ns / 1ps
// Listing 9.6
module counter(input clk, input reset, output reg[5:0] sec, output reg[5:0] min);

reg[19:0] r_reg, r_next;
reg[5:0] s_reg,m_reg,s_next,m_next;
reg s_en,m_en;

always@(posedge clk or reset)
begin
	if(reset==1'b1)
	begin
		r_reg <= 20'b0;
		s_reg <= 6'b0;
		m_reg <= 6'b0;
	end
	else 
	begin
		r_reg <= r_next;
		s_reg <= s_next;
		m_reg <= m_next;
	end
end

always@(r_reg or s_reg or m_reg or s_en or m_en)
begin
	r_next <=(r_reg== 20'd999999) ? 20'b0 : r_reg + 1;
	s_en <= (r_reg == 20'd500000) ? 1'b1 : 1'b0;
	s_next <= 	(s_reg == 59 & s_en == 1'b1)?  6'b0:
					(s_en == 1'b1)? s_reg + 1:
					s_reg;
	m_en <= (s_reg == 20'd30 & s_en==1'b1)? 1'b1 : 1'b0;
	m_next <= 	(m_reg==6'd59 & m_en==1'b1)? 6'b0:
					(m_en==1'b1)? m_reg+1:
					m_reg;
	
	sec <= s_reg;
	min<= m_reg;
end

endmodule


// Listing10.7
module thing(input clk, input reset, input strobe, output reg p1);
	reg[1:0] state_reg,state_next;
	
	`define ZERO 2'b00;
	`define EDGE 2'b01;
	`define ONE 2'b10;	
	
	reg[1:0] ZERO = `ZERO;
	reg[1:0] EDGE = `EDGE
	reg[1:0] ONE = `ONE;
	// state register
	always@(posedge clk or reset)
	begin 
		if(reset==1'b1) state_reg <= ZERO;
		else state_reg <= state_next;
	end
	
	// Next state logic
	always@(state_reg or strobe)
	begin
		case(state_reg)
			ZERO: state_next <=(strobe==1'b1)? EDGE:ZERO;
			EDGE: state_next <=(strobe==1'b1)? ONE:ZERO;
			ONE: state_next <=(strobe==1'b1)? ONE:ZERO;
			default: state_next <= state_reg;
		endcase
		
		p1 <= (state_reg == EDGE)? 1'b1:1'b0;
	end
	
	
endmodule