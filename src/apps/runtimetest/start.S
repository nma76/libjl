.global _start

.section .bss
.align 3
buffer:
    .space 33

.section .text

_start:
    // Init runtime
    mov x0,sp                   // copy stack pointer to x0 as my_runtime.S uses it as input
    bl runtime_init
    // init finished

    // Test argv.S
    mov x0, #2                  // Input: index of the argv we want pointer to
    bl argv_get                 // call argv_get to get the pointer

    // convert to ascii so we can print the pointer as number
    //ldr x1, =buffer         // buffer holding the result
    //bl my_itoa              // call my_itoa

    //ldr x0, =buffer         // load buffer to print into x0
    bl my_puts
    //

    // Test runtime.S
    //bl runtime_get_argc
    //
    //ldr x1, =buffer         // buffer holding the result
    //bl my_itoa              // call my_itoa
    //
    //ldr x0, =buffer         // load buffer to print into x0
    //bl my_puts


    // Exit using linux syscall
    mov x8, #93                 // exit syscall
    svc #0                      // invoke syscall
     