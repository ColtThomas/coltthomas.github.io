# initialize the simulator with the "restart" command
restart
# initial value for t_switch and t_buttons
put t_switches 00000000
put t_buttons 0000
#start simulation
run 100 ns
#case: button change
put t_switches 10100110
run 100ns

put t_buttons 1000
run 100ns

put t_buttons 0100
run 100ns

put t_buttons 0010
run 100ns

put t_buttons 0001
run 100ns

#now we test priority
put t_buttons 1111
run 100ns

put t_buttons 0111
run 100ns

put t_buttons 0011
run 100ns

put t_buttons 0001
run 100ns

