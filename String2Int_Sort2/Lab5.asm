#------------------------------------------------------------------------
# Created by:  Zohar, Elad
#              ezohar
#              4 December 2019 
#
# Assignment:  Lab 5: Subroutines
#              CSE 12, Computer Systems and Assembly Language
#              UC Santa Cruz, Fall 2019
# 
# Description: Library of subroutines used to convert an array of
#              numerical ASCII strings to ints, sort them, and print
#              them.
# 
# Notes:       This program runs in the MARS IDE
#------------------------------------------------------------------------

.text

j  exit_program                # prevents this file from running
                               # independently (do not remove)

#------------------------------------------------------------------------
# MACROS
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# print new line macro

.macro lab5_print_new_line
    li $v0, 11
    li $a0, 0xA
    syscall
.end_macro


#------------------------------------------------------------------------
# print string

.macro lab5_print_string(%str)

    .data
    string: .asciiz %str

    .text
    li  $v0 4
    la  $a0 string
    syscall
    
.end_macro

#------------------------------------------------------------------------
# add additional macros here

#------------------------------------------------------------------------
# print space macro

.macro lab5_print_space
    li $v0, 11
    li $a0, 32
    syscall
.end_macro


#------------------------------------------------------------------------
# main_function_lab5_19q4_fa_ce12:
#
# Calls print_str_array, str_to_int_array, sort_array,
# print_decimal_array.
#
# You may assume that the array of string pointers is terminated by a
# 32-bit zero value. You may also assume that the integer array is large
# enough to hold each converted integer value and is terminated by a
# 32-bit zero value
# 
# arguments:  $a0 - pointer to integer array
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - minimum element in array (32-bit int)
#             $v1 - maximum element in array (32-bit int)
#-----------------------------------------------------------------------
# REGISTER USE
# $s0 - pointer to int array
# $s1 - double pointer to string array
# $s2 - length of array
# $t6 - temporary storage of min
# $t7 - temporary storage of max
#-----------------------------------------------------------------------

.text
main_function_lab5_19q4_fa_ce12: nop
    
    subi  $sp    $sp   16       # decrement stack pointer
    sw    $ra 12($sp)           # push return address to stack
    sw    $s0  8($sp)           # push save registers to stack
    sw    $s1  4($sp)
    sw    $s2   ($sp)
    
    move  $s0    $a0            # save ptr to int array
    move  $s1    $a1            # save ptr to string array
    
    move  $a0    $s1            # load subroutine arguments
    jal   get_array_length      # determine length of array
    move  $s2    $v0            # save array length
    
                                # print input header
                                 
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nInput string array\n")
                       
    move  $a1, $s1              # load subroutine arguments
    jal   print_str_array       # print array of ASCII strings
    
    move  $a0, $s2              # load subroutine arguments
    move  $a1, $s1               
    move  $a2, $s0
    jal   str_to_int_array      # convert string array to int array
                                
    move  $a0, $s2              # load subroutine arguments
    move  $a1, $s0
    jal   sort_array            # sort int array
    move  $t6, $v0              # save min and max values from array
    move  $t7, $v1
                                # print output header    
    lab5_print_new_line
    lab5_print_string("\n----------------------------------------")
    lab5_print_string("\nSorted integer array\n")
    
    move  $a0, $s2              # load subroutine arguments
    move  $a1, $s0
    jal   print_decimal_array   # print integer array as decimal
                                # save output values
    lab5_print_new_line
    
    move  $v0, $t6              # print min and max values
    move  $v1, $t7                            
            
    lw    $ra 12($sp)           # pop return address from stack
    lw    $s0  8($sp)           # pop save registers from stack
    lw    $s1  4($sp)
    lw    $s2   ($sp)
    addi  $sp    $sp   16       # increment stack pointer
    
    jr    $ra                   # return from subroutine

