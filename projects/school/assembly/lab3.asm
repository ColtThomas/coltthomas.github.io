#####################################################################
# Program #3: coltthomas_prog3.asm     Programmer: Colt Thomas
# Due Date: 3/19/19    Course: CS2810
# Date Last Modified: 3/18/19
#####################################################################
# Functional Description:
# <Give a short English description of your program.  For example:
#  This program accepts an integer value and computes and displays
#  the Fibonacci number for that integer value. >
#####################################################################
# Pseudocode:

# Task 1 - Print a welcome message that include: your name, a title, and a brief description of the program.
# cout << "\nProgram 3 - Bit Masking"
# cout << "\ncode produced by Colt Thomas"
# cout << "\nThis program will take a hexadecimal date from a FAT16 directory and convert to a string representation"

# Task 2 - Prompt the user to enter the hexadecimal date from a FAT16 directory entry
# cout << "\nPlease enter a Hex number: "
# cin >> $t0

# Task 3 - Use the decoding information for the FAT filesystem to convert this hexadecimal value to a string representation of the date for the file table entry. 

# Convert to big-endian
# $t0 = readhex($t0) // The provided function will convert the input from a string to an integer
# savebyte($t0,$sp,1) // save the last byte of $t0 to the stack. Note the offset of 1
# $t0 >> 8	// right shift by a byte
# savebyte($t0,$sp,1) // save the last byte of $t0 to the stack. The offset of 0 puts the hex into big-endian
# $s4 = loadword($sp,0) // load the reversed word at the stack pointer address

# Decode the month, day and year
#$s0 = readhex($s4) // get the integer value of input hex string
#$t1 = 0xFE00 // Mask for the date
#$s1 = $s0 & $t1 // Get the year

#$t1 = 0x01E0 // Mask for the month
#$s2 = $s0 & $t1 // Get the month (integer value)

#$t1 = 0x001F // Mask for the day
#$s3 = $s0 & $t1 // Get the day

# Task 4 - Display the date corresponding to the hexadecimal value as a string
# cout << "The date of the entered value is: " << $s2 << " " << $s3 << ", " << $s1

# Task 5 - Print a farewell message and exit the program gracefully.
# cout << "It is now safe to turn off your computer"
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $a0: Used to pass addresses and values to syscalls
# $s0: Saves the integer value of input hex value
# $s1: Saved year
# $s2: Saved month
# $s3: Saved day
# $s4: big-endian conversion
# $t0: Stores user input Hex value
# $t1: Temp register for bit masking
######################################################################
		.data              # Data declaration section
welcome1: 	.asciiz 	"\nProgram 3 - Bit Masking"
welcome2: 	.asciiz 	"\nCode produced by Colt Thomas"
welcome3: 	.asciiz 	"\nThis program will take a hexadecimal date from a FAT16 directory and convert to a string representation"
prompt:  	.asciiz 	"\nPlease enter a Hex number: "
mesg1:		.asciiz 	"\nThe entered value in decimal is: "
mesg2:  	.asciiz 	"\n\n"
result1: 	.asciiz 	"\nThe date of the entered value is: "
blank: 		.asciiz 		" "
comma: 		.asciiz 		", "
#			 	 01234567890123456789012345678901234567890123456
month: 		.asciiz 	"Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
bye: 		.asciiz 	"\nIt is now safe to turn off your computer"

		.text              # Executable code follows
main:
# Task 1 - Print a welcome message that include: your name, a title, and a brief description of the program.

	li $v0, 4          	# Syscall to print a string
	la $a0, welcome1     	# We will display the welcome message (x3 strings)
	syscall
	li $v0, 4          
	la $a0, welcome2     
	syscall
	li $v0, 4         
	la $a0, welcome3  
	syscall
	
# Task 2 - Prompt the user to enter the hexadecimal date from a FAT16 directory entry
			
	li $v0, 4          	# Syscall to print a string
	la $a0, prompt     	# We will display the prompt
	syscall

# Task 3 - Use the decoding information for the FAT filesystem to convert this hexadecimal value to a string representation of the date for the file table entry. 
		
	jal readhex        	# call the subroutine to read a hex integer
	
	move $t0, $v0      	# Save the result of reading a hex
	li $v0, 4          	# Get ready to label result
	la $a0, mesg1      
        syscall
        li $v0, 1
        move $a0, $t0
        syscall
	li $v0, 4          	# Get ready to label result
	la $a0, mesg2      
        syscall

# Convert to big-endian
	sb $t0, 1($sp)		# Save the first byte to the stack pointer offset by 1 byte 	$t0 (0x0000AABB) -> $sp (0x0000BB00)
	srl $t0, $t0, 8		# Shift right to discard saved byte				$t0 (0x000000AA)
	sb $t0, 0($sp)		# Save the next byte at the stack pointer 			$t0 (0x000000AA) -> $sp (0x0000BBAA)
	lw $s4, 0($sp) 		# Load the word stored at the stack pointer 

# Decode the month, day and year
	andi $s1, $s4, 65024 	# Year bit mask: 0xFE00
	srl $s1, $s1, 9		# Year shift correction
	addi $s1, $s1, 1980	# FAT 16 year date increments from 1980, so we add 1980 
	
	andi $s2, $s4, 480 	# Month bit mask: 0x01E0
	srl $s2, $s2, 5		# Month shift correction
	addi $s2, $s2, -1	# We generate the starting index of zero-based char array to get the correct month
				# 01234567890 ... 48   -index number
				# Jan Feb Mar ... D.ec -month
	sll $s2, $s2, 2		# Multiply by 4 by bit shifting

	andi $s3, $s4,31 	# Day bit mask: 0x001F

	
# Task 4 - Display the date corresponding to the hexadecimal value as a string	
	
	li $v0, 4          	# Begin printing the date result
	la $a0, result1     
	syscall
	
	li $v0, 11          	# print char syscall
	la $a1, month		# store our month string to $a1
	add $a1, $a1, $s2 	# print first char of the month    
	lbu $a0, ($a1)		# load our first byte into the $a0 register as argument
	syscall
	addi $a1, $a1, 1 	# print second char of the month by incrementing our index    
	lbu $a0, ($a1)
	syscall
	addi $a1, $a1, 1 	# print third char of the month by incrementing our   
	lbu $a0, ($a1)
	syscall
	
	li $v0, 4          	# print " " 
	la $a0, blank     
	syscall
	
	li $v0, 1          
	la $a0, ($s3)		# print the day     
	syscall
	
	li $v0, 4          	# print ", "
	la $a0, comma     
	syscall
	
	li $v0, 1          
	la $a0, ($s1)		# print the year     
	syscall
	
	li $v0, 4  		# print farewell message       
	la $a0, bye  
	syscall

	li $v0, 10          	# terminate program run and
	syscall                	# return control to system


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
