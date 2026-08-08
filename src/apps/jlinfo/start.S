// Main program for jlinfo
//
// scratch registers:
//      

.section .text

.global _start

_start:
    // clear terminal
    bl util_clear_screen

    // collect system information and store it in buffers
    bl uname_read
    bl cpuinfo_read
    bl meminfo_read
    
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
     