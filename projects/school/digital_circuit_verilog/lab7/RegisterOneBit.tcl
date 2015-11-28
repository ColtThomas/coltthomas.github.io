wave add / -radix hex

#runs the clock on 10ns intervals

isim force add Clk 0 -time 0 -value 1 -time 10 ns -repeat 20ns

#forces the input data

isim force add Clr 1 -time 0  -value 0 -time 35ns -value 1 -time 186ns
isim force add Din 0 -time 0 -value 1 -time 42ns -value 0 -time 71ns -value 1 -time 124ns -value 0 -time 143ns -value 1 -time 167ns
isim force add Write 0 -time 0  -value 1 -time 44ns -value 0 -time 70ns -value 1 -time 124ns -value 0 -time 200ns


run 220ns


