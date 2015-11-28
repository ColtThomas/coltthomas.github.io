wave add / -radix hex

#runs the clock on 10ns intervals
#    input [3:0] Din,
 #   input Write,
  #  input [1:0] Adrr,
   # input Clk, Clr
    #input [15:0] Dout
	 
#this is the clock timer for the simulation:	 
isim force add Clk 0 -time 0 -value 1 -time 10 ns -repeat 20ns

#we will always have the input to be 1111 for Din
isim force add Din 1111 -time 0
 
#now we test the circuit to see if '1111' can be written to the correct register
isim force add Adrr 00 -time 0  -value 01 -time 24ns -value 10 -time 48ns -value 11 -time 72ns -repeat 96ns
isim force add Clr 1 - time 0 -value 0 -time 10ns
isim force add Write 1 - time 0


run 400ns