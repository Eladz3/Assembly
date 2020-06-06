#########################################################################################
# Created By: Zohar, Elad                                                               #
#             ezohar                                                                    #
#             16 November, 2019                                                         #
#                                                                                       #
# Assignment: Lab 4: Sorting Floats                                                     #
#             CSE 012, Computer Systems and Assembly Language                           #
#             UC Santa Cruz, Fall 2019                                                  #
#                                                                                       #
# Description: This program is designed to sort 3 IEEE numbers and print them in IEEE   #
#		and decimal format                                          	            #
# Notes: This program runs in the MARS IDE                                              #
#########################################################################################

# REGISTERS USED ------------------------------------------------------------------
# $t0  = offset to reach word value in array "table"
# $t1  = word value retrieved from table 
# $t2  = tells $t1 how many bits to shift over before adding to sum ($s0, $s1, $s2)
# $t3  = address of "table"
# $t9  = store address of desired part of the string
# $s0  = first stored integer value. Then receives smallest value
# $s1  = second stored integer value. Then receives middle value
# $s2  = third stored integer value. Then receives largest value
# $f0  = first stored float value. Then sorts smallest value
# $f1  = second stored float value. Then sorts middle value
# $f2  = third stored float value. Then sorts largest value
# $f3  = temporary register used for swapping
# $v0  = to define syscall commands
# $a0  = to define string or hex output
# $a1  = to store string from Program Arguments
# $f12 = to define float output
#
# PSEUDOCODE ----------------------------------------------------------------------
# 
# --------- FIRST LOOP -----------
# $t2 = 28
# $t3 = address of table
# $t9 = primary address of "Program Arguments" line
# while $t2 != -4
# {
#        $t0 = hex value of 3rd character $t9
#        $t0 = $t0 - 48
#        $t0 = $t0 * 4
#        $t0 = $t0 + $t3
#        $t1 = word in address $t0
#        shift $t1 left by $t2 bits
#        $s0 = $s0 + $t1
#        $t2 = $t2 - 4
#        move to next character in $t9
# }
# 
# --------- SECOND LOOP ----------
# $t2 = 28
# $t9 = secondary address of "Program Arguments" line
# while $t2 != -4
# {
#        $t0 = hex value of 3rd character of $t9
#        $t0 = $t0 - 48
#        $t0 = $t0 * 4
#        $t0 = $t0 + $t3
#        $t1 = word in address $t0
#        shift $t1 left by $t2 bits
#        $s1 = $s1 + $t1
#        $t2 = $t2 - 4
#        move to next character in $t9
# }
# 
# --------- THIRD LOOP -----------
# $t2 = 28
# $t9 = third address of "Program Arguments" line
# while $t2 != -4
# {
#        $t0 = hex value of 3rd character of $t9
#        $t0 = $t0 - 48
#        $t0 = $t0 * 4
#        $t0 = $t0 + $t3
#        $t1 = word in address $t0
#        shift $t1 left by $t2 bits
#        $s2 = $s2 + $t1
#        $t2 = $t2 - 4
#        move to next character in $t9
# }
# 
# ------------ SORT --------------
# $f0 = $s0
# $f1 = $s1
# $f2 = $s2
# 
# if $f0 is greater than $f1
#        swap $f0 and $f1
# if $f1 is greater than $f2
#        swap $f1 and $f2
# if $f0 is greater than $f1
#        swap $f0 and $f1
# 
# $s0 = $f0
# $s1 = $f1
# $s2 = $f2
# 
# ------------ PRINT -------------
# print args statement
# print string in the first address of $a1
# print string in the second address of $a1
# print string in the third address of $a1
# 
# print sort1 statement
# print hex integer from $s0
# print hex integer from $s1
# print hex integer from $s2
#
# print sort2 statement
# print float from $f0
# print float from $f1
# print float from $f2
#
# --------------END---------------
# end program cleanly

.data
        args:         .asciiz "Program arguments:\n"
        sort1:        .asciiz "Sorted values (IEEE 754 single precision floating point format):\n"
        sort2:        .asciiz "Sorted values (decimal):\n"
        space:        .asciiz " "
        newL:         .asciiz "\n"
        table:        .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 10, 11, 12, 13, 14, 15

