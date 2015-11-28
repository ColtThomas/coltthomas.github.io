wave add / -radix hex

isim force add Din 0000000000100 -time 0 -value 0000000100000 -time 40ns -value 0000000101000 -time 700ns
isim force add Load 1 -time 0 -value 0 -time 21ns -value 1 -time 40ns -value 0 -time 150ns -value 1 -time 900ns -value 0 -time 1000ns -value 1 -time 1260ns -value 0 -time 1300ns
isim force add EN 0 -time 0 -value 1 -time 22ns -value 0 -time 1200ns -value 1 -time 1300ns
isim force add Clk 0 -time 0 -value 1 -time 5ns -repeat 10 ns


run 2000ns