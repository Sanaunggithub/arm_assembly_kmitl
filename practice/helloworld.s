.global _start

.section .data
message:
    .asciz "hello world\n"

len = .-message

.section .text
_start:
    @ write(1, message, len)
    mov r0, #1 @ fd = stdout
    ldr r1, =message @ pointer to string    
    ldr r2, =len @ length of string
    mov r7, #4 @ syscall number for write
    swi 0

    mov r7, #1
    swi 0




