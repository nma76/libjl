.global jl_strcpy
// Copy a string to another
//
// Input:
//      x0 is pointer to destination
//      x1 is pointer to source
// returns:
//     pointer to destination
//
// temporary registers:
//      x9  holds the original pointer sent to x0
//      w10 holds the current character

.text

jl_strcpy:
    mov x9, x0              // store original pointer to dest in x9

loop:
    ldrb w10, [x1], #1       // read first character from source into w2 and increase pointer by one
    strb w10, [x0], #1       // copy character from w2 to dest and increase pointer by one
    cbz w10, done            // goto done if character is zero
    b loop                  // read next character

done:
    mov x0, x9              // move stored pointer to dest to x0
    ret                     // return