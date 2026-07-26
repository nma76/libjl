.global jl_getchar
// Read one char from stdin
//
// returns:
//      char read as int
//      EOF, -1
//      error, -1

.text

jl_getchar:
    // PROLOGUE: often used to store x29 and x30
    str x30, [sp, #-16]!        // allocate 16 bytes on the stack, store x30 (link register, return address)  

    // prepare for, and call, jl_read to read one char
    // result from jl_read 
    // x0 > 0 - we have read a chararcter
    // x0 == 0 - we did not recieve any character
    // x0 < 0 - error
    mov x0, #0
    add x1, sp, #8
    mov x2, #1
    bl jl_read

    cmp x0, #0                  // compare returned value against zero
    b.le fail                   // if x0 is less than, or equal to, zero: jump to fail since we want to return -1 in both cases

    ldrb w0, [sp, #8]           // if the value is positive, we have a char! Put it in w0!
    b done                      // jump to done

fail:
    mov x0, #-1

done:
    // EPILOGUE: often used to restore x29 and x30
    ldr x30, [sp], #16          // restore x30 from stack

    // return
    ret