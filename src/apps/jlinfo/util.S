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
.global find_value

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
// find_value
//      finds the value of the first ocurencs of key in a text formatted like /proc/cpuinfo:
//      key : value
//
//  parameters:
//      x0  pointer to text to search
//      x1  pointer to key to look for
//  returns:
//      pointer to value
//
find_value:
    // PROLOGUE: often used to store x29 and x30
    PROLOGUE

    // just to remember to document them!!
    mov x19, #0
    mov x20, #0
    mov x21, #0

    bl jl_strstr                            // call jl_strstr to find the first occurance if the key
    cbz x0, find_value_not_found            // if no hit, jump to end!

    mov x1, #':'
    bl jl_strchr
    cbz x0, find_value_not_found            // if no hit, jump to end!

    add x0, x0, #2                          // move pointer 2 bytes to skip : and whitespace
    cbz x0, find_value_not_found            // if we reached a null value, there's no value

    mov x20, x0                             // copy pointer in x0 to x20 so we can loop/increase it
find_value_newline_loop:                    // loop to find \n, whicj signals end of value
    ldrb w19, [x20], #1                     // read the next byte from pointer 
    cbz w19, find_value_not_found           // if we for some reason reached end without finding  a new line
    add x21, x21, #1                        // increase counter to store number of bytes to copy
    cmp w19, #10                            // did we find newline?
    b.ne find_value_newline_loop

    mov x1, x0                              // user jl_memcpy to copy the found number of bytes representing the vlaue
    adrp x0, temp_buffer                    // add pointer to temp_bugger where we store the sub-string
    add x0, x0, :lo12:temp_buffer
    mov x2, x21                             // jl_memcpy want number of bytes to copy in x2, and our counter is in x21
    bl jl_memcpy                            // copy the value

find_value_not_found:
    
    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE
