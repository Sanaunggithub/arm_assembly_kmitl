.global _start
.equ endlist, 0xaaaaaaaa

_start:
	ldr r0, =list // Load address of the list into r0
	ldr r3, =endlist // load the value of endlist not the address because endlist is a value
	ldr r1, [r0] // Load first element of the list into r1
	mov r2, #0
	add r2, r2, r1
	
loop:
	ldr r1,[r0, #4]! // pre-increment r0 and load second element of the list into r1
	cmp r1, r3
	beq exit
	add r2, r2, r1  ; add that element to r2
	b loop
	
exit:

.data
list:
	.word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10