wave add / -radix hex

isim force add reset 1 -time 20ns -value 0 -time 100ns
isim force add Clk 1 -time 0 -value 0 -time 5ns -repeat 10ns
isim force add D 1000000000000000  -time 0 -value 0000000000000010 -time 31ns -value 0000000100000000 -time 61ns -value 0000100100000110 -time 80ns -value 0000100000000110 -time 100ns
isim force add EN 1 -time 0


run 200ns