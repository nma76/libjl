// Runtime used for apps
//
// Input:
//      x0 stack pointer
//
// temporary registers:
//      w9      is a constant containing the value 10. It's used to calculate modulo with sdiv
//      w10     holds the digit/char we currently working on

.global runtime_init
.global runtime_get_argc
.global runtime_get_argv
.global runtime_get_envp

.section .data
runtime_argc:
    .quad 0

.text

runtime_init:
    // Initialize scratch registers
    mov x9, #0              // x9 is used as temporary storage when needed
    mov x10, #0             // x10 is used to temporary store stack pointer

    // Init stuff
    add x10, sp, #8         // store stack pointer so we can step by 8 instead of 16

    //
    // ARGC
    //
    ldr x9, [sp]            // load argc into register x19
    ldr x0, =runtime_argc   // load adress to runtime_argc from x0
    str x9, [x0]            // write value from x19 into address in x0 (runtime_args)

    ret

runtime_get_argc:
    ldr x0, =runtime_argc
    ldr x0, [x0]
    ret

runtime_get_argv:
    ret

runtime_get_envp:
    ret