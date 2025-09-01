.global _start
_start:

    mov r0, #4
    mov r1, #5

    // r0 - r1 
    // if r0 > r1, result = +
    // if r0 < r1, result = -
    // if r0 = r1, result = 0

    cmp r0, r1
    