// Main program for jlinfo
//
// scratch registers:
//      
//
.section .rodata 
.align 4 

clear_screen: 
.ascii "\033[H\033[2J"

.include "macros.inc"

.section .text

.global _start

_start:
    // Clear Screen
    PRINT_STRING clear_screen

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
     