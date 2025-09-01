.global _start
_start:
	mov r0, #5
	mov r1, #5
	add r2, r0, r1 // Add r0 and r1, store result in r2
    sub r3, r0, r1 // Subtract r1 from r0, store result in r3
    mul r4, r0, r1 // Multiply r0 and r1, store result in r4