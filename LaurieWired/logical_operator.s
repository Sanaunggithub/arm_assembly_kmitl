.global _start
_start:
    mov r0, #0x42
    orr r1, r0, #0x26

    mov r2, #0x66
    mvn r3, r0


// And Operation
0x46 - 01000010
0x26 - 00100110

r1   - 00000010 (hex value 2 will be stored)


// Orr Operation
0x46 - 01000010
0x26 - 00100110

r1   - 01100110 (hex value 66 will be stored)


// Eor Operation (same 0 diff 1)
0x46 - 01000010
0x26 - 00100110

r1   - 01100100 (hex value 64 will be stored)

// MVN Operation
0x66 - 01100110
r3   - 10011001
