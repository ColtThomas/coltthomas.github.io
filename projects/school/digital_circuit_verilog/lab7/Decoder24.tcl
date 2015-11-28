wave add / -radix hex

#runs the clock on 10ns intervals


isim force add Adrr 00 -time 0  -value 01 -time 20ns -value 10 -time 40ns -value 11 -time 60ns


run 80ns