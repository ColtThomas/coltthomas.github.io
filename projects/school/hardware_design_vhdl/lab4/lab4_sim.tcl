# initialize the simulator with the "restart" command
restart

isim force add clk 1 -value 0 -time 10 ns -repeat 20 ns
isim force add btn 4 -value 0000 -time 9 ns -value 0001 -time 190 ns -value 0011 -time 290 ns -value 0111 -time 390 ns -value 1111 -time 490 ns 
isim force add sw 8 -value 11110000 -time 0 ns
#isim force add btn 4 -value 0000 -time 0 ns