.global jl_strchr
// Search a string for a specific character
//
// Input:
//      x0 is pointer to string to search
//      x1 is character to find
// returns:
//     pointer to the remaining string if char is found
//
// temporary registers:
//      w9  holds the current char

.text

jl_strchr:
    and w1, w1, #0xFF       // mask the lowest byte

loop:
    ldrb w9, [x0], #1       // read first character from source string into w9 and increase pointer by one
    cmp w1, w9              // compare it with character to search for
    b.eq found              // if chars match, go to found
    cbz w9, not_found       // if we reach end of string, jump to not_found
    b loop                  // continue loop

found:
    sub x0, x0, #1          // subtract one from pointer to include the char we searched for in the remaining string
    b done                  // jump to done

not_found:
    mov w0, #0              // set return value, x0, to zero if char was not found

done:
    ret