#####################################################################
# Program #4: lab4.asm     Programmer: Colt Thomas
# Due Date: <Due Date>    Course: CS2810
# Date Last Modified: <Date of Last Modification>
#####################################################################
# Functional Description:
# This program will prompt the user for a hexadecimal value MP3
# file header, and afterwards return the MP3 version, layer, and 
# bit-rate index from the entered MP3 header
#
# Specific Tasks:
# 1 - Print a welcome message that include: your name, a title, and a brief description of the program.
# 2 - Prompt the user to enter the hexadecimal value of an MP3 file header
# 3 - Use the decoding information for MP3 file headers to determine the bit rate used in recording 
# the MP3 file. 
#    3a - Store the bit rate table as a 2-dimensional array
#    3b - Extract the MP3 Version, Layer, and Bit-Rate Index from the entered MP# header
#    3c - Retrieve the appropriate value from the array based on the extracted values
# 4 - Display the MP3 version, layer and bit rate as appropriately labeled strings
# 5 - Print a farewell message and exit the program gracefully.
#####################################################################
# Pseudocode:
# 1 - Print a welcome message that include: your name, a title, and a brief description of the program.
# cout << "CS2810 - Colt Thomas - Program 4" << endl
# cout << "This program decodes the 32-bit MP3 header file to show the version, layer and bit rate to the user"
# 2 - Prompt the user to enter the hexadecimal value of an MP3 file header
# cout << "Enter the MP3 header: "
# $t0 << cin
# 3 - Use the decoding information for MP3 file headers to determine the bit rate used in recording 
# the MP3 file. 
# $t0 = readhex($t0) // Takes the input chars and converts hex-like input to integer value
# 
#    3a - Store the bit rate table as a 2-dimensional array
#    3b - Extract the MP3 Version, Layer, and Bit-Rate Index from the entered MP# header
# $s0 = $t0 & 0x00180000 // bit mask for the MPEG version
# $s1 = $t0 & 0x00060000 // bit mask for the Layer
# $s2 = $t0 & 0x00 // bit mask for the Bit-Rate Index
# 
#
#
#    3c - Retrieve the appropriate value from the array based on the extracted values
# 4 - Display the MP3 version, layer and bit rate as appropriately labeled strings
# 5 - Print a farewell message and exit the program gracefully.
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $t0: Used to store user input MP3 Hex value (both pre and post hex conversion)
# $a0: Used to pass addresses and values to syscalls
# $s0: Integer representation of the MP3 header   
######################################################################
	.data              # Data declaration section
# Entries here are <label>:  <type>   <value>
welcome: .asciiz "\nCS2810 - Colt Thomas - Program 4"
description: .asciiz "\nThis program decodes the 32-bit MP3 header file to show the version, layer and bit rate to the user"
prompt:  .asciiz "\nEnter the MP3 header: "
mesg1:	.asciiz "\nThe entered value in decimal is: "
mesg2:  .asciiz "\n\n"

	.text              # Executable code follows
main:
# Include your code here

# Part 1 - Print a welcome message that include: your name, a title, and a brief description of the program.
	li $v0, 4          # Syscall to print a string
	la $a0, welcome     # We will display the welcome message
	syscall
	
	li $v0, 4          # Syscall to print a string
	la $a0, description     # We will display the description
	syscall

# 2 - Prompt the user to enter the hexadecimal value of an MP3 file header	
	li $v0, 4          # Syscall to print a string
	la $a0, prompt     # We will display the prompt
	syscall
	
	jal readhex        # call the subroutine to read a hex integer
	
	# Displays the $t0 value (user input hex to int value)
	move $t0, $v0      # Save the result of reading a hex
	li $v0, 4          # Get ready to label result
	la $a0, mesg1      
        syscall
        li $v0, 1
        move $a0, $t0
        syscall
	li $v0, 4          # Get ready to label result
	la $a0, mesg2      
        syscall

	

	li    $v0, 10          # terminate program run and
	syscall                # return control to system


# END OF MAIN PROGRAM # Subroutines are below #######################

#####################################################################
## The subroutine readhex is provided to read in a Hex number up   ##
## to 8 digits long, producing 32-bit integer result, returned in  ##
## register $v0. Non-hex values terminate the subroutine           ##
#+-----------------------------------------------------------------+#
## This subroutine changes the values of $v0                       ##
#####################################################################
readhex:   # Read a Hex value
	addi $sp, $sp, -8   # make room for 2 registers on the stack
	sw   $t0, 4($sp)     # save $t0 on stack, used to accum6ulate
	sw   $t1, 0($sp)     # save $t1 on stack, used to count
	li   $t1, 8          # We will read up to 8 characters
	move $t0, $zero      # initialize hex value to zero
rdachr: li   $v0, 12         # Beginning of loop to read a character
	syscall              # syscall 12 reads a character into $v0
	blt  $v0, 32, hexend # Read a non-printable character so done
	blt  $v0, 48, hexend # Non-hex value entered (special char)
	blt  $v0, 58, ddigit # A digit 0-9 was entered
	blt  $v0, 65, hexend # A special character was entered so done
	blt  $v0, 71, uphex  # A hex A-F was entered so handle that
	blt  $v0, 97, hexend # A non-hex letter or special, so done
	blt  $v0, 103, lhex  # A hex a-f was entered so handle that
	j    hexend          # Not a hex so finish up
ddigit:	addi $v0, $v0, -48   # Subtract the ASCII value of 0 to get num
        j    digitdone       # value to OR is now in $v0 so OR
uphex:	addi $v0, $v0, -55   # Subtract 65 and add 10 so A==10
	j    digitdone       # hex value determined, so put in 
lhex:	addi $v0, $v0, -87   # Subtract 97 and add 10 so a==10
digitdone:
	sll  $t0, $t0, 4     # New value will fill the 4 low order bits
        or   $t0, $t0, $v0   # Bitwise OR $t0 and $v0 to enter hex digit
        addi $t1, $t1, -1    # Count down for digits read at zero, done
        beqz $t1, hexend     # If $t0 is zero, we've read 8 hex digits
        j    rdachr          # Loop back to read the next character
hexend:	move $v0, $t0        # Set $v0 to the return value
	lw   $t1, 0($sp)     # pop $t1 from the stack
	lw   $t0, 4($sp)     # pop $t0 from the stack
	addi $sp, $sp, 8     # free the stack by changing the stack pointer
	jr   $ra             # Return to where called
