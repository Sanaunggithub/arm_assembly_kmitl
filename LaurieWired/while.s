int i = 0;

while (i < 5) {
    i++;
}

.global _start

_start:
    mov r0, #1

loop:
    cmp r0, #5
    bge end ; if r0 >= 5, branch to end
    add r0, #1
    b loop
    
end:
    mov r7, #1
    svc 0