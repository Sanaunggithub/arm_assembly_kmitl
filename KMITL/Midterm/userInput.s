.section .data
msg:
    .asciz " "

.section .text
.global _start
_start:
    mov r7, #3
    mov r0, #0
    mov r2, #10
    ldr r1, =msg
    swi 0

_write:
    mov r7,#4
    mov r1, #1
    mov r2, #5
    ldr r1, =msg
    swi 0

end:
    mov r7, #1
    swi 0