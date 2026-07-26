.global jl_itoa
// Converts an integer to string
//
// Accepted:
//      Any integer
//
// Rejected:
//      Numbers that are to large for integer
//
// Input:
//      x0 is source int
//      x1 is pointer to result
// returns:
//     bool signaling if function is successfull or not
//
// temporary registers:
//      w9      is a constant containing the value 10. It's used to calculate modulo with udiv
//      w10     holds the digit/char we currently working on
//      w11     is a flag that decides if we just count bytes or do the conversion
//                  0 means count bytes
//                  1 means do conversion
//      w12     is our counter that holds the length we need to reserve for the final string
//      w13     holds a copy of the original int in x0, used in loop for calculations
//      w14     flag signaling the number is negative

.text

jl_itoa:
    // PROLOGUE: often used to store x29 and x30
    str x30, [sp, #-16]!        // allocate 16 bytes on the stack, store x30 (link register, return address)  

    mov w9, #10                 // store the value #10 in w9 to do modulo calculations   
    mov w10, #0                 // initialize w10. Probably not neccessary, but better safe than sorry...
    mov w11, #0                 // set flag to 0, count the bytes
    mov w12, #0                 // length is initialized at 0. this has to be done before we check if number is negative
    mov w14, #0                 // flag signaling the integer is negative

    cmp w0, #0                  // is passed integer negative?
    b.lt is_negative            // in case it is, we need to invert it, make room for - sign and set w14 flag begore we continue

init:
    mov w13, w0                 // copy x0 to w13 so we can do maths without destroying the original integer

// The main loop
loop:
    // 1. Use modulo 10 to get the last digit and store it in w10
    udiv w10, w13 ,w9            // first, devide the input int by 10 and store it in w10
    msub w10, w10, w9, w13       // 

    // 2. convert the digit to ASCII character
    add w10, w10, #48           // we need to convert digit to ASCII. We can do that by adding 48
    
    // 3. Decide whether we should store result, or continue counting
    cmp w11, #1                 // if flag is set to 1, insert the number into a register holding the result.
    b.eq store_result

    add w12, w12, #1            // otherwise, increase counter

next_digit:
    udiv w13, w13, w9           // divide by 10 to get the next number to work with. Eg the number 123 becomes 12.

    cmp w13, #0                 // if x0 is not 0, continue loop
    b.ne loop

    cmp w11, #1                 // if w11 is set to 1, we are done
    b.eq success
    b start_conversion          // if not, it's time to reserve space and do the conversiobn
// Main loop ends

// Helper routines
start_conversion:
    mov w11, #1                 // set flag to 1, meaning from now on we store result instead of counting length
    mov w13, w0                 // restore w13 from x0 so we can start the loop over again with the original integer
    add x1, x1, x12             // move x1 with the bytes measured in the initial loop so we can write backwards
    strb wzr, [x1]              // write 0 termination at the last position
    b loop                      // start the loop over again

store_result:
    strb w10, [x1, #-1]!        // store the current character and move pointer one step towards the beginning. We write backwards
    b next_digit                // continue with the next digit

is_negative:
    mov w14, #1                 // set flag indicating int is negative
    neg w0, w0                  // invert w0, our passed integer. This works on INT_MIN bc we are working with w-registers and udiv
    add w12, w12, #1            // make room for - sign by adding 1 to the counter counting bytes needed
    b init

// End of helper routines

success:
    mov x0, #1                  // set return value to true
    cmp w14, #1                 // check if we should insert a - sign at first position
    b.eq insert_minus
    b done

insert_minus:
    mov w10, #45
    strb w10, [x1, #-1]!

done:
    // EPILOGUE: often used to restore x29 and x30
    ldr x30, [sp], #16          // restore x30 from stack

    ret