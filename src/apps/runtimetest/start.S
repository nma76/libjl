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

    b test_argv_exists

    // test envp_exists
test_envp_exists:
    ldr x0, =envp_name      // name to look for
    bl envp_exists          // check if exists, result is in x0
    ldr x1, =buffer         // buffer holding the result
    bl my_itoa              // call my_itoa to get a digit
    
    ldr x0, =buffer         // load buffer to print into x0
    bl my_puts              // print result
    b exit


    // test envp_get
test_envp_get:
    ldr x0, =envp_name
    bl envp_get

    cbz x0, failed

    bl my_puts

    b exit

failed:
    ldr x0, =failed_str
    bl my_puts
    b exit



    // test argv_exists
test_argv_exists:
    mov x0, #3              // argument index to look for
    bl argv_exists          // check if exists, result is in x0
    ldr x1, =buffer         // buffer holding the result
    bl my_itoa              // call my_itoa to get a digit
    
    ldr x0, =buffer         // load buffer to print into x0
    bl my_puts              // print result
    b exit


    // Test argv_get
test_argv_get:    
    mov x0, #1                  // Input: index of the argv we want pointer to
    bl argv_get                 // call argv_get to get the pointer
    bl my_puts

    b exit

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
     