.global _start
_start:
    mov r0, #10
    lsl r0, #1 // Logical shift left r0 by 1 bit, store result in r0
    lsl r2, r0, #2 // Logical shift left r0 by 2 bits, store result in r2
    mov r1, r0, lsl #1 // shift r0 left by 1 bit first, and store the result in r1
    ror r0, #1 // Rotate r0 right by 1 bit, store result in r0

