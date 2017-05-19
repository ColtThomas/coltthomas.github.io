module param_mux #(parameter WID = 4, parameter ADDR_WID = 4)
  (input [(WID*(2**ADDR_WID)-1:0] in , 
   input [ADDR_WID-1:0] sel,
   output [WID-1:0] out);

   assign out = in >> (sel*WID); 
 endmodule
