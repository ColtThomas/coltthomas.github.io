wave add / -radix hex

isim force add Clk 0 -time 0 -value 1 -time 1ns -repeat 2ns
isim force add Start 0 -time 0 -value 1 -time 2000ns -value 0 -time 2020ns -value 1 -time 680us -value 0 -time 685us -value 1 -time 1000us -value 0 -time 1001us -value 1 -time 1500us -value 0 -time 1501us -value 1 -time 2000us -value 0 -time 2001us 
isim force add Stop 0 -time 0 -value 1 -time 499us -value 0 -time 501us -value 1 -time 880us -value 0 -time 890us -value 1 -time 1800us -value 0 -time 1801us -value 1 -time 3000us -value 0 -time 3001us
isim force add Reset 1 -time 0 -value 0 -time 20ns -value 1 -time 3100us -value 0 -time 3101us
isim force add BestScore 0 -time 0 -value 1 -time 50ns -value 0 -time 100ns -value 1 -time 600us -value 0 -time 620us -value 1 -time 1900us -value 0 -time 2100us -value 1 -time 2400us -value 0 -time 2600us
run 3999us