.global jl_atoi
// Parse string and returns integer at the beginning. 
// It accepts initial whitespaces, plus and minus signs. As soon as we found a digit, whitespaces, plus and minus are treated as any other character
//
// Accepted:
//      "123"
//      "   -123"
//      "+123abc"
//
// Rejected:
//      ""
//      "abc123"
//      "+"
//
// Input:
//      x0 is pointer to source string
//      x1 is pointer to int value, the result
// returns:
//     bool signaling if function is successfull or not
//
// temporary registers:
//      w9  holds the current character
//      w10 current digit if any is found
//      w11 holds the result until we are finnished. Then it goes into our pointer at x1
//      w12 holds our multiplier: the number 10. MADD (Multiply-Add) needs registry, not values
//      w13 holds our state.
//          0 - No digits seen yet
//          1 - plus/minus sign seen, but no digits
//          2 - digits found
//      w14 holds if number is positive or negative
//          0 - no minus found so our number is positive
//          1 - minus found before any digits, so our number is negative

.text

jl_atoi:
    // PROLOGUE: often used to store x29 and x30
    str x30, [sp, #-16]!        // allocate 16 bytes on the stack, store x30 (link register, return address)  

    // Store our multiplier in w12. Used by MADD later
    mov w12, #10

    // Set the state to zero
    mov w13, #0

    // Set neg/pos flag to zero
    mov w14, #0

    // use w11 to store the int value. We start by setting it to 0
    mov w11, #0

// The main loop
loop:
    // 1. Load next byte and check if we reach end of string
    ldrb w9, [x0], #1           // load next byte into w9
    cbz w9, check_parse_status  // if byte is null, we are done! todo: if this occurs before we hit the first digit, it's a fail

    // 2. Check whitespaces
    // if w13 > 0, whitespaces isn't aloud anymore
    sub w10, w9, #9             // subtract 9 from the char. 
    cmp w10, #4                 // compare w10 to #4. if w10 is lower than, or equal to, #4 we have a whitespace character: \t, \n, \v, \f, \r (ASCII 39, 10, 11, 12, 13)
    b.ls handle_whitespace
    cmp w9, #32                 // compare w10 with #32 (ASCII for space)
    b.eq handle_whitespace         

    // 3. Check for +/- signs
    // They can only occur first, w13 == 0
    cmp w13, #0                 // compare w13 to 0
    b.ne parse_digits           // w13 != 0, continue parse digits
    cmp w9, #43                 // subtract 43 from the char, if result is zero we found a + sign
    b.eq plus_found 
    cmp w9, #45                 // substract 45 from the char, if result is zero we found a - sign
    b.eq minus_found

parse_digits:
    // 4. Parse digits
    // Check if char is a digit (0-9 is ASCII 48-57)
    sub w10, w9, #48            // subtract 48 from the char
    cmp w10, #9                 // compare w10 to #9. if w10 is lower than, or equal to, #9 we have a digit.
    b.ls is_a_digit

    // w9 is not a digit!
    cmp w13, #2                 // if state is 2 (we know we have read digits earlier) 
    b.eq success                // jump to success and return ehatever value already parsed
    b fail                      // else, we fail!

    // We know w10 holds the digit at this point. So it's afe to add to the result
is_a_digit:    
    mov w13, #2                 // set state to 2, digits found
    madd w11, w11, w12, w10     // for each digit, we need to do: result (w11) = result (w11) * 10 (w12) + current digit (w10)
    b loop                      // continue loop
// Main loop ends

// Helper routines
handle_whitespace:
    cmp w13, #0                 // state is 0, meaning whitespace is found before any digits. Back too loop and read the next byte!
    b.eq loop
    cmp w13, #2                 // 2 means parsing has started and we already had found digits
    b.eq success                // in this case, end parsing and return whatever value we have
    b fail                      // in any other case we fail

plus_found:
    mov w13, #1                 // plus-sign found, set state to 1, plus/minus sign seen, but no digits
    b loop                      // back to main loop

minus_found:
    mov w13, #1                 // minus-sign found, set state to 1, plus/minus sign seen, but no digits
    mov w14, #1                 // number is negative and should be inverted at the end. We calculate a positive number until parsing is done
    b loop                      // back to main loop

check_parse_status:
    cmp w13, #2
    b.eq success
    b fail

// End of helper routines

fail:
    str wzr, [x1]               // sätt pointer value to zero to avoid returning a value when function fails
    mov w0, #0                  // return false
    b epilogue                  // jump to epilogue

success:
    cmp w14, #1                 // is number negative?
    b.ne store_result           // not a negative number, jump to store the number as it is
    neg w11, w11                // if it's negative (minus sign found) make number negative

store_result:
    str w11, [x1]               // store calculated value at our pointer
    mov w0, #1                  // return true
    
epilogue: 
    // EPILOGUE: often used to restore x29 and x30
    ldr x30, [sp], #16          // restore x30 from stack
    ret