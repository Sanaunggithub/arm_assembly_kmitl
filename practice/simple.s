.global _start

_start:
    mov r0, #1          @ file descriptor (stdout)
    ldr r1, =msg        @ pointer to message
    mov r2, #13         @ length of message
    mov r7, #4          @ syscall write
    svc 0               @ 

    mov r7, #1          @ syscall exit
    mov r0, #0
    svc 0

msg:
    .asciz "Hello Simple\n"
