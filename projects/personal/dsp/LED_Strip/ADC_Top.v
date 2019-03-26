module ADC_Top (
	input clk,
	input rst,
	output [7:0] led,
	output cs,
	output Din,
	input Dout,
	
);


// Test 1 - see if the ADC converter will show correct output for a constant voltage
wire [9:0] time_out;
wire en;
wire [9:0] data;

assign led = [9:2] data;

serial inst (.time_out(time_out), .clk(clk), .rst(rst),.cs(cs),.Dout(Dout),.state(state_serial), .en(en), .ready(ready),.data(data), .Din(Din));

endmodule
