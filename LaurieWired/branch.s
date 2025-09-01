.global _start
_start:
    mov r0, #4
    mov r1, #5

    cmp r0, r1
    BLT cond1 ; if r0 < r1, go to cond1
    B cond2 ; if not, go to cond2

cond1:
    mov r2, #1
    b end ; to skip cond2 after running cond1


cond2:
    mov r2, #2

end:   
    mov r0, #0 
    mov r7, #1  ;syscall: exit
    svc 0