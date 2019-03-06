`timescale 1 ns/1 ns

// Timer Testbench
module testbench();

// Test Parameters


// Signal Declarations
// Serial Test Signals
reg clk,rst,en,timer;
wire cs, Din, ready,Dout;
wire [3:0] state_serial,state_adc,recd_tp;
wire [9:0] data, time_out;

// Timer Test Signals
reg clken,reset_n;
reg [23:0] load_number;
wire zero, tp;
wire [9:0] counter;

// Instantiate Test Modules
//prog_timer UUT1 (.clk (clk), .reset(reset_n), .clken(clken), .counter(counter),.load_number(load_number), .zero(zero), .tp(tp));
serial UUT2 (.time_out(time_out), .clk(clk), .rst(rst),.cs(cs),.Dout(Dout),.state(state_serial), .en(en), .ready(ready),.data(data), .Din(Din));
adc_sim UUT3 (.clk(clk),.rst(rst),.Din(Din),.cs(cs),.Dout(Dout),.recd_tp(recd_tp),.state(state_adc),.counter(counter));
// Setup Clock
initial begin
	clk = 1'b0;
	forever clk = #20 ~clk;
end

// Test routine
initial begin
	// reset 
	load_number = 24'h000001;
	reset_n = 1'b1;
	rst = 1'b1;
	en = 1'b0;
	timer = 1'b0;
	//Dout = 1'b1;
	repeat (2)@( posedge clk);
	reset_n = 1'b0;
	repeat (2)@( posedge clk);
	rst = 1'b0;
	repeat (5)@( posedge clk);
	clken = 1'b1;	
	en = 1'b1;
	repeat (50)@(posedge clk);
	/*Dout = 1'b0;	// null bit
	repeat (1)@(posedge clk);
	Dout = 1'b1;	// B9
	repeat (1)@(posedge clk);
	Dout = 1'b0;	// B8
	repeat (1)@(posedge clk);
	Dout = 1'b1;	// B7
	repeat (1)@(posedge clk);
	Dout = 1'b0;	// B6
	repeat (1)@(posedge clk);
	Dout = 1'b0;	// B5
	repeat (1)@(posedge clk);
	Dout = 1'b1;	// B4
	repeat (1)@(posedge clk);
	Dout = 1'b0;	// B3
	repeat (1)@(posedge clk);
	Dout = 1'b1;	// B2
	repeat (1)@(posedge clk);
	Dout = 1'b0;	// B1
	repeat (1)@(posedge clk);
	Dout = 1'b1;	// B0
	repeat (1.5)@(posedge clk);
	Dout = 1'bZ;
	repeat (20)@(posedge clk);
	Dout = 1'b0;	// null bit
	repeat (1)@(posedge clk);
	Dout = 1'b1;	// B9
	repeat (1)@(posedge clk);
	Dout = 1'b0;	// B8
	repeat (1)@(posedge clk);
	Dout = 1'b1;	// B7
	repeat (1)@(posedge clk);
	Dout = 1'b0;	// B6
	repeat (1)@(posedge clk);
	Dout = 1'b0;	// B5
	repeat (1)@(posedge clk);
	Dout = 1'b1;	// B4
	repeat (1)@(posedge clk);
	Dout = 1'b0;	// B3
	repeat (1)@(posedge clk);
	Dout = 1'b1;	// B2
	repeat (1)@(posedge clk);
	Dout = 1'b0;	// B1
	repeat (1)@(posedge clk);
	Dout = 1'b1;	// B0
	repeat (1.5)@(posedge clk);
	Dout = 1'bZ;
	repeat (20)@(posedge clk);*/
	
	
	$stop;
end


endmodule
