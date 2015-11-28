wave add / -radix hex

isim force add Digit1 1001 -time 0
isim force add Digit2 1000 -time 0
isim force add Digit3 0111 -time 0
isim force add Digit4 0110 -time 0
isim force add SysClk 0 -time 0 -value 1 -time 10ns -repeat 20ns
isim force add Reset 1 -time 0 -value 0 -time 10ns
isim force add Dp0 0 -time 0
isim force add Dp1 0 -time 0
isim force add Dp2 0 -time 0
isim force add Dp3 0 -time 0

run 200 ns
