.global _start
_start:
    MOV r0, #30
    mov r1, #5
    and r2, r0, r1 // Perform bitwise AND operation between r0 and r1, store result in r2