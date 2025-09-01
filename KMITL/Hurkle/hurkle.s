@ Name San Aung Id 67011725 Date August 4

    .global _start

    .data
prompt:         .asciz "Enter X Y: "
found_msg:      .asciz "You found the Hurkle in "
guesses_msg:    .asciz " guesses!\n"
lose_msg:       .asciz "You ran out of guesses! The Hurkle was at ("
coord_sep:      .asciz ","
coord_end:      .asciz ")\n"
too_high_msg:   .asciz "^ Too high!\n"
too_low_msg:    .asciz "v Too low!\n"
too_left_msg:   .asciz "< Too far left!\n"
too_right_msg:  .asciz "> Too far right!\n"
close_msg:      .asciz "You are very close!\n"

    .bss
hx:             .space 4    @ Hurkle's X coordinate
hy:             .space 4    @ Hurkle's Y coordinate
gx:             .space 4    @ Player's guess X coordinate
gy:             .space 4    @ Player's guess Y coordinate
guess_count:    .space 4    @ Number of guesses made
input_buf:      .space 20   @ Buffer for user input
num_buf:        .space 12   @ Buffer for number to string conversion
random_seed:    .space 4    @ Seed for random number generator
game_won:       .space 4    @ Flag to indicate if game was won

    .text
_start:
    bl initialize_game
    bl game_loop
    b end_program

@ ========================================
@ initialize_game: Sets up the game state
@ ========================================
initialize_game:
    push {lr}
    
    @ Initialize random seed with a different value each run
    mov r0, #42         @ Simple seed - could be improved with time
    ldr r1, =random_seed
    str r0, [r1]
    
    @ Get random X coordinate (0-9)
    bl random_number
    ldr r1, =hx
    str r0, [r1]
    
    @ Get random Y coordinate (0-9) 
    bl random_number
    ldr r1, =hy
    str r0, [r1]
    
    @ Initialize guess count to 0
    mov r0, #0
    ldr r1, =guess_count
    str r0, [r1]
    
    @ Initialize game won flag to 0
    mov r0, #0
    ldr r1, =game_won
    str r0, [r1]
    
    pop {lr}
    bx lr

@ ========================================
@ random_number: Generates a random number 0-9
@ ========================================
random_number:
    push {r1-r4, lr}
    
    @ Load current seed
    ldr r1, =random_seed
    ldr r0, [r1]
    
    @ Simple LCG: seed = (seed * 17 + 5) 
    mov r2, #17         @ multiplier
    mul r3, r0, r2
    add r0, r3, #5      @ additive constant
    
    @ Store new seed
    str r0, [r1]
    
    @ Get remainder when divided by 10 (0-9)
    mov r1, #0      @ quotient
    mov r2, #10     @ divisor
    
divide_loop:
    cmp r0, r2
    blt divide_done
    sub r0, r0, r2
    add r1, r1, #1
    b divide_loop
    
divide_done:
    @ r0 now contains remainder (0-9)
    
    pop {r1-r4, lr}
    bx lr

@ ========================================
@ game_loop: Controls the main flow of the game
@ ========================================
game_loop:
    push {lr}
    
    @ Check if game was won
    ldr r0, =game_won
    ldr r1, [r0]
    cmp r1, #1
    beq game_loop_end
    
    @ Check if we've exceeded 10 guesses
    ldr r0, =guess_count
    ldr r1, [r0]
    cmp r1, #10
    bge lose_game
    
    @ Increment guess count
    add r1, r1, #1
    str r1, [r0]
    
    @ Get player's guess
    bl get_player_guess
    
    @ Process the guess and provide feedback
    bl process_feedback
    
    @ Continue the loop
    b game_loop

lose_game:
    @ Print lose message with Hurkle coordinates
    ldr r0, =lose_msg
    bl print_string
    
    ldr r0, =hx
    ldr r0, [r0]
    bl int_to_str
    ldr r0, =num_buf
    bl print_string
    
    ldr r0, =coord_sep
    bl print_string
    
    ldr r0, =hy
    ldr r0, [r0]
    bl int_to_str
    ldr r0, =num_buf
    bl print_string
    
    ldr r0, =coord_end
    bl print_string
    
    @ End the game after losing
    b game_loop_end
    
