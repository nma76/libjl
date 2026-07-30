// Main program for jlinfo
//
// scratch registers:
//      

.section .text

.global _start

_start:
    // clear terminal
    bl clear_screen

    // read uname inte global variables
    bl read_uname

    // Print Sys info
    bl print_banner
    bl print_sys
    bl print_cpu
    bl print_mem
    bl print_usr

exit:
    // Exit using linux syscall
    mov x8, #93                         // exit syscall
    svc #0                              // invoke syscall
     