#-----------------------------------------------------------------------
# print_str_array	
#
# Prints array of ASCII inputs to screen.
#
# arguments:  $a0 - array length (optional)
# 
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $t0 - array length/loop counter
# $v0 - for printing strings (syscall 4)
#-----------------------------------------------------------------------

.text
print_str_array: nop
    subi $sp,  $sp, 4           
    sw   $ra, ($sp)
    move $a0,  $a1
    jal  get_array_length       # calling get_array_length because test file has hardcoded value of 5
    move $t0,  $v0              # which affects psa_LOOP
    
    psa_LOOP:                   # print each string argument in the loop
        beqz $t0, END_psa_LOOP
        li   $v0,    4
        lw   $a0, ($a1)
        syscall
        lab5_print_space
        addi $a1,  $a1,  4      # next address
        addi $t0,  $t0, -1
        j    psa_LOOP
    
    END_psa_LOOP:
        lw    $ra, ($sp)
        addi  $sp,  $sp,  4
        
    jr    $ra
    
#-----------------------------------------------------------------------
# str_to_int_array
#
# Converts array of ASCII strings to array of integers in same order as
# input array. Strings will be in the following format: '0xABCDEF00'
# 
# i.e zero, lowercase x, followed by 8 hexadecimal digits, with A - F
# capitalized
# 
# arguments:  $a0 - array length (optional)
#
#             $a1 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
#             $a2 - pointer to integer array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $t4 - array length/loop counter
# $v0 - retrieves array length  &  retrieves integer from "str_to_int"
#-----------------------------------------------------------------------

.text
str_to_int_array: nop
    subi $sp,  $sp, 4
    sw   $ra, ($sp)
    move $a0,  $a1
    jal  get_array_length       # calling get_array_length because test file has hardcoded value of 5
    move $t4,  $v0              # which affects stia_LOOP
    
    stia_LOOP:
        beqz  $t4, END_stia_LOOP
        lw    $a0, ($a1)   
        jal   str_to_int
        sw    $v0, ($a2)        # store the return value from str_to_int in integer array
        addiu $a1,  $a1,  4
        addiu $a2,  $a2,  4
        addiu $t4,  $t4, -1
        j     stia_LOOP

    END_stia_LOOP:
        lw    $ra, ($sp)
        addi  $sp,  $sp,  4
    
    jr   $ra

#-----------------------------------------------------------------------
# str_to_int	
#
# Converts ASCII string to integer. Strings will be in the following
# format: '0xABCDEF00'
# 
# i.e zero, lowercase x, followed by 8 hexadecimal digits, capitalizing
# A - F.
# 
# argument:   $a0 - pointer to first character of ASCII string
#
# returns:    $v0 - integer conversion of input string
#-----------------------------------------------------------------------
# REGISTER USE
# $t0 - scans byte by byte, interprets offset in "table", holds address for int value in table
# $t1 - holds int value interpreted by $t1
# $t2 - byte offset for shifting. Also used as a loop counter
# $t3 - address of first word of "table"
#-----------------------------------------------------------------------

.data
table:        .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 10, 11, 12, 13, 14, 15

.text
str_to_int: nop
    move $v0, $zero             # reset $v0 so loop works correctly
    li   $t2, 28
    la   $t3, table
    
    sti_LOOP:
        beq  $t2,    -4, END_sti_LOOP
        lb   $t0, 2($a0)        # skip '0x' characters
        addi $t0,   $t0, -48    # convert ascii code to offset value
        mul  $t0,   $t0,   4 
        add  $t0,   $t0, $t3
        lw   $t1,  ($t0)
        sllv $t1,   $t1, $t2
        add  $v0,   $v0, $t1    # integer value enters $v0 at appropriate bit
        addi $t2,   $t2,  -4
        addi $a0,   $a0,   1
        j    sti_LOOP

    END_sti_LOOP:
    jr   $ra
    
