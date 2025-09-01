.section .data
welcome_msg: .ascii "Welcome to Battle of Numbers!\n"
len_welcome = . - welcome_msg
goal_msg: .ascii "The goal is to take the last object from the pile to win.\n\n"
len_goal = . - goal_msg
pile_prompt: .ascii "Enter initial pile size: "
len_pile_prompt = . - pile_prompt
min_prompt: .ascii "Enter minimum objects to take: "
len_min_prompt = . - min_prompt
max_prompt: .ascii "Enter maximum objects to take: "
len_max_prompt = . - max_prompt
first_prompt: .ascii "Who goes first? (1 for computer, 2 for player): "
len_first_prompt = . - first_prompt
objects_left_msg: .ascii "\nObjects left in pile: "
len_objects_left = . - objects_left_msg
player_turn_msg: .ascii "Your turn. Enter number of objects to take: "
len_player_turn = . - player_turn_msg
you_took_msg: .ascii "You took "
len_you_took = . - you_took_msg
computer_took_msg: .ascii "Computer takes "
len_computer_took = . - computer_took_msg
objects_msg: .ascii " objects.\n"
len_objects = . - objects_msg
you_win_msg: .ascii "\nYou win!\n"
len_you_win = . - you_win_msg
computer_win_msg: .ascii "\nComputer wins!\n"
len_computer_win = . - computer_win_msg
invalid_msg: .ascii "Invalid input. Try again.\n"
len_invalid = . - invalid_msg
newline: .ascii "\n"
len_newline = . - newline

input_buf: .space 12
output_buf: .space 12
pile_size: .word 0
min_objects: .word 0
max_objects: .word 0
is_player_turn: .word 0

.section .text
.global _start

_start:
    // Display welcome message
    mov r7, #4
    mov r0, #1
    ldr r1, =welcome_msg
    mov r2, #len_welcome
    svc #0

    mov r7, #4
    mov r0, #1
    ldr r1, =goal_msg
    mov r2, #len_goal
    svc #0

    // Get initial pile size
    mov r7, #4
    mov r0, #1
    ldr r1, =pile_prompt
    mov r2, #len_pile_prompt
    svc #0

    mov r7, #3
    mov r0, #0
    ldr r1, =input_buf
    mov r2, #11
    svc #0

    ldr r1, =input_buf
    bl atoi
    ldr r1, =pile_size
    str r0, [r1]

    // Get minimum objects
    mov r7, #4
    mov r0, #1
    ldr r1, =min_prompt
    mov r2, #len_min_prompt
    svc #0

    mov r7, #3
    mov r0, #0
    ldr r1, =input_buf
    mov r2, #11
    svc #0

    ldr r1, =input_buf
    bl atoi
    ldr r1, =min_objects
    str r0, [r1]

    // Get maximum objects
    mov r7, #4
    mov r0, #1
    ldr r1, =max_prompt
    mov r2, #len_max_prompt
    svc #0

    mov r7, #3
    mov r0, #0
    ldr r1, =input_buf
    mov r2, #11
    svc #0

    ldr r1, =input_buf
    bl atoi
    ldr r1, =max_objects
    str r0, [r1]

    // Get who goes first
    mov r7, #4
    mov r0, #1
    ldr r1, =first_prompt
    mov r2, #len_first_prompt
    svc #0

    mov r7, #3
    mov r0, #0
    ldr r1, =input_buf
    mov r2, #11
    svc #0

    ldr r1, =input_buf
    bl atoi
    cmp r0, #2
    moveq r0, #1
    movne r0, #0
    ldr r1, =is_player_turn
    str r0, [r1]

game_loop:
    // Check if pile is empty
    ldr r1, =pile_size
    ldr r0, [r1]
    cmp r0, #0
    beq game_over

    // Display objects left
    mov r7, #4
    mov r0, #1
    ldr r1, =objects_left_msg
    mov r2, #len_objects_left
    svc #0

    ldr r1, =pile_size
    ldr r0, [r1]
    bl itoa
    mov r7, #4
    mov r0, #1
    ldr r1, =output_buf
    mov r2, r6  // r6 contains string length from itoa
    svc #0

    mov r7, #4
    mov r0, #1
    ldr r1, =newline
    mov r2, #len_newline
    svc #0

    // Check whose turn
    ldr r1, =is_player_turn
    ldr r0, [r1]
    cmp r0, #1
    beq player_turn
    b computer_turn

