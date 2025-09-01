.section .data
prompt_name: .ascii "What is your name? "
len_prompt_name = . - prompt_name

prompt_year: .ascii "What year were you born? "
len_prompt_year = . - prompt_year

greeting: .ascii "Hello "
len_greeting = . - greeting

comma: .ascii ", you are "
len_comma = . - comma

years: .ascii " years old.\n"
len_years = . - years

name_buf: .space 101
year_buf: .space 11
age_buf: .space 11

.section .text
.global _start

_start:
    // Printing "What is your name?"
    mov r7, #4  @ syscall: write
    mov r0, #1  @ fd = 1 stdout
    ldr r1, =prompt_name
    mov r2, #len_prompt_name
    svc #0

    // Reading user name. read(fd, name_buf, count)
    mov r7, #3  @ syscall: read
    mov r0, #0  @ fd = 0 stdin
    ldr r1, =name_buf
    mov r2, #100  @ max 100 chars
    svc #0

    // Save name length and remove newline
    mov r3, r0          // since r0 contains return value of function, r0 will contain no of characters including \n. If user types "San\n", r0 = 4. now r3 is length
    ldr r1, =name_buf
    mov r4, r1          // r4 points to name_buf
    mov r5, #0          // r5 = actual string length

find_name_len:
    ldrb r2, [r4]       // ldrb = load one byte. 53 61 6E 0A 00 ... S  a  n \n. r2 = 0x53. Read a character at a time
    cmp r2, #0          // check for null ('\0')
    beq name_len_done
    cmp r2, #10         // check for newline (\n = ASCII 10)
    beq name_len_done
    add r5, r5, #1      // increment actual length
    add r4, r4, #1      // because of ldrb, move by 1
    cmp r5, r3          // ensure we don't exceed read length r5(actual length), r3(total number of bytes read)
    blt find_name_len
    
name_len_done:
    mov r2, #0          // set r2 = null
    strb r2, [r4]       // replace newline with '\0'
    mov r8, r5          // r8 = actual name length (preserve)

    // Prompt for year
    mov r7, #4
    mov r0, #1
    ldr r1, =prompt_year
    mov r2, #len_prompt_year
    svc #0

    // Read year
    mov r7, #3
    mov r0, #0
    ldr r1, =year_buf
    mov r2, #10 // number of bytes to read
    svc #0

    // Convert year to integer (atoi)
    ldr r1, =year_buf // point again after syscall
    mov r4, #0          // result

atoi_loop:
    ldrb r2, [r1]       // load the current character
    add r1, #1          // move to next character

    cmp r2, #'0'        // check if r2 is digit 0
    blt atoi_done       // if less than 0
    cmp r2, #'9'        // check if r2 is digit 9
    bgt atoi_done       // if greatern than 9

    sub r2, #'0'        // '3' - '0' = 51 - 48 = 3 (ASCII Conversion)
    mul r4, r4, #10      // multiply accumulated result by 10
    add r4, r4, r2       // add current digit
    
    b atoi_loop


atoi_done:

    // Calculate age
    mov r5, #2025
    sub r5, r5, r4      // age = 2025 - birth_year

    // Convert age to string (itoa)
    ldr r1, =age_buf + 9 // r1 points to age_buf[9]. age_buf[9] because we build string backward from LSB to MSB.
    mov r2, #0          // r2 = null
    strb r2, [r1]       // null terminate at age_buf[9]
    mov r0, #10         // base 10 

itoa_loop:
    sub r1, r1, #1      // move pointer backward. start writing at age_buf[8]
    udiv r3, r5, r0     // r3 = r5 / 10 (udiv - unsigned division). If r5 = 25, r3 = 25 / 10 = 2
    mls r2, r0, r3, r5  // r2 = remainder = r5 - r3 * 10. r2 = 25 - (10*2) = 5
    add r2, r2, #'0'    // convert 5 -> ASCII '5'
    strb r2, [r1]       // store '5' at age_buf[8]
    mov r5, r3          // r5 = quotient for next iteration
    cmp r5, #0          // If quotient is 0, finish
    bne itoa_loop

    // Save age string start pointer
    mov r6, r1          // r6 = start of age string

    // Output greeting: "Hello "
    mov r7, #4
    mov r0, #1
    ldr r1, =greeting
    mov r2, #len_greeting
    svc #0

    // Output name
    mov r7, #4
    mov r0, #1
    ldr r1, =name_buf
    mov r2, r8          // use preserved name length
    svc #0

    // Output ", you are "
    mov r7, #4
    mov r0, #1
    ldr r1, =comma
    mov r2, #len_comma
    svc #0

    // Output age
    mov r7, #4
    mov r0, #1
    mov r1, r6          // restore age string start
    ldr r4, =age_buf + 9 // r4 points to the last digit position which is null though.
    sub r2, r4, r1      // r1 points to first digit. r2 = length = last digit - first digit 
    svc #0

    // Output " years old.\n"
    mov r7, #4
    mov r0, #1
    ldr r1, =years
    mov r2, #len_years
    svc #0

    // Exit
    mov r7, #1
    mov r0, #0
    svc #0