wave add / -radix hex

isim force add Clk 1 -time 0 -value 0 -time 5ns -repeat 10ns
isim force add SCupdate 0 -time 0 -value 1 -time 150ns
isim force add SCin 1001100110011001 -time 0 -value 0000100001100001 -time 100 ns -value 1001000000001000 -time 200 ns -value 0000011110010000 -time 250ns -value 0000100000000000 -time 300ns -value 0000010101110011 -time 350ns -value 0111000000000000 -time 480ns
isim force add reset 1 -time 0 -value 0 -time 40ns -value 1 -time 400ns -value 0 -time 440ns
isim force add BESTSCORE 0 -time 0 -value 1 -time 50ns -value 0 -time 120ns -value 1 -time 220ns -value 0 -time 240ns -value 1 -time 260ns -value 0 -time 280ns -value 1 -time 500ns

run 2000ns