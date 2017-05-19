module param_decoder#(parameter WID = 4)
  (input [WID-1:0] in,
  output reg [2**WID-1:0] out);

  always @ (in)
  begin
    out <= ('b1 <<< sel);
  end
endmodule
