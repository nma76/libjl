// Open a file for reading and/or writing
//
// Input:
//      x0  - file descriptor to close
//   

.global jl_close

.text

jl_close:
    // prepare registers for sys call 57, close
    // we need to set registers in this order to not overwrite input values
    mov x8, #57                 // sys call 57
    svc #0
    ret