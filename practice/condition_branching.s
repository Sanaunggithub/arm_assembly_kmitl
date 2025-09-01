.global _start
_start:
    mov r0, #3
    mov r1, #2
    CMP r0, r1

    BGT greater
    B end

greater:
    mov r2, #14

end:
    mov r7, #1
    swi #0