#-----------------------------------------------------------------------
# sort_array
#
# Sorts an array of integers in ascending numerical order, with the
# minimum value at the lowest memory address. Assume integers are in
# 32-bit two's complement notation.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    $v0 - minimum element in array
#             $v1 - maximum element in array
#-----------------------------------------------------------------------
# REGISTER USE
# $t0 - 1st value in comparison
# $t1 - 2nd value in comparison
# $t2 - counter for how many rounds to go through bubble sort (length - 1)
# $t3 - counter for comparisons per round
# $t4 - address of first integer
# $t9 - store $a0 for offset to find max (used at the end)
#-----------------------------------------------------------------------

.text
sort_array: nop
    subi $a0, $a0, 1            # only need to run bubble sort (length - 1) times
    move $t2, $a0
    move $t3, $a0
    move $t9, $a0
    move $t4, $a1
    
    sa_LOOP:
        bnez $t3, cont1         # if $t3 = 0 run a "reset"
        subi $a0, $a0, 1        # only need to run ($a0 - 1) comparisons after each reset
        move $t3, $a0           
        move $t4, $a1           # return to first value address
        subi $t2, $t2, 1
        beqz $t2, END_sa_LOOP   # runs bubble sort (length - 1) times
        cont1:                  # select two adjacent values and decide if need to swap
            lw   $t0,  ($t4)    
            lw   $t1, 4($t4)
            ble  $t0,   $t1, cont2 # no swap
            sw   $t1,  ($t4)       # swap
            sw   $t0, 4($t4)
        cont2:
            addi $t4,   $t4, 4  # whether swap or no swap, continue to top of loop
            subi $t3,   $t3, 1
            j sa_LOOP
    
    END_sa_LOOP:
    lw   $v0, ($a1)             # store min
    mul  $t9,  $t9, 4           # find offset according to array length
    add  $a1,  $a1, $t9
    lw   $v1, ($a1)             # store max
    jr   $ra

#-----------------------------------------------------------------------
# print_decimal_array
#
# Prints integer input array in decimal, with spaces in between each
# element.
#
# arguments:  $a0 - array length (optional)
#             $a1 - pointer to first element of array
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $t9 - array length/loop counter
#-----------------------------------------------------------------------

.text
print_decimal_array: nop
    subi $sp,  $sp, 4
    sw   $ra, ($sp)
    move $t9,  $a0
    
    pda_LOOP: nop
        beqz   $t9,  END_pda_LOOP
        lw     $a0, ($a1)       # a0 = pointer to int to run print_decimal subroutine
        jal    print_decimal
        lab5_print_space
        addi   $a1,  $a1, 4
        subi   $t9,  $t9, 1
        j      pda_LOOP
    
    END_pda_LOOP:
        lw     $ra, ($sp)
        addi   $sp,  $sp, 4
    
    jr   $ra
    
#-----------------------------------------------------------------------
# print_decimal
#
# Prints integer in decimal representation.
#
# arguments:  $a0 - integer to print
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $t0 - address of allocated space in memory
# $t1 - character '0' ascii code
# $t2 - holds int 10 so during div quotient and remainder are stored in lo and hi
# $t3 - holds remainder and is offset to grab ascii character for string
# $t4 - set if input < 0
# $v0 - used to print string (syscall 4)
#-----------------------------------------------------------------------

.data
string_space: .space 32

.text
print_decimal: nop
    la   $t0,  string_space
    add  $t0,  $t0, 30          # go to 2nd rightmost byte
    li   $t1,  48               # ascii '0'
    sb   $t1, ($t0)             # initialize so if input is 0 can END_pd correctly
    slt  $t4,  $a0, $zero       # set if value is negative
    li   $t2,  10           
    beqz $a0,  END_pd  
    beqz $t4,  pd_LOOP          # flip if negative else continue to loop
    neg  $a0,  $a0                
    
    pd_LOOP:
        div  $a0,  $t2
        mflo $a0                # quotient
        mfhi $t3                # remainder
        add  $t3,  $t3, 48      # convert to ASCII digit
        sb   $t3, ($t0)
        addi $t0,  $t0, -1
        bnez $a0,  pd_LOOP      # if quotient not zero, loop
        addi $t0,  $t0,  1      # move left one byte
        
    sign:
        beqz $t4,  END_pd       # if negative add '-' character else continue to print
        addi $t0,  $t0, -1
        li   $t1,   45
        sb   $t1, ($t0)
        
    END_pd:
        li   $v0, 4             # print string
        move $a0, $t0
        syscall
        
    jr   $ra

