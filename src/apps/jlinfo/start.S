// Main program for jlinfo
//
// scratch registers:
//      
//

.section .text

.global _start

_start:
    bl print_banner
    bl print_cpu
    bl print_mem

exit:
    // Exit using linux syscall
    mov x8, #93                         // exit syscall
    svc #0                              // invoke syscall
     