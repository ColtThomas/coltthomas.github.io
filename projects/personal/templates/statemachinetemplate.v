module statemachine(output reg out, input B, input clk, input A, input rst, output reg [1:0] stateOut);
/* State machine description: 
         (IDLE)----------------------
           |                                |
        [B == TRUE] - F - - - -             |
           |                   |            |
	   T                   |            |
	   |                   |            |
        (ERROR)            [A == TRUE] - F --
	                       |
	                       T
	                       |
	                   (WAITFORB) ------
			       |           |
			  [B == TRUE] - F --  
			       |
			       T
			       |
	                    (DONE *OUT=1*)
			    
	**SYNCHRONOUS RESET -> IDLE**
	
*/
localparam 	IDLE=0, WAITFORB=1,DONE=2, ERROR=3;

reg [1:0] 	state, nxtState;
	
// State Registers	
	
// Synchronous reset; make asynch by uncommenting reset signal in sensitivity list
always @(posedge clk /*, posedge rst*/) begin 
	if(rst) begin	
		state <= IDLE;
	end else begin
		state <= nxtState;
	end
end

// Next State Function
always @(*) begin  // The * is used to indicate combinational logic
	nxtState = state;	// Default next state: don't move
	stateOut = state;
	out = 0;
	case (state)
		IDLE : begin
			if (B) nxtState = ERROR;
			else if (A) nxtState = WAITFORB;
		end
		WAITFORB : begin
			if (B) nxtState = DONE;
		end
		DONE : begin
			out = 1;	// Moore output. Make Mealy with an if statement dependent on an input before transition 
		end
		ERROR : begin
		end
	endcase
end

endmodule
