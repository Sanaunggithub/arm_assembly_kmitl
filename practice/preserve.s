.global _start
_start:
    mov r0, #1
    mov r1, #3
    push {r0, r1} // Save r0 and r1 on the stack
    bl getvalue
    pop {r0, r1} // Restore r0 and r1 from the stack
    b end

getvalue:
    mov r0, #5
    mov r1, #7
    add r2, r0, r1
    bx lr

end: