wave add / -radix hex

isim force add reset 1 -time 0 -value 0 -time 30ns
isim force add clk 0 -time 0 -value 1 -time 10ns -repeat 20 ns

run 99900ns