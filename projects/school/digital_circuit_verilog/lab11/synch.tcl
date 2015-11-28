wave add / -radix hex

isim force add en 1 -time 0 -value 0 -time 150ns
isim force add clk 0 -time 0ns -value 1 -time 5ns -repeat 10ns
isim force add d 1 -time 0ns -value 0 -time 26ns -value 1 -time 30ns -value 0 -time 44ns -value 1 -time 70ns -value 0 -time 150ns

run 200ns