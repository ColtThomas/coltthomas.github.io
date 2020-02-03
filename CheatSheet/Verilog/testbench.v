module testbench();

// Serial Test Signals
reg clk,rst, A, B;
wire out;
wire [1:0] stateOut;
statemachine UUT (.clk(clk), .rst(rst) , .A(A) , .B(B) , .out(out), .stateOut(stateOut));

// Setup Clock
initial begin
	clk = 1'b0;
	forever clk = #20 ~clk;
end

initial begin
	rst = 1'b1;
	A = 1'b0;
	B = 1'b0;
	
	repeat (2)@( posedge clk);
	rst = 1'b0;
	repeat (2)@( posedge clk);
	A = 1'b1;
	repeat (6)@( posedge clk);
	A = 1'b0;
	repeat (2)@( posedge clk);
	B = 1'b1;
end

endmodule