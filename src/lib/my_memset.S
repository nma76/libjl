.global jl_memset
// Fill a buffer with a specific value
//
// Input:
//      x0 is pointer to destination
//      x1 is value to set
//      x2 is number of bytes to set to value
//
// temporary registers:
//      x9  holds the original pointer sent via x0

.text

jl_memset:
    and w1, w1, #0xFF       // mask the lowest byte
    cbz x2, done            // early exit if x2 is zero
    mov x9, x0              // store original pointer to dest in x9

loop:
    strb w1, [x0], #1       // write one byte from w1 to dest and increase pointer by one
    subs x2, x2, #1
    b.ne loop

done:
    mov x0, x9              // move stored pointer to x0 (the return value)
    ret