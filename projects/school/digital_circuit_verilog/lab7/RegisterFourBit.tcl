wave add / -radix hex

#runs the clock on 10ns intervals

isim force add Clk 0 -time 0 -value 1 -time 10 ns -repeat 20ns

isim force add Clr 1 -time 0  -value 0 -time 20ns
isim force add Din 1111 -time 0 -value 1100 -time 205ns
isim force add Write 0 -time 0  -value 1 -time 64ns -value 0 -time 124ns -value 1 -time 205ns 


run 400ns