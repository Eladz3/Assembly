#########################################################################################
# Created By: Zohar, Elad                                                               #
#             ezohar                                                                    #
#             8 November, 2019                                                          #
#                                                                                       #
# Assignment: Lab 3: ASCII Tree Forrest                                                 #
#             CSE 012, Computer Systems and Assembly Language                           #
#             UC Santa Cruz, Fall 2019                                                  #
#                                                                                       #
# Description: This program prints a forrest of the users desired quantity and height.  #
#                                                                                       #
# Notes: This program runs in the MARS IDE                                              #
#########################################################################################

# REGISTERS USED ------------------------------------
# $t0 = quantity input
# $t1 = size input
# $t2 = used as a counter for the for loops
# $t3 = used as another counter for the for loops
# $t4 = floor of half of size
# $v0 = to define syscall commands
# $a0 = to define output
# 
# PSEUDOCODE ----------------------------------------
# prompt user for quantity input
# while user input is <= 0
# {
# 	print error message
# 	prompt user for quantity input
# }
# prompt user for size input
# while user input is <= 1
# {
# 	print error message
# 	prompt user for quantity input
# }
# for int i from 0 to quantity
# {
# 	print tree top
# }
# for int i from 0 to (size - 1)
# {
# 	for int j from 0 to quantity
# 	{	
# 		print tree green
# 	}
# }
# for int i from 0 to quantity
# {
# 	print tree branch
# }
# for int i from 0 to (floor of size/2)
# {
# 	for int j from 0 to quantity
# 	{	
# 		print tree trunk
# 	}
# }
# end program

.data
	promptQ: 	.asciiz "Enter the number of trees to print (must be greater than 0): "
	promptSize: 	.asciiz "Enter the size of one tree (must be greater than 1): "
	error: 		.asciiz "Invalid Entry!\n"
	newLine: 	.asciiz "\n"
.text
quantity:	nop
		li 	$v0, 4				# prompt user for number of trees
		la 	$a0, promptQ	
		syscall
	
		li 	$v0, 5				# recieve user input
		syscall
	
		move 	$t0, $v0			# load user input into $t0
		bgtz 	$t0, size			# if $t0 > 0 continue to size
		li 	$v0, 4				# else print error message
		la 	$a0, error
		syscall
		j 	quantity			# return to top of quantity
	
size:		nop
		li 	$v0, 4				# prompt user for size of tree
		la 	$a0, promptSize
		syscall

		li $v0, 5				# recieve user input
		syscall
	
		move $t1, $v0				# load user input into $t1
		addi $t1, $t1, -1			# height of green is one less than size
							# will revert later when finding size of trunk
		bgt $t1, 0, printTop			# if $t1 > 1 continue to print
		li $v0, 4				# else print error message and jump back to the top of quantity
		la $a0, error
		syscall
		j size					# return to top of size

printTop:	nop
		beq $t0, $t2, printGreen		# while counter < quantity print tree top, otherwise 
							# continue to print the tree leaves
		li $v0, 11			
		la $a0, 32				# print " /\   "
		syscall
		la $a0, 47
		syscall
		la $a0, 92
		syscall
		la $a0, 32
		syscall
		la $a0, 32
		syscall
		la $a0, 32
		syscall
	
		addi $t2, $t2, 1			# increment counter
		j printTop				# return to start of printTop
	
printGreen:	nop
		beq $t1, $t3, printBranch		# while 1st counter < size we'll go on to print one line of
							# tree leaves otherwise continue to print the tree branches
		li $v0, 4				# move to new line
		la $a0, newLine
		syscall
	
		move $t2, $zero				# reset 2nd counter
	
		loop1: 	nop
			beq $t0, $t2, cont1		# while 2nd counter < quantity print the leaves,
							# otherwise continue out of this loop
			li $v0, 11	
			la $a0, 47			# print "/  \  "		
			syscall
			la $a0, 32
			syscall
			la $a0, 32
			syscall
			la $a0, 92
			syscall
			la $a0, 32
			syscall
			la $a0, 32
			syscall
		
			addi $t2, $t2, 1		# increment 2nd counter
			j loop1				# go back to top of inner loop
		
		cont1: 	
			addi $t3, $t3, 1		# increment 1st counter
			j printGreen			# return to top of outer loop
	
printBranch:	nop
		li $v0, 4				# move to new line
		la $a0, newLine
		syscall
		
		addi $t1, $t1, 1			# revert size to original input
		move $t2, $zero				# reset counter
		move $t3, $zero				# reset other counter
		
		loop2: 	nop 
			beq $t0, $t2, printTrunk	# while counter < quantity print branch, 
							# otherwise continue to print trunk
			li $v0, 11			# print "----  "
			la $a0, 45
			syscall
			la $a0, 45
			syscall
			la $a0, 45
			syscall
			la $a0, 45
			syscall
			la $a0, 32
			syscall
			la $a0, 32
			syscall
	
			addi $t2, $t2, 1		# increment counter
			j loop2				# return to top of loop
	
printTrunk:	nop
		div $t4, $t1, 2				# $t4 = floor of half of size
		beq $t4, $t3, done			# while 1st counter < trunk size print a line of trunks,
							# otherwise continue to end program
		li $v0, 4				# move to new line
		la $a0, newLine
		syscall
		
		move $t2, $zero				# reset 2nd counter
		
		loop3: 	nop
			beq $t0, $t2, cont2		# while 2nd counter < quantity print trunk, otherwise
							# leave the inner loop
			li $v0, 11			# print " ||   "
			la $a0, 32
			syscall
			la $a0, 124
			syscall
			la $a0, 124
			syscall
			la $a0, 32
			syscall
			la $a0, 32
			syscall
			la $a0, 32
			syscall
			
			addi $t2, $t2, 1		# increment 2nd counter
			j loop3				# return to top of inner loop
		
		cont2: 	addi $t3, $t3, 1		# increment 1st counter
			j printTrunk			# return to top of outer loop
		
done:	nop
	li $v0, 10					# end program cleanly
	syscall

