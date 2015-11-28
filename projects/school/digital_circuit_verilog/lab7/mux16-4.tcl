wave add / -radix hex

#just a MUX simulation
isim force add Adrr 00 -time 0 -value 01 -time 10ns -value 10 -time 20ns -value 11 -time 30ns
isim force add Reg_3 1111 -time 0
isim force add Reg_2 1110 -time 0
isim force add Reg_1 1101 -time 0
isim force add Reg_0 1011 -time 0

run 40ns