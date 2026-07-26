.global jl_memcpy
// Compare two strings
//
// Input:
//      x0 is pointer to destination
//      x1 is pointer to source
//      x2 is number of bytes to copy
//
// temporary registers:
//      x9  holds original pointer sent to x0
//      w10 holds the current byte to copy

.text

jl_memcpy:
    cbz x2, done            // early exit if x2 is zero
    mov x9, x0              // store original pointer to dest in x9

loop:
    ldrb w10, [x1], #1      // read first byte from source into w10 and increase pointer by one
    strb w10, [x0], #1      // store byte from w10 to dest and increase pointer by one
    subs x2, x2, #1         // decrease counter by one
    b.ne loop               // continue loop if x2 is not zero

done:
    mov x0, x9              // move stored pointer to x0 (the return value)
    ret