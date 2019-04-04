#####################################################################
# Program #4: lab4.asm     Programmer: Colt Thomas
# Due Date: 4/9/19         Course: CS2810
# Date Last Modified: 4/3
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
# words = [...bitrate index...]	// will be defined in data segment

#    3b - Extract the MP3 Version, Layer, and Bit-Rate Index from the entered MP# header
#
# $s0 = $t0 >> 19 // Obtain the MPEG Audio Version
# $s1 = $t0 >> 17 // Obtain the Layer description 
# $s2 = $t0 >> 12 // Obtain the Bitrate Index
# $s0 = $t0 & 0x3 // bit mask for the MPEG version
# $s1 = $t0 & 0x3 // bit mask for the Layer
# $s2 = $t0 & 0xf // bit mask for the Bit-Rate Index
# 
#    3c - Retrieve the appropriate value from the array based on the extracted values
# $s1 = $s1 ^ 0xFF // XOR to invert
# version = ["Layer 3","Layer 2", "Layer 1"]
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

debug: .asciiz "\nDebug result: "
#array example for bit rates
rates: .word 0,0,0,0,0,	# 0 represents a FREE bitrate index
              4,4,4,4,1,
              8,6,5,6,2,
              12,7,6,7,3,
              16,8,7,8,4,
              20,10,8,10,5,
              24,12,10,12,6,
              28,14,12,14,7,
              32,16,14,16,8,
              36,20,16,18,10,
              40,24,20,20,12,
              44,28,24,22,14,
              48,32,28,24,16,
              52,40,32,28,18,
              56,48,40,32,20
              64,64,64,64,64	# 64 represents a BAD bitrate index
          #         01234567890123456789012
versions: .asciiz "Layer 3 Layer 2 Layer 1"
result: .asciiz "\nResult: "
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

# Part 2 - Prompt the user to enter the hexadecimal value of an MP3 file header	
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

# Part 3 - Use the decoding information for MP3 file headers to determine the bit rate used in recording 

	# -------------- MP3 header format -----------------
	#	AAAAAAAA AAABBCCD EEEEFFGH IIJJKLMM
	# A - Frame Sync
	# B - MPEG Audio Version ID
	# C - Layer Description
	# D - Protection Bit
	# E - Bitrate Index
	# F - Sampling Rate Frequency Index
	# G - Padding Bit
	# H - Private Bit
	# I - Channel Mode
	# J - Mode Extension
	# K - Copyright
	# L - Original
	# M - Emphasis
	# ---------------------------------------------------

	# shift right by 16 bits in preparation for bit mask
	srl $s0, $t0, 19 # AAAAAAAA AAABBCCD EEEEFFGH IIJJKLMM  ->  00000000 00000000 000AAAAA AAAAAABB
	srl $s1, $t0, 17 # AAAAAAAA AAABBCCD EEEEFFGH IIJJKLMM  ->  00000000 00000000 0AAAAAAA AAAABBCC 
	srl $s2, $t0, 12 # AAAAAAAA AAABBCCD EEEEFFGH IIJJKLMM  ->  00000000 0000AAAA AAAAAAAB BCCDEEEE 

	andi $s0, $s0, 3 # Bit mask for the MPEG Audio Version
	andi $s1, $s1, 3 # Bit mask for the Layer Description
	andi $s2, $s2, 15 # Bit mask for the Bitrate Index
	
	
	#------------------Debug-----------------------------
	li $v0, 4          
	la $a0, debug
        syscall
        
        li $v0, 1
        move $a0, $s2
        syscall
	#------------------Debug-----------------------------
             
# 4 - Display the MP3 version, layer and bit rate as appropriately labeled strings
	li $v0, 4          # Get ready to label result
	la $a0, result
        syscall
	
	li $v0 1
	la $t1, rates
	lw $a0, 20($t1) 	# byte addressible memory
	syscall
	#li $v0 1
	addi $t1, $t1, 20	# increment the array access
	lw $a0, 20($t1) 	# byte addressible memory
	syscall
	
        #li $v0, 11          	# print char syscall
	#la $a1, month		# store our month string to $a1
	#add $a1, $a1, $s2 	# print first char of the month    
	#lbu $a0, ($a1)		# load our first byte into the $a0 register as argument
	#syscall                     
	#addi $a1, $a1, 1 	# print second char of the month by incrementing our index    
	#lbu $a0, ($a1)
	#syscall               
                             
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
