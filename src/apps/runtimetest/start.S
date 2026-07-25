.global _start

.section .bss
.align 3
buffer:
    .space 33

.section .text

_start:
    mov x0,sp                   // copy stack pointer to x0 as my_runtime.S uses it as input

    bl runtime_init
    bl runtime_get_auxv

    ldr x1, =buffer         // buffer holding the result
    bl my_itoa              // call my_itoa

    ldr x0, =buffer         // load buffer to print into x0
    bl my_puts


    // Exit using linux syscall
    mov x8, #93                 // exit syscall
    svc #0                      // invoke syscall
     