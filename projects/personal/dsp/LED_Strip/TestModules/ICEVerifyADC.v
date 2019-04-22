module ICEVerifyADC(input clk,input ready, input rst, output reg led);

/*
  Description:  This module will control an led to verify that a sample 
  has been sucessfully received. The ready signal from serial.v is a
  Mealy output that is asserted for 1 clock cycle as soon as a sample
  is collected serially from the ADC. The LED will remain high until
  reset as verification that a proper sample was received.
*/

	localparam IDLE=0, RECEIVED=1;
	localparam DATA_WIDTH=10'd9;
	localparam TIMER=10'd100;	// in units of clock cycles
	reg [2:0] state_reg, state_next;
	
// State Registers
always @(posedge clk) begin
	if(rst)
		begin
			state_reg <= IDLE;
			state_next <= IDLE;
		end
	else
		begin 
			state_reg <= state_next;
		end

end

// Next State Logic
always @(*) begin
	state_next = state_reg;
	led = 0;
	case (state_reg)
		IDLE: begin
			led = 0;
			if (ready==1) begin
				state_next = RECEIVED;
			end
		end
		RECEIVED: begin
			led = 1;
		end
	endcase
end

endmodule
