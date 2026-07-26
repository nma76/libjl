.global jl_puts
// Write string to stdout
//
// Input:
//      x0 is pointer to string
// returns:
//     on success, a non-negative value, the length written in bytes

.text

jl_puts:
    // PROLOGUE: often used to store x29 and x30
    str x30, [sp, #-16]!        // allocate 16 bytes on the stack and store x30 (link register, return address).

    // we store x0 since later calls will overwrite it with it's return values
    str x0, [sp, #8]           // store pointer in x0 on the stack, 8 bytes in, to not overwrite the stored x30

    // prepare and call jl_strlen
    // x0 should hold pointer to string, and it alreay does since jl_puts also uses const char *str as calling argument
    // which means we can call jl_strlen right away!
    bl jl_strlen                // call jl_strlen to get length of string to print using jl_write.

    // prepare and call jl_write
    mov x2, x0                  // length is in x0 since it's the return value from jl_strlen. use it before it's overwritten.
    mov x0, #1                  // set file descriptor to 1
    ldr x1, [sp, #8]            // load value stored in stack to x1. This is what we want to print.
    bl jl_write                 // call jl_write, which returns length of printed string into x0 which we can return!

    // EPILOGUE: often used to restore x29 and x30
    ldr x30, [sp], #16          // restore x30 from stack

    ret
