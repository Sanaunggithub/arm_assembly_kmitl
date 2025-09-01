.global _start
_start:
    mov r0, #1
    mov r1, #3
    bl add2 
    mov r3, #4

add2:
    add r2, r0, r1
    bx lr