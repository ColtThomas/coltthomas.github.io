wave add / -radix hex

isim force add Inc 0 -time 0 -value 1 -time 15ns
isim force add Reset 1 - time 0  -value 0 -time 25ns
isim force add Clk 0 -time 0 -value 1 -time 10ns -value 0 -time 20ns -value 1 -time 30ns -value 0 -time 40ns -value 1 -time 50ns -value 0 -time 60ns -value 1 -time 70ns -value 0 -time 80ns
#isim force add Q 00 -time 0 -value 01 -time 10ns -value 10 -time 20ns -value 11 -time 30ns
run 80ns