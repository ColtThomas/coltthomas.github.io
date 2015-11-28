wave add / -radix hex

isim force add Clk 1 -time 0 -value 0 -time 10ns -repeat 20ns
isim force add MSreset 1 -time 0 -value 0 -time 20ns
isim force add MSen 1 -time 0 

run 10000ms