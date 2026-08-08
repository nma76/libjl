// Main program for jlinfo
//
// scratch registers:
//      

.section .text

.global _start

_start:
    // clear terminal
    bl util_clear_screen

    // read uname info
    bl uname_read

    // read cpu info
    bl cpuinfo_read
    
    // print info
    bl banner_print
    bl system_print
    bl cpu_print
    bl memory_print
    bl user_print

exit:
    // Exit using linux syscall
    mov x8, #93
    svc #0
     