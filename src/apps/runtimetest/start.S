.section .rodata
envp_name:
    .asciz "SHELL"
failed_str:
    .asciz "FAIL"

.section .bss
.align 3
buffer:
    .space 33

.global _start

.section .text

_start:
    // Init runtime
    mov x0, sp                   // copy stack pointer to x0 as my_runtime.S uses it as input
    bl runtime_init
    // init finished

    //bl runtime_get_envp
    //ldr x0, [x0]
    //bl my_puts

    // test envp.S
    ldr x0, =envp_name
    bl envp_get

    cbz x0, failed

    bl my_puts

    b exit

failed:
    ldr x0, =failed_str
    bl my_puts

    // Test argv.S
    //mov x0, #2                  // Input: index of the argv we want pointer to
    //bl argv_get                 // call argv_get to get the pointer
    //bl my_puts
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
exit:
    mov x8, #93                 // exit syscall
    svc #0                      // invoke syscall
     