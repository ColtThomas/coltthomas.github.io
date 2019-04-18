#####################################################################
# Program #5: lab5.asm     Programmer: Colt Thomas
# Due Date: 4/22/2019    Course: CS2810
# Date Last Modified: 4/17/19
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
#
# cout << "\nCS2810 - Colt Thomas - Program 5"
# cout << "\nThis program computes the power of a floating point value"
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 2: Prompt the user to enter a floating point value
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# cout << "\n\nEnter a floating point value: "
# cin >> $f0
#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 3: Prompt the user for an integer power for that floating point number
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# cout << "\n\nEnter a power (integer): "
# cin >> $v0
# $t1 = $v0 // Store input power
#
#++++++++++++++++++++++++++++++++++++++++++++++
# Part 4: Use a procedure of your design to
#++++++++++++++++++++++++++++++++++++++++++++++
#
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
#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 5: Repeat steps 3 through 5 as long as the user desires to continue
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# cout << "Continue? (y/N): " 
# cin >> $t0
# if($t0=="y" or $t0=="Y") {
#	goto Part2 }	// go back if user indicates "y"
#	// Ignore other chars and go to the end
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 6: Print a farewell message and exit the program gracefully.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# cout << "\nProgram has finished its shenanigans"
#
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $s0: The value N for Fibonacci(N)
# $t0: Loop iterator in routine
# $t1: Contains the power given by user
# $a0: Used to pass addresses and values to syscalls
# $f0: Floating point register that contains input float
# $f1: Computation result ($f0**$t1)
# $f12:Assign float to this register to print it
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
	syscall			# float will be stored at register $f0	
	
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 3: Prompt the user for an integer power for that floating point number
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	li $v0, 4		# print prompt message requesting 
	la $a0, prompt2		# power value
	syscall
	
	li $v0, 5		# service code 1 for reading an integer
	syscall
	move $t1, $v0		# $t1 will be used to store our power value
#++++++++++++++++++++++++++++++++++++++++++++++
# Part 4: Use a procedure of your design to
#++++++++++++++++++++++++++++++++++++++++++++++
#------------------------------------------------------------------
#   4a Compute the floating point value raised to the entered value
#------------------------------------------------------------------
jal power		# Procedure that will compute the power of input float
#------------------------------------------
#   4b Display the result of that operation
#------------------------------------------
	li $v0, 4	# Newline print for clean text
	la $a0, newline
	syscall
	
	li $v0, 2	# Print the initial float given
	mov.s $f12, $f0 # Move user float to $f12 as arg for printing to console
	syscall
	
	li $v0, 4	# Print " to the power of "
	la $a0, result1
	syscall
	
	li $v0, 1	# Print the power input by user
	move $a0, $t1
	syscall

	li $v0, 4	# Print " is "
	la $a0, result2
	syscall

	li $v0, 2	# Print computed result
	mov.s $f12, $f1
	syscall		
	
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Part 5: Repeat steps 3 through 5 as long as the user desires to continue
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	li $v0, 4		# Prompt user to continue
	la $a0, continue
	syscall
	
	
	li $v0, 8		# This immediate saved to $v0 allows a string to be read in after a system call
	la $a0, vString		# First parameter for syscall is the register destination for input string
	li $a1, 2		# Second parameter specifies the input length max (2 in this case, for extra null char)
	syscall
	
	la $s0, vString 	# Grab address of input char to verify user input
	lb $t3, ($s0)		# Loading a single byte (a char) so we can check for a "y" or "Y". Other chars ignored.
	addi $t3, $t3, -89	# ASCII for Y=89; subtract this from input char...
	beqz $t3, loop		# if zero, we have a match and go back to the top
	addi $t3, $t3, -32	# ASCII for y=121=89+32; subtract 32 to check for "y"
	beqz $t3, loop		# if zero, we have a match and go back to the top
		
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
## floating point number, result returned in register $v0.         ##
#+-----------------------------------------------------------------+#
#####################################################################
power:
	li $t0 1		# init for loop iterator
	mov.s $f1, $f0		# $f1 to contain power result
begin:				# For loop; multiply float by itself by $t1 times (power)
	bge $t0, $t1, endpower	# Iterator starts at 1, and branches when it reaches $t1
	mul.s $f1, $f1, $f0	# Multiply float by itself, since MIPS doesn't have power operator
	addi $t0, $t0, 1	# increment by 1
	j begin			# loop
endpower:	
	jr $ra			# end routine; jump to return address
