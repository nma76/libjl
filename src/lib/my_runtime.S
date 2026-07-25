// Runtime used for apps written in assembly
//
// Input:
//      x0 stack pointer
//
// temporary registers:
//      x9      
//      x10  
//      x11   

.global runtime_init
.global runtime_get_argc
.global runtime_get_argv
.global runtime_get_envp
.global runtime_get_auxv

.section .data
runtime_saved_sp:
    .quad 0

.text

runtime_init:
    ldr x9, =runtime_saved_sp       // load address to variable into x9
    str x0, [x9]                    // save pointer in x0 to variable

    ret

runtime_get_argc:
    ldr x9, =runtime_saved_sp       // load address to variable into x9
    ldr x9, [x9]                    // load stackpointer at x9 and store it to x9 (overwrite)
    ldr x0, [x9]                    // load the value at pointer in x9 into x0, this is the register for return value
    ret

runtime_get_argv:
    ldr x9, =runtime_saved_sp       // load address to variable into x9
    ldr x9, [x9]                    // load saved stackpointer at x9 and store it to x9 (overwrite)
    add x0, x9, #8                  // add 8 bytes to the stored, initial, pointer. We know ARGV is located there
    ret

runtime_get_envp:
    ldr x9, =runtime_saved_sp       // load address to variable into x9
    ldr x9, [x9]                    // load saved stackpointer at x9 and store it to x9 (overwrite)
    ldr x10, [x9]                   // load the value (argc) at pointer in x9 into x10, this is the register for return value

    mov x11, #8                     // store the nuber 8, this is our multiplicand
    add x10, x10, #1                // add #1 to the stored argc. the formula to find first envp is: SP + (argc+1)*8
    madd x0, x10, x11, x9           // multiply argc by 8 and add another 8 and store it in x0. x0 now points to envp[0]
    ret

runtime_get_auxv:
    str x30, [sp, #-16]!            // allocate 16 bytes on the stack, store x30 (link register, return address)  
    bl runtime_get_envp             // get pointer to envp into x0
    ldr x30, [sp], #16              // restore x30 from stack

runtime_get_aux_loop:    
    ldr x9, [x0], #8                // read current envp pointer and advance to next enttry
    cbnz x9, runtime_get_aux_loop   // if x21 is NULL, we have reached the end
    ret