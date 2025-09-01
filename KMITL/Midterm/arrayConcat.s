.section .data
A: .word 1, 2, 3
A_end:

B: .word 3, 4, 5
B_end:

C: .space 24

len_A: .word (A_end - A) / 4
len_B: .word (B_end - B) / 4

.section .text
global _start
_start:
    ldr r0, =A
    ldr r1, =B
    ldr r2, =C

    ldr r3, =len_A
    ldr r3, [r3]

concatA:
    cmp r3, #0
    beq concatB
    ldr r4, [r0], #4
    str r4, [r2], #4
    subs r3, r3, #1
    bne concatA

concatB:
    ldr r3, = len_B
    ldr r3, [r3]

concatB_loop:
    cmp r3, #0
    beq end
    ldr r4, [r1], #4
    str r4, [r2], #4
    subs r3, r3, #1
    bne concatB_loop

end:
    mov r7, #1
    mov r0, #0
    svc 0