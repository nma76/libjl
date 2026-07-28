.global _start

.section .text

_start:
    bl print_banner

exit:
    // Exit using linux syscall
    mov x8, #93                         // exit syscall
    svc #0                              // invoke syscall
     