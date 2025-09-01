.global _start
_start: 
    push {lr}
    mov r0, #1  @ arg1
    mov r1, #2  @ arg2
    mov r2, #3  @ arg3
    mov r3, #4  @ arg4

    sub sp, sp, #8 @ allocate 8 bytes to store two values
    mov r4, #6
    str r4, [sp] @ store 6 at the address in sp
    mov r4, #5
    str r4, [sp, #4] @ store 5 at the addess sp + 4 bytes

    bl add_nums
    mov r2, r0 

    add sp, sp, #8 @ allocats sp pointer to original address
    pop {lr}


add_nums:

    add r0, r0, r1
    add r0, r0, r2
    add r0, r0, r3
    ldr r4, [sp , #4] @ 5 since we push it reverse
    add r0, r0, r4
    ldr r4, [sp]  @ 6 now
    add r0, r0, r4

    bx lr



+---------+ 0x0FFC  <-- sp + 4
|    5    |          (second stored value)
+---------+
|    6    | 0x0FF8  <-- sp
+---------+

 
| Address | Value  |
| ------- | ------ |
| sp      | 6      |
| sp+4    | 5      |
| sp+8    | old lr |



