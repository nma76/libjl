.global jl_strcmp
// Compare two strings
//
// Input:
//      x0 is pointer to string one
//      x1 is pointer to string two
// returns:
//     integer < 0 if string one is less, > 0 if string two is less and 0 if equal
//
// temporary registers:
//      w9  current char from string one
//      w10 current char from string two

.text

jl_strcmp:

loop:
    ldrb w9, [x0], #1       // read first character from x0 into w9 and increate pointer by one
    ldrb w10, [x1], #1       // read first character from x1 into w3 and increase pointer by one
    cmp w9, w10              // compare characters 
    b.ne done               // characters are not equal, exit
    cbz w9, done            // if equal and zero, exit
    b loop                  // else back to loop and read next character

done:
    sub w0, w9, w10          // set the difference as return value
    ret