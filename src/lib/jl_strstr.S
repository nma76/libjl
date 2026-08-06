.global jl_strstr
// Search a string for a specific string
//
// for each position in haystack, compare to needle, if needle reach end return startposition
//
// Input:
//      x0 is pointer to haystack, the string to search
//      x1 is pointer to needle, the string to find
// returns:
//     pointer to the first char where the string is located, or null
//
// temporary registers:
//      x2      current haystack position in outer loop
//      x3      current haystack position in inner loop
//      x4      current needle pointer in inner loop
//      w10     byte read from needle
//      w11     byte read from haystack

.text

jl_strstr:
    // prologue - save link register and x0 on the stack
    str x30, [sp, #-16]!            // allocate 16 bytes on the stack, store x30 (link register, return address)  

    mov x2, x0                      // x2 = current haystack position (outer loop)

outer_loop:
    ldrb w11, [x2]                   // read byte from haystack
    cbz w11, not_found               // end of haystack = no match

    mov x3, x2                      // x3 = current haystack position (inner loop)
    mov x4, x1                      // x4 = current needle pointer (inner loop)

inner_loop:
    ldrb w10, [x4], #1              // read byte from needle
    cbz w10, found                  // end of needle = full match

    ldrb w11, [x3], #1              // read byte from haystack
    cbz w11, next_outer             // haystack ended before needle = no match

    cmp w10, w11
    b.ne next_outer                 // chars don't match = try next haystack position

    b inner_loop                    // continue matching

next_outer:
    add x2, x2, #1                  // move to next haystack position
    b outer_loop

found:
    mov x0, x2                      // return pointer to start of match
    b done

not_found:
    mov x0, #0

done:
    ldr x30, [sp], #16              // restore x30 from stack
    ret
