//
// Misc utils
//
.section .rodata 
.align 4 

util_clear_screen_string: 
.asciz "\033[H\033[2J"

.include "macros.inc"

.section .text

.global util_clear_screen
.global util_find_key_value

//
// util_clear_screen
//      sends character sequence to terminal to clear screen
//
util_clear_screen:
    // PROLOGUE: often used to store x29 and x30
    PROLOGUE

    // Clear Screen
    PRINT_STRING util_clear_screen_string

    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE

//
// util_find_key_value
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
//      x21 counter, number of bytes to copy 
//
util_find_key_value:
    // PROLOGUE: often used to store x29 and x30
    PROLOGUE
    stp x19, x20, [sp, #-16]!               // Store callee-saved registers so we can restore them later
    str x21, [sp, #-16]!

    mov x21, #-1

    bl jl_strstr                            // call jl_strstr to find the first occurance if the key
    cbz x0, util_find_key_value_done             // if no hit, jump to end!

    mov x1, #':'                            // search for : starting at the first occurance of key found
    bl jl_strchr
    cbz x0, util_find_key_value_done        // if no hit, jump to end!

    add x0, x0, #2                          // move pointer 2 bytes to skip : and whitespace
    ldrb w19, [x0]                          // load character at x0 so we can check if it's null
    cbz x19, util_find_key_value_done            // and if so, jump to end

    mov x20, x0                             // copy pointer in x0 to x20 so we can loop/increase it
util_find_key_value_newline_loop:           // loop to find \n, which signals end of value
    ldrb w19, [x20], #1                     // read the next byte from pointer 
    cbz w19, util_find_key_value_done       // if we for some reason reached end without finding a new line
    add x21, x21, #1
    cmp w19, #10                            // did we find newline? (\n is ascii 10)
    b.ne util_find_key_value_newline_loop

    mov x1, x0                              // user jl_memcpy to copy the found number of bytes representing the value. We copy the value to not modify the original buffer
    adrp x0, global_temp_value_buffer       // add pointer to temp_bugger where we store the sub-string
    add x0, x0, :lo12:global_temp_value_buffer
    mov x2, x21                             // jl_memcpy want number of bytes to copy in x2, and our counter is in x21
    bl jl_memcpy                            // copy the value

util_find_key_value_done:
    str x21, [sp], #16
    ldp x19, x20, [sp], #16                 // restore callee-saved registers

    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE
