//
// Misc utils
//
.section .rodata 
.align 4 

clear_screen_string: 
.asciz "\033[H\033[2J"

.include "macros.inc"

.section .text

.global clear_screen
.global find_key_value

//
// clear_screen
//      sends character sequence to terminal to clear screen
//
clear_screen:
    // PROLOGUE: often used to store x29 and x30
    PROLOGUE

    // Clear Screen
    PRINT_STRING clear_screen_string

    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE

//
// find_key_value
//      finds the value of the first ocurencs of key in a text formatted like /proc/cpuinfo:
//      key : value
//
//  parameters:
//      x0  pointer to text to search
//      x1  pointer to key to look for
//  returns:
//      pointer to value
//
//  temporary registers
//      x19 current character in value
//      x20 copy of the pointer in x0, used in loop
//
find_key_value:
    // PROLOGUE: often used to store x29 and x30
    PROLOGUE
    stp x19, x20, [sp, #-16]!               // Store callee-saved registers so we can restore them later

    bl jl_strstr                            // call jl_strstr to find the first occurance if the key
    cbz x0, find_key_value_done                 // if no hit, jump to end!

    mov x1, #':'                            // search for : starting at the first occurance of key found
    bl jl_strchr
    cbz x0, find_key_value_done                 // if no hit, jump to end!

    add x0, x0, #2                          // move pointer 2 bytes to skip : and whitespace
    ldrb w19, [x0]                          // load character at x0 so we can check if it's null
    cbz x19, find_key_value_done                // and if so, jump to end

    mov x20, x0                             // copy pointer in x0 to x20 so we can loop/increase it
find_key_value_newline_loop:                    // loop to find \n, which signals end of value
    ldrb w19, [x20], #1                     // read the next byte from pointer 
    cbz w19, find_key_value_done                // if we for some reason reached end without finding a new line
    cmp w19, #10                            // did we find newline? (\n is ascii 10)
    b.ne find_key_value_newline_loop
    strb wzr, [x20, #-1]                    // overwrite \n with \0

find_key_value_done:
    ldp x19, x20, [sp], #16                 // restore callee-saved registers

    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE
