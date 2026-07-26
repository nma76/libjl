.global jl_putchar
// Write one character to stdout
//
// Input:
//      x0 is character to write
// returns:
//     integer representation of char written

.text

jl_putchar:
    // PROLOGUE: often used to store x29 and x30
    str x30, [sp, #-16]!        // allocate 16 bytes on the stack, store x30 (link register, return address)  

    strb w0, [sp, #8]           // store character on the stack, 8 bytes in, to not overwrite the stored x30

    // prepare registers for jl_write
    mov x0, #1                  // set file descriptro to 1
    add x1, sp, #8              // get the character from stack
    mov x2, #1                  // one byte
    bl jl_write                 // call jl_write

    ldrb w0, [sp, #8]           // read saved char to x0 before return, and before vi restoring stack!

    // EPILOGUE: often used to restore x29 and x30
    ldr x30, [sp], #16          // restore x30 from stack

    ret