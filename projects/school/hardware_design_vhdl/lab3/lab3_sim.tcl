# initialize the simulator with the "restart" command
restart

#signals are sw and btn
put sw 00000000
put btn 0000
run 100 ns

#check the buttons to see that btn 3 and 2 have the right priority
put btn 1000
run 100 ns
put btn 1100
run 100 ns
put btn 0100
run 100 ns
put btn 1011
run 100 ns
put btn 0100
run 100 ns

#now we test buttons 1 and 2.  Test value is F2
put sw 11110010 

put btn 0000
run 100 ns

put btn 0001
run 100 ns

put btn 0010
run 100 ns

put btn 0011
run 100 ns