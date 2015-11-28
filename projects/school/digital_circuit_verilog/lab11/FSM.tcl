wave add / -radix hex

isim force add Clk 0 -time 0 -value 1 -time 5ns -repeat 10ns
isim force add Start 0 -time 0 -value 1 -time 20ns -value 0 -time 40ns -value 1 -time 110ns -value 0 -time 120ns -value 1 -time 180 ns -value 0 -time 200ns
isim force add Stop 0 -time 0 -value 1 -time 140ns -value 0 -time 150ns
isim force add CNTdone 0 -time 0 -value 1 -time 60ns -value 0 -time 100ns -value 1 -time 130ns -value 0 -time 140ns
isim force add MSrollover 0 -time 0 -value 1 -time 80ns -value 0 -time 110ns 
isim force add Reset 1 -time 0 -value 0 -time 20ns -value 1 -time 190ns

run 2000ns