player_turn:
    mov r7, #4
    mov r0, #1
    ldr r1, =player_turn_msg
    mov r2, #len_player_turn
    svc #0

    mov r7, #3
    mov r0, #0
    ldr r1, =input_buf
    mov r2, #11
    svc #0

    ldr r1, =input_buf
    bl atoi
    mov r8, r0  // r8 = objects to take

    // Validate input
    ldr r1, =min_objects
    ldr r2, [r1]
    cmp r8, r2
    blt invalid_input

    ldr r1, =max_objects
    ldr r2, [r1]
    cmp r8, r2
    bgt invalid_input

    ldr r1, =pile_size
    ldr r2, [r1]
    cmp r8, r2
    bgt invalid_input

    // Valid input - update pile
    sub r2, r2, r8
    str r2, [r1]

    // Display what player took
    mov r7, #4
    mov r0, #1
    ldr r1, =you_took_msg
    mov r2, #len_you_took
    svc #0

    mov r0, r8
    bl itoa
    mov r7, #4
    mov r0, #1
    ldr r1, =output_buf
    mov r2, r6
    svc #0

    mov r7, #4
    mov r0, #1
    ldr r1, =objects_msg
    mov r2, #len_objects
    svc #0

    b switch_turn

computer_turn:
    // Computer strategy: try to leave pile as multiple of (max+1)
    ldr r1, =pile_size
    ldr r2, [r1]        // r2 = pile_size
    ldr r3, =max_objects
    ldr r3, [r3]        // r3 = max_objects
    add r4, r3, #1      // r4 = max + 1

    // Calculate remainder
    udiv r5, r2, r4     // r5 = pile_size / (max+1)
    mls r8, r4, r5, r2  // r8 = remainder

    // If remainder is 0, take minimum
    cmp r8, #0
    ldreq r1, =min_objects
    ldreq r8, [r1]

    // Ensure within bounds
    ldr r1, =min_objects
    ldr r9, [r1]
    cmp r8, r9
    movlt r8, r9

    ldr r1, =max_objects
    ldr r9, [r1]
    cmp r8, r9
    movgt r8, r9

    // Don't exceed pile size
    cmp r8, r2
    movgt r8, r2

    // Update pile
    ldr r1, =pile_size
    sub r2, r2, r8
    str r2, [r1]

    // Display what computer took
    mov r7, #4
    mov r0, #1
    ldr r1, =computer_took_msg
    mov r2, #len_computer_took
    svc #0

    mov r0, r8
    bl itoa
    mov r7, #4
    mov r0, #1
    ldr r1, =output_buf
    mov r2, r6
    svc #0

    mov r7, #4
    mov r0, #1
    ldr r1, =objects_msg
    mov r2, #len_objects
    svc #0

switch_turn:
    // Toggle turn
    ldr r1, =is_player_turn
    ldr r0, [r1]
    eor r0, r0, #1
    str r0, [r1]
    b game_loop

invalid_input:
    mov r7, #4
    mov r0, #1
    ldr r1, =invalid_msg
    mov r2, #len_invalid
    svc #0
    b player_turn

game_over:
    // Determine winner (opposite of current turn)
    ldr r1, =is_player_turn
    ldr r0, [r1]
    cmp r0, #1
    beq computer_won

    mov r7, #4
    mov r0, #1
    ldr r1, =you_win_msg
    mov r2, #len_you_win
    svc #0
    b exit_game

computer_won:
    mov r7, #4
    mov r0, #1
    ldr r1, =computer_win_msg
    mov r2, #len_computer_win
    svc #0

exit_game:
    mov r7, #1
    mov r0, #0
    svc #0

// Convert string to integer
atoi:
    // Input: r1 = string address
    // Output: r0 = integer
    mov r4, #0          // result
atoi_loop:
    ldrb r2, [r1]
    add r1, #1
    cmp r2, #'0'
    blt atoi_done
    cmp r2, #'9'
    bgt atoi_done
    sub r2, #'0'
    mov r3, r4
    lsl r4, #3          // r4 * 8
    lsl r3, #1          // r3 * 2
    add r4, r4, r3      // r4 = old_r4 * 10
    add r4, r4, r2      // add digit
    b atoi_loop
atoi_done:
    mov r0, r4
    bx lr

// Convert integer to string
itoa:
    // Input: r0 = integer
    // Output: string in output_buf, length in r6
    ldr r1, =output_buf + 10
    mov r2, #0
    strb r2, [r1]       // null terminate
    mov r5, r0          // number to convert
    mov r0, #10         // base
itoa_loop:
    sub r1, r1, #1
    udiv r3, r5, r0     // quotient
    mls r2, r0, r3, r5  // remainder
    add r2, r2, #'0'
    strb r2, [r1]
    mov r5, r3
    cmp r5, #0
    bne itoa_loop

    // Calculate length
    ldr r4, =output_buf + 10
    sub r6, r4, r1      // r6 = length
    
    // Copy to start of buffer
    ldr r4, =output_buf
copy_loop:
    ldrb r2, [r1], #1
    strb r2, [r4], #1
    cmp r2, #0
    bne copy_loop
    
    bx lr
