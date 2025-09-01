.global _start // tell the linker this is the starting point
_start // label
    MOV r0, #30
	MOV r7, #1
	SWI 0 // software interrupt to exit the program