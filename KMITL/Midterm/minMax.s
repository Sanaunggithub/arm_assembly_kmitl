.section .data
arr: .word 3, 7, 2, 9
arr_end:

max: .word 0
len_arr: (arr_end - arr) / 4

.section .text
.global _start
_start:
    ldr r0, =arr
    ldr r1, =len_arr
    ldr r1, [r1]
    