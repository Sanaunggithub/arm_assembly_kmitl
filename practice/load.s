.global _start
_start:
	LDR r0, =list // Load the address of the list into r0. = is used to load the address directly.
	LDR r1, [r0] // [r0] means load the value at the address in r0 into r1.
	LDR r2, [r0, #4] // Load the second value (5) into r2. #4 means offset by 4 bytes from the address in r0.

	
.data // tell the assembler this is a data section which means it will store initialized data 
list: // this is a label that marks the start of the data section. You can name it anything you want.
    .word 1, 5,-9, 0 // .word means store 32-bit (4-byte) values. It can store integers, floats, or any 32-bit data.