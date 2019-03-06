/*
	Serial Functional Description
	Uses:
		- Receive samples from an MCP3008 ADC by implementing SPI
*/

module serial(output reg [9:0] time_out, output reg cs, output reg ready, output reg Din, output reg [3:0] state, output reg [9:0] data, input clk, input rst, input en,input Dout);


	/* States:
		0000 - Idle state
		0001 - Request Send
		0010 - Differential Bit
		0011 - D2 Bit
		0100 - D1 Bit (channel selector)
		0101 - D0 Bit (channel selector)
		0110 - Listen State
		0111 - Receive State
		1000 - End Sample Receive State
	*/
	localparam IDLE=0, REQUEST=1, DIFFERENTIAL=2, D2=3, D1=4, D0=5, LISTEN=6, RECEIVE=7, END=8;
	localparam DATA_WIDTH=10'd9;
	localparam TIMER=10'd100;	// in units of clock cycles
	reg [3:0] state_reg, state_next;
	reg [9:0] data_reg, data_reg_next, timer_reg,timer_reg_next,count_reg,count_reg_next;
// State Registers
always @(posedge clk) begin
	if(rst)
		begin
			state_reg <= IDLE;
			state_next <= IDLE;
			data_reg <= 10'b0;	// consider a second register
			count_reg <= DATA_WIDTH;
			count_reg_next <= DATA_WIDTH;
			timer_reg <= TIMER;
			timer_reg_next <= TIMER;
		end
	else
		begin
			state_reg <= state_next;
			//state_reg = 4'b1111;
			timer_reg <= timer_reg_next;
			data_reg <= data_reg_next;
			count_reg <= count_reg_next;
		end
end

// Next State Logic
always @(*) begin
	// next state registers
	state_next = state_reg;
	count_reg_next = count_reg;
	data_reg_next = data_reg;
	timer_reg_next = timer_reg;

	// default output
	time_out = count_reg;
	state = state_reg;
	cs = 1;
	Din = 0;
	data = data_reg;
	ready = 0;

	case (state_reg)
		IDLE : begin
			cs=1;
			if(en) begin
				state_next = REQUEST;
			end
		end
		REQUEST : begin
			cs = 0;
			Din = 1;	// Start bit
			state_next = DIFFERENTIAL;
		end
		DIFFERENTIAL : begin
			cs = 0;
			state_next = D2;
			Din = 1;	// enable single-ended configuration (rather than differential)
		end
		D2 : begin
			cs = 0;
			state_next = D1;
			Din = 0; // Don't care
		end
		D1 : begin
			cs = 0;
			state_next = D0;
			Din = 0;
		end
		D0 : begin
			cs = 0;
			state_next = LISTEN;
			Din = 0;
		end
		LISTEN : begin
			cs = 0;
			timer_reg_next = timer_reg_next - 1;
			if(timer_reg==0) begin
				timer_reg_next = TIMER;
				state_next = IDLE;
			end
			else if (~Dout & (timer_reg>0)) begin
				state_next = RECEIVE;
			end
		end
		RECEIVE : begin
			data_reg_next = {data_reg[8:0], Dout};	// Remember to shift out the start bit
			cs=0;
			count_reg_next = count_reg_next - 1;
			if(count_reg == 0) begin
				state_next = END;
			end else begin
				state_next = RECEIVE;
			end
		end
		END : begin
			cs = 1;
			count_reg_next = DATA_WIDTH;
			if(en) begin
				ready = 1;	
				state_next = REQUEST;
			end else begin
				ready = 1;	
				state_next = IDLE;
			end
		end
	endcase
end


endmodule
