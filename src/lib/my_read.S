.global jl_read
// Reads from stdin
//
// Input:
//      x0 is file descriptor
//      x1 is pointer to buffer
//      x2 is number of bytes
// returns:
//     ssize_t, size of read data


.text

jl_read:
    mov x8, #63         // read syscall is number 63
    svc #0              // execute system call
    ret                 // return