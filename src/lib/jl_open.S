// Open a file for reading and/or writing
//
// Input:
//      x0  - path
//      x1  - flags (O_RDONLY = 0, O_WRONLY = 1, O_RDWR = 2)
//   

.global jl_open

.text

jl_open:
    // prepare registers for sys call 56, openat
    // we need to set registers in this order to not overwrite input values
    mov x2, x1                  // flags, sent from caller to x1
    mov x1, x0                  // pathname, sent from caller to x0
    mov x0, #-100               // set file descriptro to AT_FDCWD (input path is relative to working dir)
    mov x3, #0                  // mode is not used, set to 0
    mov x8, #56                 // sys call 56

    svc #0
    ret