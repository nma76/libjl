.global jl_strlen
// Counts length of a string
//
// Input:
//      x0 is pointer to our string
// returns:
//     size_t, length of string
//
// temporary registers:
//      w9  holds the current character
//      w10 holds our counter

.text

jl_strlen:
    mov w10, #0              // set x1 to zero. This is our string length counter

loop:
    ldrb w9, [x0], #1       // Read first character into w9 and increase pointer (x0) by 1
    cbz w9, done            // go to done if character in w9 is zero
    add w10, w10, #1        // increase x1 by one
    b loop                  // continue loop

done:
    mov w0, w10             // copy x1 (string length) to x0
    ret                     // return