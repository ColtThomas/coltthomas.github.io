wave add / -radix hex

isim force add Clk 1 -time 0 -value 0 -time 5ns -repeat 10ns
isim force add CNTstart 1 -time 0 -value 0 -time 45ns -value 1 -time 40000ns -value 0 -time 40020ns
isim force add MSen 0 -time 0 -value 1 -time 50ns -value 0 -time 100ns -value 1 -time 200ns
isim force add Reset 1 -time 0 -value 0 -time 11ns
run 200000ns