// Main program for jlinfo
//
// scratch registers:
//      

.section .text

.global _start

_start:
    // clear terminal
    bl clear_screen

    // read uname info
    bl init_uname

    // read cpu info
    bl init_cpuinfo
    
    // print info
    bl print_banner
    bl print_sys
    bl print_cpu
    bl print_mem
    bl print_usr

exit:
    // Exit using linux syscall
    mov x8, #93
    svc #0
     