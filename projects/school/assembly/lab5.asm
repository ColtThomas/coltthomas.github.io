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
# cin >> $t0
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 3: Prompt the user for an integer power for that floating point number
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++++++++++++++++++++++++++++++++++++++
# Part 4: Use a procedure of your design to
#++++++++++++++++++++++++++++++++++++++++++++++
#------------------------------------------------------------------
#   4a Compute the floating point value raised to the entered value
#------------------------------------------------------------------
#------------------------------------------
#   4b Display the result of that operation
#------------------------------------------
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 5: Repeat steps 3 through 5 as long as the user desires to continue
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 6: Print a farewell message and exit the program gracefully.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# cout << "\nProgram has finished its shenanigans"
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $s0: The value N for Fibonacci(N)
# $t0: Contains floating number value
# $a0: Used to pass addresses and values to syscalls
######################################################################
	.data              # Data declaration section
# Entries here are <label>:  <type>   <value>
welcome: .asciiz "\nCS2810 - Colt Thomas - Program 5"
description: .asciiz "\nThis program computes the power of a floating point value"
prompt1: .asciiz "\n\nEnter a floating point value: "
bye:	 .asciiz "\nProgram has finished its shenanigans"
debug: .asciiz "\nDebug Result: "
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
	li $v0, 4		# print prompt message requesting 
	la $a0, prompt1		# float value
	syscall
	
	li $v0, 6		# service code 6 for reading a float
	syscall
	mov.s $t0, $f0		# retrieve float entered from $f0
	
	# debug #
	li $v0, 4	
	la $a0, debug
	syscall
		
	li $v0, 2
	mov.s $f12, $t0
	syscall
	# end debug #
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 3: Prompt the user for an integer power for that floating point number
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#++++++++++++++++++++++++++++++++++++++++++++++
# Part 4: Use a procedure of your design to
#++++++++++++++++++++++++++++++++++++++++++++++
#------------------------------------------------------------------
#   4a Compute the floating point value raised to the entered value
#------------------------------------------------------------------
#------------------------------------------
#   4b Display the result of that operation
#------------------------------------------
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 5: Repeat steps 3 through 5 as long as the user desires to continue
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 6: Print a farewell message and exit the program gracefully.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	li $v0, 4		# print farewell message
	la $a0, bye
	syscall
	
	li    $v0, 10          # terminate program run and
	syscall                # return control to system
# END OF PROGRAM
