// Runtime used for apps
//
// Input:
//      x0 stack pointer
//
// temporary registers:
//      x9      
//      x10     

.global runtime_init
.global runtime_get_argc
.global runtime_get_argv
.global runtime_get_envp

.section .data
runtime_saved_sp:
    .quad 0

.text

runtime_init:
    ldr x9, =runtime_saved_sp     // load address to variable into x9
    str x0, [x9]                    // save pointer in x0 to variable

    ret

runtime_get_argc:
    //
    // ARGC
    //
    ldr x9, =runtime_saved_sp     // load address to variable into x9
    ldr x9, [x9]                    // load stackpointer at x9 and store it to x9 (overwrite)
    ldr x0, [x9]                    // load the value at pointer in x9 into x0, this is the register for return value
    ret

runtime_get_argv:
    ret

runtime_get_envp:
    ret