#####################################################################
# Program #4: lab4.asm     Programmer: Colt Thomas
# DERPAAGDSJASDG
# Due Date: 4/9/19         Course: CS2810
# Date Last Modified: 4/5
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
# // Arrays
# version = ["Layer 3","Layer 2", "Layer 1"]
# rates = [0,0,0 ... 64,64] // This will store a bitrate index array (with values divided by 8)
#
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
#
# Array index prep
# $s0 = ~$s0 // Invert version bits (only care about last bit; 11 is Version 1, 10/00 is Versions 2/2.5.)
# $s1 = ~$s1 // Invert the layer
# $s0 = $s0 & 0x3 // mask for the two bits we want
# $s1 = $s1 & 0x3 // mask for the two bits we want
# $s3 = $s0	// $s3 will combine the version and layer bits to make array index
# $s3 << 2	// make room for layer bits
# $s3 = $s3 & $s1 // concatenate layer bits onto index register
# $s3 << 2	// multiply value by 4 (shift left 2) to increment along the row of our 2d array
#
# Index prep results in the following increment
# 1111 -> 0000 Version 1 Layer 1
# 1110 -> 0001 Version 1 Layer 2
# etc...
# X010 -> 0101 Version 2/2.5 Layer 2
#
# $s2 = 24*$s2 // To iterate down columns, multiply the index by 24
# $s3 = $s3 + $s2 // Create the final bitrate index access value
# rates[$s3] << 3 // Shift left by 3 to multiply by 8. The entire array was divided by 8 to save memory.

#
# 4 - Display the MP3 version, layer and bit rate as appropriately labeled strings
# cout << "MPEG Version " << $s2 << endl;
# cout << "Layer " << layer[$s1] << endl;
# cout << "Bit Rate: " << rates[$s3] << endl; 
#
#
#
# 5 - Print a farewell message and exit the program gracefully.
# cout << "\n\nEnd of Program\n"
######################################################################
# Register Usage:
# $v0: Used for input and output of values
# $t0: Used to store user input MP3 Hex value (both pre and post hex conversion)
# $t1: General purpose register used for incrementing
# $a0: Used to pass addresses and values to syscalls
# $s0: Integer representation of the MP3 header   
# $s1: Stores the bits representing the MP3 Layer
# $s2: Stores the bits representing the MP Version
# $s3: Used to access bitrate index array value 
######################################################################
	.data              # Data declaration section
# Entries here are <label>:  <type>   <value>
welcome: .asciiz "\nCS2810 - Colt Thomas - Program 4"
description: .asciiz "\nThis program decodes the 32-bit MP3 header file to show the version, layer and bit rate to the user"
prompt:  .asciiz "\n\nEnter the MP3 header: "
debug: .asciiz "\nDebug result: "

# Bitrate index array. Contains bit rates given MP3 version and layer. Added a 6th column since the 5th column
# is valid for both layer 2 and layer 3. Makes for easier indexing (+24 to go down coulmn by 1, +4 to increment row)
# NOTE: Values divided by 8 to save memory
rates: .word  0,0,0,0,0,0,	# 0 represents a FREE bitrate index
              4,4,4,4,1,1,
              8,6,5,6,2,2,
              12,7,6,7,3,3,
              16,8,7,8,4,4,
              20,10,8,10,5,5,
              24,12,10,12,6,6,
              28,14,12,14,7,7,
              32,16,14,16,8,8,
              36,20,16,18,10,10,
              40,24,20,20,12,12,
              44,28,24,22,14,14,
              48,32,28,24,16,16,
              52,40,32,28,18,18,
              56,48,40,32,20,20,
              64,64,64,64,64,64	# 64 represents a BAD bitrate index

result: .asciiz "\nResult: "
#comma: .asciiz ","

free: .asciiz "Free\n"
bad: .asciiz "Bad\n"

versionTxt: .asciiz "\nMPEG Version "
version:  	.asciiz "1"
		.asciiz "2"
		.asciiz "2.5"
layerTxt: .asciiz "\nLayer "
layer:	.asciiz "I"
	.asciiz "II"
	.asciiz "III"
