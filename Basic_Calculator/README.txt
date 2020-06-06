Elad Zohar
ezohar
Fall 2019
Lab 2: Intro to Logic Simulation

-----------
DESCRIPTION

In this program the user is able to store data in one of four registers (Registers 0-3), read the data of two
of those registers at a time, find the sum, and then store it in any of the four registers. There is also an
overflow reader that interprets whether or not there is an overflow in your summation.

-----------
FILES

-
Lab2.lgi

This is my MMLogic file of the lab (extra credit completed).
	Pg.1	   - Inputs and Outputs
	Pg.2       - Store Select decider
	Pg.3-6     - Writing to each register
	Pg.7-10    - Reading into ALU Input Registers
	Pg.11      - Addition circuit
	Pg.12	   - Overflow circuit

-----------
INSTRUCTIONS

This program is run on MMLogic. 

I.   To initialize or clear all the registers: 
	 Press the "Clear Registers" button. This will set all Registers to equal 0.


II.  To input data with the keypad into the registers:

	 Make sure that the "Store Select" switch is set to 0. Select the register you want to write to by using 
	 the "Write Register Address" switches (00 => Reg0, 01 => Reg1, etc.). Once you've input a value in the 
	 keypad and selected a register hit the "Update Register" button.


III. To add two values together:

	 Use the "Read Register (1/2) Address" switches to select which registers you want to add. They will be
	 loaded into "ALU Input 1" and "ALU Input 2" respectively. They will automatically be added and the sum
	 will be displayed in "ALU Output."
	 
	 NOTE: a sum greater than 15 (F) will be cycled back around and returned as a hex value without the
	       caried value (exp: B + F = A, instead of 1A).


IV.  To store a sum:
	
	 Once step III is complete, switch the "Store Select" switch to 1. Select which register you want to
	 store the sum displayed in ALU Output to with the "Write Register Address" switches. Then press
	 "Update Registers."

