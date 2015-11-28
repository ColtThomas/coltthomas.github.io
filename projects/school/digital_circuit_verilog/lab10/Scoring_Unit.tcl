wave add / -radix hex
isim force add BESTSCORE 1 -time 0 -value 0 -time 200ns
isim force add reset 1 -time 0 -value 0 -time 21ns
isim force add SCin 1000000000000000  -time 0 -value 0000000000000010 -time 31ns -value 0000000100000000 -time 61ns -value 0000100100000110 -time 80ns -value 0000100000000110 -time 100ns -value 0000000000000001 -time 400ns
isim force add Clk 0 -time 0 -value 1 -time 10ns -repeat 20 ns
isim force add SCupdate 0 -time 0 -value 1 -time 5ns -value 0 -time 15ns -value 1 -time 25ns -value 0 -time 200ns -value 1 -time 500ns -value 0 -time 520ns

run 800ns