.text
CONVERT1:                                        # Converts first value from string to hex integer
        li $t2, 28
        la $t3, table
        lw $t9, ($a1)

        LOOP1:                                   # Loop that does the actual interpretation of the string
                beq $t2, -4, CONVERT2            # Use $t2 as a sort of counter to create a while loop
                lb $t0, 2($t9)
                addi $t0, $t0, -48
                mul $t0, $t0, 4
                add  $t0, $t0, $t3
                lw $t1, ($t0)
                sllv $t1, $t1, $t2
                add $s0, $s0, $t1
                addi $t2, $t2, -4
                addi $t9, $t9, 1
                j LOOP1

CONVERT2:                                        # Converts second value from string to hex integer
        li $t2, 28                               
        lw $t9, 4($a1)

        LOOP2:                                   # Loop that does the actual interpretation of the string
                beq $t2, -4, CONVERT3
                lb $t0, 2($t9)
                addi $t0, $t0, -48
                mul $t0, $t0, 4
                add  $t0, $t0, $t3
                lw $t1, ($t0)
                sllv $t1, $t1, $t2
                add $s1, $s1, $t1
                addi $t2, $t2, -4
                addi $t9, $t9, 1
                j LOOP2

CONVERT3:                                        # Converts third value from string to hex integer
        li $t2, 28
        lw $t9, 8($a1)

        LOOP3:
                beq $t2, -4, SORT                # Loop that does the actual interpretation of the string
                lb $t0, 2($t9)
                addi $t0, $t0, -48
                mul $t0, $t0, 4
                add  $t0, $t0, $t3
                lw $t1, ($t0)
                sllv $t1, $t1, $t2
                add $s2, $s2, $t1
                addi $t2, $t2, -4
                addi $t9, $t9, 1
                j LOOP3

SORT:                                            # Sorts the float values and then returns them to integer registers
        mtc1 $s0, $f0
        mtc1 $s1, $f1
        mtc1 $s2, $f2
        
        FIRST:                                   # if $f0 > $f1 then flip, else continue
                c.lt.s $f0, $f1
                bc1t NEXT1
                mov.s $f4, $f0
                mov.s $f0, $f1
                mov.s $f1, $f4
        NEXT1:                                   # if $f1 > $f2 then flip, else continue
                c.lt.s $f1, $f2
                bc1t NEXT2
                mov.s $f4, $f1
                mov.s $f1, $f2
                mov.s $f2, $f4 
        NEXT2:                                   # if $f0 > $f1 then flip, else continue
                c.lt.s $f0, $f1
                bc1t RETURN
                mov.s $f4, $f0
                mov.s $f0, $f1
                mov.s $f1, $f4
        RETURN:                                  # Return floats to integer registers in correct order
                mfc1 $s0, $f0
                mfc1 $s1, $f1
                mfc1 $s2, $f2
        
PRINT1:                                          # Prints inputs user entered in original order
        li $v0, 4
        la $a0, args
        syscall
	
        lw $a0, ($a1) 
        syscall
	
        la $a0, space
        syscall
	
        lw $a0, 4($a1)        
        syscall
	 
        la $a0, space
        syscall
	
        lw $a0, 8($a1)
        syscall
	
        la $a0, newL
        syscall
        syscall

PRINT2:                                          # Prints the sorted IEEE values in hex
        li $v0, 4
        la $a0, sort1
        syscall
        
        li $v0, 34
        la $a0, ($s0)
        syscall
        
        li $v0, 4
        la $a0, space
        syscall
	
        li $v0, 34
        la $a0, ($s1)
        syscall
        
        li $v0, 4
        la $a0, space
        syscall
        
        li $v0, 34
        la $a0, ($s2)
        syscall
        
        li $v0 4
        la $a0, newL 
        syscall
        syscall
	
PRINT3:                                          # Prints the floats in sorted order
        li $v0, 4
        la $a0, sort2
        syscall
        
        li $v0, 2
        mov.s $f12, $f0
        syscall
        
        li $v0, 4
        la $a0, space
        syscall
	
        li $v0, 2
        mov.s $f12, $f1
        syscall
        
        li $v0, 4
        la $a0, space 
        syscall
        
        li $v0, 2
        mov.s $f12, $f2
        syscall

END:                                             # Ends program cleanly
        li $v0 4
        la $a0, newL
        syscall
	
        li $v0, 10
        syscall
	
	
	


