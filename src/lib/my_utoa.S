.global jl_utoa
// Converts an uint64_t integer to string
//
// Accepted:
//      Any unsigned integer
//
// Input:
//      x0 is source unsigned int
//      x1 is pointer to result
// returns:
//     bool signaling if function is successfull or not
//
// temporary registers:
//      x9      is a constant containing the value 10. It's used to calculate modulo with sdiv
//      x10     holds the digit/char we currently working on
//      x11     is a flag that decides if we just count bytes or do the conversion
//                  0 means count bytes
//                  1 means do conversion
//      x12     is our counter that holds the length we need to reserve for the final string
//      x13     holds a copy of the original int in x0, used in loop for calculations

.text

// todo, handle negative integers. Maybe use NEG and store a flag so we can use NEG again at end?
jl_utoa:
    // PROLOGUE: often used to store x29 and x30
    str x30, [sp, #-16]!        // allocate 16 bytes on the stack, store x30 (link register, return address)  

    mov x9, #10                 // store the value #10 in w9 to do modulo calculations   
    mov x10, #0                 // initialize w10. Probably not neccessary, but better safe than sorry...
    mov x11, #0                 // set flag to 0, count the bytes
    mov x12, #0                 // length is initialized at 0. this has to be done before we check if number is negative

init:
    mov x13, x0                 // copy x0 to w13 so we can do maths without destroying the original integer

// The main loop
loop:
    // 1. Use modulo 10 to get the last digit and store it in w10
    udiv x10, x13 ,x9            // first, devide the input int by 10 and store it in w10
    msub x10, x10, x9, x13       // 

    // 2. convert the digit to ASCII character
    add x10, x10, #48           // we need to convert digit to ASCII. We can do that by adding 48
    
    // 3. Decide whether we should store result, or continue counting
    cmp x11, #1                 // if flag is set to 1, insert the number into a register holding the result.
    b.eq store_result

    add x12, x12, #1            // otherwise, increase counter

next_digit:
    udiv x13, x13, x9           // divide by 10 to get the next number to work with. Eg the number 123 becomes 12.

    cmp x13, #0                 // if x0 is not 0, continue loop
    b.ne loop

    cmp x11, #1                 // if w11 is set to 1, we are done
    b.eq success
    b start_conversion          // if not, it's time to reserve space and do the conversiobn
// Main loop ends

// Helper routines
start_conversion:
    mov x11, #1                 // set flag to 1, meaning from now on we store result instead of counting length
    mov x13, x0                 // restore w13 from x0 so we can start the loop over again with the original integer
    add x1, x1, x12             // move x1 with the bytes measured in the initial loop so we can write backwards
    strb wzr, [x1]              // write 0 termination at the last position
    b loop                      // start the loop over again

store_result:
    strb w10, [x1, #-1]!        // store the current character and move pointer one step towards the beginning. We write backwards
    b next_digit                // continue with the next digit

// End of helper routines

success:
    mov w0, #1                  // set return value to true
    b done

done:
    // EPILOGUE: often used to restore x29 and x30
    ldr x30, [sp], #16          // restore x30 from stack

    ret