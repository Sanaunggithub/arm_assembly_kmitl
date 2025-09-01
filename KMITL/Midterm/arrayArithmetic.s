.section .data
X: .word 2, 4, 6, 8, 10
X_end:

Y: .word 1, 3, 5, 7, 9
Y_end:

Z: .space 20

len_X: .word (X_end - X) / 4
len_Y: .word (Y_end - Y) / 4    

.section .text
.global _start
_start:
    ldr r0, =X
    ldr r1, =Y
    ldr r2, =Z
    ldr r3, =len_X
    ldr r3, [r3]

loop:
    cmp r3, #0
    BEQ end

    ldr r4, [r0], #4
    ldr r5, [r1], #4
    add r6, r4, r5
    str r6, [r2], #4 ; increment r2 by 4
    subs r3, r3, #1
    BNE loop

end:
    mov r0, #0
    mov r7, #1
    svc 0


