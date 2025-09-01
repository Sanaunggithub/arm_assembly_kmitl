int add_nums(int num1, int num2){
    return num1 + num2;
}

int main(void){
    add_nums(1, 2);
    return 0;
}


.global _start
_start: 
    mov r0, #1  @ arg1
    mov r1, #2  @ arg2

    push {r0, r1} @stores r0, r1 original value not to lose
    bl add_nums
    mov r2, r0  @stores the result of r0 into r2
    pop {r0, r1}


add_nums:
    add r0, r0, r1 @ return value will be placed in r0
    bx lr @ return to caller at address stored in lr (i.e. mov r2, r0)