game_loop_end:
    pop {lr}
    bx lr

@ ========================================
@ get_player_guess: FIXED input handling to require both X and Y
@ ========================================
get_player_guess:
    push {lr}
    
    @ Print the prompt
    ldr r0, =prompt
    bl print_string
    
    @ Read user input
    mov r0, #0          @ stdin
    ldr r1, =input_buf
    mov r2, #20         @ buffer size
    mov r7, #3          @ sys_read
    svc #0
    
    @ Parse input - find TWO numbers separated by space
    ldr r1, =input_buf
    
    @ Initialize defaults
    mov r0, #0
    ldr r4, =gx
    str r0, [r4]
    ldr r4, =gy
    str r0, [r4]
    
    @ Find first digit for X coordinate
    mov r2, #0          @ position counter
    mov r5, #0          @ numbers found counter
    
find_numbers:
    cmp r2, #15         @ Don't search beyond reasonable length
    bge parse_done
    
    ldrb r3, [r1, r2]
    cmp r3, #0          @ End of string?
    beq parse_done
    cmp r3, #'\n'       @ Newline?
    beq parse_done
    
    @ Check if it's a digit
    cmp r3, #'0'
    blt skip_char
    cmp r3, #'9'
    bgt skip_char
    
    @ Found valid digit
    sub r3, r3, #'0'
    
    @ Store in appropriate coordinate based on count
    cmp r5, #0
    beq store_x
    cmp r5, #1
    beq store_y
    b parse_done        @ Already have both numbers
    
store_x:
    ldr r4, =gx
    str r3, [r4]
    add r5, r5, #1
    b skip_to_next_number
    
store_y:
    ldr r4, =gy
    str r3, [r4]  
    add r5, r5, #1
    b parse_done        @ Got both numbers
    
skip_to_next_number:
    @ Skip to next non-digit (space or other separator)
    add r2, r2, #1
skip_non_digits:
    cmp r2, #15
    bge parse_done
    ldrb r3, [r1, r2]
    cmp r3, #0
    beq parse_done
    cmp r3, #'0'
    blt find_numbers    @ Found non-digit, look for next number
    cmp r3, #'9'
    bgt find_numbers    @ Found non-digit, look for next number
    add r2, r2, #1      @ Still a digit, skip it
    b skip_non_digits
    
skip_char:
    add r2, r2, #1
    b find_numbers

parse_done:
    pop {lr}
    bx lr

@ ========================================
@ process_feedback: FIXED directional logic
@ ========================================
process_feedback:
    push {lr}
    
    @ Load guess coordinates
    ldr r0, =gx
    ldr r1, [r0]        @ r1 = GX
    ldr r0, =gy  
    ldr r2, [r0]        @ r2 = GY
    
    @ Load Hurkle coordinates
    ldr r0, =hx
    ldr r3, [r0]        @ r3 = HX
    ldr r0, =hy
    ldr r4, [r0]        @ r4 = HY
    
    @ Check for exact match
    cmp r1, r3
    bne check_directions
    cmp r2, r4
    bne check_directions
    
    @ Found the Hurkle! Set win flag and print message
    mov r0, #1
    ldr r1, =game_won
    str r0, [r1]
    
    ldr r0, =found_msg
    bl print_string
    
    ldr r0, =guess_count
    ldr r0, [r0]
    bl int_to_str
    
    ldr r0, =num_buf
    bl print_string
    
    ldr r0, =guesses_msg
    bl print_string
    
    b process_feedback_end

check_directions:
    @ FIXED: Check X direction with CORRECT logic
    cmp r1, r3          @ compare GX with HX
    beq check_y_direction
    blt x_too_small     @ if GX < HX: player guessed too small (too far left)
    bgt x_too_big       @ if GX > HX: player guessed too big (too far right)

x_too_small:
    @ GX < HX: Player's guess is too far LEFT (need to go right)
    ldr r0, =too_left_msg
    bl print_string
    b check_y_direction

