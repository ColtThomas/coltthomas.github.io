module adc_sim(input rst, input Din, input clk, input cs, output reg [3:0] state, output reg Dout, output reg [3:0] recd_tp, output reg [9:0] counter);

localparam SAMPLE0=10'b1100101001;
localparam IDLE=0, WAKE=1, DIFF=2, D2=3,D1=4,D0=5,PROCESS=6,SEND=7;
localparam SAMPLE_SIZE=10'd10; // add 1 for the null byte

reg [3:0] state_reg, state_reg_next,cmd_reg,cmd_reg_next;
reg [9:0] data_reg, data_reg_next,count_reg,count_reg_next;


// State registers
always @(posedge clk) begin
	if(rst) begin
		state_reg <= IDLE;
		data_reg <= 10'd0;
		count_reg <= SAMPLE_SIZE;
		cmd_reg <= 4'd0;
		
		state_reg_next <= IDLE;
		data_reg_next <= 10'd0;
		count_reg_next <= SAMPLE_SIZE;
		cmd_reg_next <= 4'd0;
	end else begin
		state_reg <= state_reg_next;
		data_reg <= data_reg_next;
		count_reg <= count_reg_next;
		cmd_reg <= cmd_reg_next;
		
	end
	
end

// Next state logic
always @(*) begin
	// Next state registers
	state_reg_next = state_reg;
	count_reg_next = count_reg;
	data_reg_next = data_reg;
	cmd_reg_next = cmd_reg;
	
	recd_tp = cmd_reg;
	state = state_reg;
	counter = count_reg;
	Dout = 1'bZ;
	case(state_reg)
		IDLE : begin
			if(Din && ~cs) begin
				state_reg_next = DIFF;
			end
		end
		WAKE : begin	// get rid of this state...
		end
		DIFF : begin
			cmd_reg_next = {cmd_reg[2:0],Din};
			state_reg_next = D2;
		end
		D2 : begin
			cmd_reg_next = {cmd_reg[2:0],Din};
			state_reg_next = D1;
		end
		D1 : begin
			cmd_reg_next = {cmd_reg[2:0],Din};
			state_reg_next = D0;
		end
		D0 : begin
			cmd_reg_next = {cmd_reg[2:0],Din};
			state_reg_next = PROCESS;
		end
		PROCESS : begin
			// add a case or ternary statement for multiple channels
			state_reg_next = SEND;
			data_reg_next = 10'b1100101001;
		end
		SEND : begin			
			if(count_reg==0) begin
				Dout = data_reg[count_reg];
				count_reg_next <= SAMPLE_SIZE;
				state_reg_next = IDLE;
			end else if (count_reg==SAMPLE_SIZE) begin
				Dout = 1'b0; // Null bit
			end else begin
				Dout = data_reg[count_reg];
			end
			count_reg_next = count_reg - 1;
		end
	endcase
end

endmodule
