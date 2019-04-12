#####################################################################
# Program #5: lab5.asm     Programmer: Colt Thomas
# Due Date: 4/22/2019    Course: CS2810
# Date Last Modified: <Date of Last Modification>
#####################################################################
# Functional Description:
# This program accepts a floating point value, and an integer power
# for that floating point number. The power is then calculated and 
# displayed
#####################################################################
# Pseudocode:
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 1: Print a welcome message that include: your name, a title, 
# and a brief description of the program.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# cout << "\nCS2810 - Colt Thomas - Program 5"
# cout << "\nThis program computes the power of a floating point value"
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 2: Prompt the user to enter a floating point value
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# cout << "\n\nEnter a floating point value: "
# cin >> $f0
#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 3: Prompt the user for an integer power for that floating point number
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# cout << "\n\nEnter a power (integer): "
# cin >> $v0
# $t1 = $v0 // Store input power
#++++++++++++++++++++++++++++++++++++++++++++++
# Part 4: Use a procedure of your design to
#++++++++++++++++++++++++++++++++++++++++++++++
# $f1 = power($f0) 
#	|------------------------------------------------------------------
#   	|4a Compute the floating point value raised to the entered value
#	|------------------------------------------------------------------
# 	| $f1 = $f0	// $f1 to contain output float
# 	| for (i=0; i < $t1 ; i++)
#     	|     $f1 = $f1 * $f0
#------------------------------------------
#   4b Display the result of that operation
#------------------------------------------
# cout << $f0 << " to the power of " << $t1 << " is: " << $f1 << endl;
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 5: Repeat steps 3 through 5 as long as the user desires to continue
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# cout << "Continue? (y/N): " 
# cin >> $t0
# if($t0=="y") {
#	goto Part2 }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 6: Print a farewell message and exit the program gracefully.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# cout << "\nProgram has finished its shenanigans"
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $s0: The value N for Fibonacci(N)
# $t0:
# $t1: Contains the power given by user
# $a0: Used to pass addresses and values to syscalls
# $f0: Floating point register that contains input float
# $f1: Computation result ($f0**$t1)
######################################################################
	.data              # Data declaration section
# Entries here are <label>:  <type>   <value>
welcome: .asciiz "\nCS2810 - Colt Thomas - Program 5"
description: .asciiz "\nThis program computes the power of a floating point value"
prompt1: .asciiz "\n\nEnter a floating point value: "
prompt2: .asciiz "\nEnter a power (integer): "
result1: .asciiz " to the power of "
result2: .asciiz " is: "
continue: .asciiz "\nContinue? (y/N): " 
vString:  .space 16
newline: .asciiz "\n"
bye:	 .asciiz "\nProgram has finished its shenanigans"
debug: .asciiz "\nDebug Result: "
derp: .asciiz "\nDerp"
	.text              # Executable code follows
main:
# Include your code here
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 1: Print a welcome message that include: your name, a title, 
# and a brief description of the program.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	li $v0, 4		# print welcome message
	la $a0, welcome
	syscall
	
	li $v0, 4		# print description message
	la $a0, description
	syscall
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 2: Prompt the user to enter a floating point value
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
loop:
	li $v0, 4		# print prompt message requesting 
	la $a0, prompt1		# float value
	syscall
	
	li $v0, 6		# service code 6 for reading a float
	syscall
	#mov.s $t0, $f0		# retrieve float entered from $f0
	
	
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 3: Prompt the user for an integer power for that floating point number
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	li $v0, 4		# print prompt message requesting 
	la $a0, prompt2		# power value
	syscall
	
	li $v0, 5		# service code 1 for reading an integer
	syscall
	move $t1, $v0
#++++++++++++++++++++++++++++++++++++++++++++++
# Part 4: Use a procedure of your design to
#++++++++++++++++++++++++++++++++++++++++++++++
#------------------------------------------------------------------
#   4a Compute the floating point value raised to the entered value
#------------------------------------------------------------------
jal power
#------------------------------------------
#   4b Display the result of that operation
#------------------------------------------
	li $v0, 4	# Newline print
	la $a0, newline
	syscall
	
	li $v0, 2	# Print the initial float
	mov.s $f12, $f0
	syscall
	
	li $v0, 4	# Print " to the power of "
	la $a0, result1
	syscall
	
	li $v0, 1	# Print the power
	move $a0, $t1
	syscall

	li $v0, 4	# Print " is "
	la $a0, result2
	syscall

	li $v0, 2	# Print computed result
	mov.s $f12, $f1
	syscall		
	
# debug #
	#li $v0, 4	
	#la $a0, debug
	#syscall
		
	#li $v0, 2
	#mov.s $f12, $f1
	#syscall
	# end debug #
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 5: Repeat steps 3 through 5 as long as the user desires to continue
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	li $v0, 4	# Prompt user to continue
	la $a0, continue
	syscall
	
	
	li $v0, 8		# This immediate saved to $v0 allows a string to be read in after a system call
	la $a0, vString		# First parameter for syscall is the register destination for input string
	li $a1, 2		# Second parameter specifies the input length max (66 - 2 in this case, for a null and newline)
	syscall
	
	la $s0, vString 	# Grab the char to verify user input
	lb $t3, ($s0)
	addi $t3, $t3, -89	# ASCII for Y=89
	beqz $t3, loop		
	addi $t3, $t3, -32	# ASCII for y=121=89+32
	beqz $t3, loop		
		
		#debug#
	#li $v0, 4	
	#la $a0, debug
	#syscall
	
	#li $v0, 1		# display the input string again
	#move $a0, $t3
	#syscall	
	#la $t3, vString
	#lb $t4, ($t3)
	#li $v0, 1	# Print the power
	#move $a0, $t4
	#syscall
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 6: Print a farewell message and exit the program gracefully.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	li $v0, 4		# print farewell message
	la $a0, bye
	syscall
	
	li    $v0, 10          # terminate program run and
	syscall                # return control to system
# END OF PROGRAM

# PROCEDURES

#####################################################################
## The subroutine power is provided to compute the power of a      ##
## floating point number,   returned in                            ##
## register $v0. Non-hex values terminate the subroutine           ##
#+-----------------------------------------------------------------+#
## This subroutine changes the values of $v0                       ##
#####################################################################
power:
	li $t0 1	# init for loop iterator
	mov.s $f1, $f0	# $f1 to contain power result
begin:	
	bge $t0, $t1, endpower
	mul.s $f1, $f1, $f0
	addi $t0, $t0, 1	# increment
	j begin
endpower:	
	jr $ra
