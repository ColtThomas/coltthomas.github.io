// Colt Thomas - Hw 14
module mux41(input[3:0]in,input[1:0]sel,output reg out);
	always@(sel or in)
	begin
		out <= in[sel]; //Surprisingly, this works!
	end 
endmodule


module decoder24(input[1:0]in,output reg[3:0]out);
	always@(in)
	begin
		out <= (4'b0001 <<< in); // I love code golf; this simulated fine btw
	end
endmodule

module parity_detect(input[2:0]a,output even);
	wire p1,p2,p3,p4;
	assign even = (p1 | p2) | (p3 | p4);
	assign p1 = ~a[2] & ~a[1] & ~a[0];
	assign p2 = ~a[2] & a[1] & a[0];
	assign p3 = a[2] & ~a[1] & a[0];
	assign p4 = a[2] & a[1] & ~a[0];
endmodule

module priority_enc(input[15:0]in,output reg[3:0]code,output reg active);
	integer i =0;
	always@(in)
	begin
		code =0;
		active =0;
		for (i=15; i>=0; i=i-1)
        if (in[i]) code = i;
		  if(in>0) active = 1'b1;
	end 
endmodule