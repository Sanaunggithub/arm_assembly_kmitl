.global _start

.data
var1: .word 5   @ var1 = 5 (stored in memory)
var2: .word 7   @ var2 = 7 (stored in memory)

.text
_start:
    ldr r0, =var1 @ r0 = address of var1
    ldr r1, [r0] @ r1 = value stored at address in r0 (which is 5)
    mov r2, #3  @ r2 = 3
    ldr r3, =var2 @ r3 = address of var2
    str r2, [r3] @ replace var2(7) with r2 value(3)

