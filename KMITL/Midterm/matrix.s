.section .data
matrix_a: 
    .word 1, 2, 3
    .word 4, 5, 6

matrix_b:
    .word 7, 8, 9
    .word 10, 11, 12

matrix_c:
    .space 24


.section .text
.global_start
_start:
    ldr r0, =matrix_a
    ldr r1, =matrix_b
    ldr r2, =matrix_c
    mov r3, #6

loop:
    cmp r3, #0
    beq end
    ldr r4, [r0], #4
    ldr r5, [r1], #4
    add r4, r4, r5
    str r4, [r2], #4
    sub r3, r3, #1
    b loop

end:
    mov r0, #0
    mov r7, #1
    svc 0