x_too_big:
    @ GX > HX: Player's guess is too far RIGHT (need to go left)
    ldr r0, =too_right_msg
    bl print_string
    b check_y_direction

check_y_direction:
    @ FIXED: Check Y direction with CORRECT logic
    cmp r2, r4          @ compare GY with HY
    beq check_proximity
    blt y_too_small     @ if GY < HY: player guessed too small (too low)
    bgt y_too_big       @ if GY > HY: player guessed too big (too high)

y_too_small:
    @ GY < HY: Player's guess is too LOW (need to go up)
    ldr r0, =too_low_msg
    bl print_string
    b check_proximity

y_too_big:
    @ GY > HY: Player's guess is too HIGH (need to go down)
    ldr r0, =too_high_msg
    bl print_string
    b check_proximity

check_proximity:
    @ Calculate Manhattan distance: |GX - HX| + |GY - HY|
    @ Calculate |GX - HX|
    subs r0, r1, r3     @ GX - HX
    rsbmi r0, r0, #0    @ if negative, make positive (absolute value)
    
    @ Calculate |GY - HY|
    subs r5, r2, r4     @ GY - HY
    rsbmi r5, r5, #0    @ if negative, make positive (absolute value)
    
    @ Sum for Manhattan distance
    add r0, r0, r5
    
    @ Check if distance <= 2 (and not exact match)
    cmp r0, #0
    beq process_feedback_end    @ Exact match already handled
    cmp r0, #2
    ble print_close_message
    b process_feedback_end

print_close_message:
    ldr r0, =close_msg
    bl print_string

process_feedback_end:
    pop {lr}
    bx lr

@ ========================================
@ print_string: General-purpose helper to print null-terminated string
@ ========================================
print_string:
    push {r1-r3, lr}
    
    mov r1, r0          @ save string pointer
    mov r2, #0          @ length counter
    
    @ Calculate string length
count_length:
    ldrb r3, [r1, r2]
    cmp r3, #0
    beq print_now
    add r2, r2, #1
    b count_length

print_now:
    @ System call to write
    mov r0, #1          @ stdout
    mov r7, #4          @ sys_write
    svc #0
    
    pop {r1-r3, lr}
    bx lr

@ ========================================
@ int_to_str: Helper to convert number into printable string
@ ========================================
int_to_str:
    push {r1-r7, lr}
    
    ldr r1, =num_buf
    mov r2, r1          @ pointer to current position
    mov r3, #0          @ digit count
    
    @ Handle special case of 0
    cmp r0, #0
    bne convert_loop
    mov r4, #'0'
    strb r4, [r2]
    add r2, r2, #1
    mov r3, #1
    b reverse_string

convert_loop:
    cmp r0, #0
    beq reverse_string
    
    @ Divide by 10 to get next digit
    mov r4, #0          @ quotient
    mov r5, #10         @ divisor
    
divide_by_10:
    cmp r0, r5
    blt got_remainder
    sub r0, r0, r5
    add r4, r4, #1
    b divide_by_10
    
got_remainder:
    @ r0 now has remainder, r4 has quotient
    @ Convert remainder to ASCII and store
    add r6, r0, #'0'
    strb r6, [r2]
    add r2, r2, #1
    add r3, r3, #1
    
    @ Continue with quotient
    mov r0, r4
    b convert_loop

reverse_string:
    @ Null terminate
    mov r4, #0
    strb r4, [r2]
    
    @ Reverse the string (digits are backwards)
    ldr r1, =num_buf
    sub r2, r2, #1      @ point to last character
    
reverse_loop:
    cmp r1, r2
    bge reverse_done
    
    @ Swap characters
    ldrb r4, [r1]
    ldrb r5, [r2]
    strb r5, [r1]
    strb r4, [r2]
    
    add r1, r1, #1
    sub r2, r2, #1
    b reverse_loop

reverse_done:
    pop {r1-r7, lr}
    bx lr

@ ========================================
@ end_program: Exit the program
@ ========================================
end_program:
    mov r7, #1          @ sys_exit
    mov r0, #0          @ exit status
    svc #0