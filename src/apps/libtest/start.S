.section .rodata
hello_msg:
    .asciz "Hello world!\n"
number_msg:
    .asciz "The number is: "
newline:
    .asciz "\n"

.section .bss
.align 3
buffer:
    .space 33

.global _start

.section .text

_start:
    // print hello world message
    ldr x0, =hello_msg          // load pointer to message
    bl jl_puts                  // print using jl_puts

    // call jl_itoa to convert the number 42 to string
    mov x0, #42
    ldr x1, =buffer
    bl jl_itoa

    // print the number returned by jl_itoa
    ldr x0, =number_msg
    bl jl_puts

    ldr x0, =buffer
    bl jl_puts

    ldr x0, =newline
    bl jl_puts

    mov x8, #93                 // exit syscall
    svc #0                      // invoke syscall
     