#-----------------------------------------------------------------------
# exit_program (given)
#
# Exits program.
#
# arguments:  n/a
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $v0: syscall
#-----------------------------------------------------------------------

.text
exit_program: nop
    
    addiu   $v0  $zero  10      # exit program cleanly
    syscall
    
#-----------------------------------------------------------------------
# OPTIONAL SUBROUTINES

#-----------------------------------------------------------------------
# get_array_length (optional)
# 
# Determines number of elements in array.
#
# argument:   $a0 - double pointer to string array (pointer to array of
#                   addresses that point to the first characters of each
#                   string in array)
#
# returns:    $v0 - array length
#-----------------------------------------------------------------------
# REGISTER USE
# $t0 - recieves first byte from string array
#-----------------------------------------------------------------------

.text
get_array_length: nop
    move $v0, $zero             # clear $v0
    gal_LOOP:
        lb   $t0, ($a0)         # should scan in 0x00000030 until it hits null 
        beqz $t0,  END_gal_LOOP # as long as ascii code isn't 0 (null) proceed with loop
        addi $v0,  $v0, 1
        addi $a0,  $a0, 4       # to scan next string value
        j gal_LOOP
        
    END_gal_LOOP:
    jr   $ra
    
#-----------------------------------------------------------------------
# save_to_int_array (optional)
# 
# Overwrites a 32-bit value to a specific index in an integer array
#
# argument:   $a0 - value to save
#             $a1 - address of int array
#             $a2 - index to save to
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# n/a
#-----------------------------------------------------------------------

.text
save_to_int_array:
    beqz $a2,  END_save
    addi $a1,  $a1, 4           # traverse to desired address
    subi $a2,  $a2, 1
    j    save_to_int_array
    
    END_save:
    sw   $a0, ($a1)             # overwrite current int with new int
    jr   $ra
    
#-----------------------------------------------------------------------
# add_to_int_array (optional)
# 
# Adds a 32-bit value to a specific index in an integer array
#
# argument:   $a0 - value to add
#             $a1 - address of int array
#             $a2 - index to add to
#
# returns:    n/a
#-----------------------------------------------------------------------
# REGISTER USE
# $t0 - value to be loaded to next index in the loop
# $t1 - save next index value
# $t2 - address to load from and store to in array
# $t3 - loop counter for value shifting in the array (array length - index)
# $v0 - retrieves length
#-----------------------------------------------------------------------

.text
add_to_int_array:
    subi $sp,  $sp, 4
    sw   $ra, ($sp)
    move $a0,  $a1
    jal  get_array_length
    move $t3,  $v0              # grab length so we know how many times to loop in shift_LOOP 
    sub  $t3,  $t3, $a2         # number of times to loop = (length - index)
    
    index_LOOP:
        beqz $a2, cont          # when index = 0 leave loop
        addi $a1, $a1, 4        # traverse to desired address
        subi $a2, $a2, 1
        j    index_LOOP
    
    cont:
        move $t2,  $a1          # store desired address in temporary register
        lw   $t0, ($t2)         # store first value from index address
        
    shift_LOOP:
        beqz $t3,  END_add
        addi $t2,  $t2, 4       # move to next address in array
        lw   $t1, ($t2)         # save value
        sw   $t0, ($t2)         # store previous value in current address
        move $t0,  $t1          # store $t0 = $t1 for the loop
        subi $t3,  $t3, 1
        j    shift_LOOP

    END_add:
        sw   $a0, ($a1)         # store new value in desired location
        lw   $ra, ($sp)
        addi $sp,  $sp,  4
    
    jr   $ra