rateTxt: .asciiz "\nBit Rate: "
bye: .asciiz "\n\nEnd of Program\n"
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
	#li $v0, 4          # Get ready to label result
	#la $a0, mesg1      
        #syscall
        #li $v0, 1
        #move $a0, $t0
        #syscall
	#li $v0, 4          # Get ready to label result
	#la $a0, mesg2      
        #syscall

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
	#li $v0, 4          
	#la $a0, debug
        #syscall
        
        #li $v0, 1
        #move $a0, $s2
        #syscall
	#------------------Debug-----------------------------
             
# 4 - Display the MP3 version, layer and bit rate as appropriately labeled strings
	
	# Prepare array index value
	nor $s0, $s0, $s0	# Invert the version bits with NOR
	nor $s1, $s1, $s1	# Invert the layer bits with NOR
	andi $s0, $s0, 3	# bitmask for last two bits
	andi $s1, $s1, 3 	# bitmask for last two bits
	move $s3, $s0		# $s3 will combine the version and layer bits to make array index
	sll $s3, $s3, 2		# shifting 2 to make room for layer bits
	or $s3, $s3, $s1	# merge the layer bits onto index register
	sll $s3, $s3, 2		# multiply value by 4 to increment along the row of our 2d array
	li $t1, 24		# column incrementer multiply value
	mult $s2, $t1		# multiply bitrate index by 24 to increment down the "columns" of our "2d array"
	mflo $s2		# result in lo
	add $s3, $s3, $s2	# combine registers to get the end result bitrate index value
	
	
         

        
        # Print the MP3 Version
	li $v0, 4          # Syscall to print a string
	la $a0, versionTxt     # We will display the MP3 version
	syscall                     
	                       
	li $v0, 4                                                    	
	la $a0, version		# get the base address for the version strings
	sll $t0, $s0, 1		# version array increments by 2 (half word); take the integer value from $s0
	add $a0, $a0, $t0	# add the base address offset
	syscall                                                                                   
	                                                                                                                                               
	li $v0, 4          # Syscall to print a string
	la $a0, layerTxt     # We will display the MP3 layer
	syscall
	
	li $v0, 4                                                    	
	la $a0, layer		# get the base address for the Layer strings
	sll $t0, $s1, 1		# layer array increments by 2 (half word); take the integer value from $s0
	add $a0, $a0, $t0	# add the base address offset
	syscall  
	                     
	li $v0, 4          # Syscall to print a string
	la $a0, rateTxt     # We will display the MP3 bitrate
	syscall                     

                
      	# Print the Bitrate value (or string)
	la $t1, rates
	add $t1, $t1, $s3	# increment to proper bitrate index address
	lw $a0, 0($t1) 	# byte addressible memory
	sll $a0, $a0, 3	# Bitrate table is divided by 8. Reverse this by shifting left by 3 (mult by 8)
	# check for free or bad bitrate
	li $v0 4	# print a string instead if free bit
	li $t1, 512	# represents a BAD Bitrate
	bge $a0,$t1,badbit	# check for bitrate >= 512 (or 8*64)
	beqz  $a0, freebit	# check for bitrate of 0
	li $v0 1	# otherwise print integer
	j printInt
freebit:
	la $a0, free	#print FREE
	j printInt
badbit:	
	la $a0, bad	#print BAD
printInt:
	syscall                    
                                                                     
 # 5 - Print a farewell message and exit the program gracefully.        
 
 	li $v0, 4       # Syscall to print a string
	la $a0, bye    	# "bye" message
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


	# Print the entire array $t7 as increment
	#li $t7, 0	# initiate incrementer
	#li $v0 1	# syscall param for displaying integer
	#la $t1, rates
	#add $t1, $t1, $s3	# increment to proper bitrate index address
	#lw $a0, 0($t1) 	# byte addressible memory
	#sll $a0, $a0, 3	# Bitrate table is divided by 8. Reverse this by shifting left by 3 (mult by 8)
	#syscall
	#------------------Debug-----------------------------
#while: 
#	bge $t7, 60, endloop
#	addi $t7, $t7, 1	# increment
#	li $v0, 4	# print comma separator
#	la $a0, comma
#	syscall
#	
#	li $v0 1
#	addi $t1, $t1, 4	# increment the array access
#	lw $a0, 0($t1) 	# byte addressible memory
#	syscall
#	j while
#endloop:	



	#------------------Debug-----------------------------
