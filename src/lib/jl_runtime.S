// Runtime used for apps written in assembly
//
// Input:
//      x0  - stack pointer
//
// scratch registers:
//      x9  - pointer passed to the runtime in x0
//      x10 - used for address calcuations 
//      x11 - multiplicand
//   

.global runtime_init
.global runtime_get_argc
.global runtime_get_argv
.global runtime_get_envp
.global runtime_get_auxv

.section .data
runtime_saved_sp:
    .quad 0

.text

//
// RUNTIME_INIT
// Initialize the runtime and stores stack pointer 
//
// Input:
//      x0 - stack pointer
//
runtime_init:
    adrp x9, runtime_saved_sp       // load address to variable into x9
    add x9, x9, :lo12:runtime_saved_sp
    str x0, [x9]                    // save pointer in x0 to variable

    ret

//
// RUNTIME_GET_ARGC
// Get argc, the number of arguments
//
// Returns:
//      x0 - number of arguments
//
runtime_get_argc:
    adrp x9, runtime_saved_sp       // load address to variable into x9
    add x9, x9, :lo12:runtime_saved_sp
    ldr x9, [x9]                    // load stackpointer at x9 and store it to x9 (overwrite)
    ldr x0, [x9]                    // load the value at pointer in x9 into x0, this is the register for return value
    ret

//
// RUNTIME_GET_ARGV
// Get pointer to the start of argv
//
// Returns:
//      x0 - pointer to first entry in argv
//
runtime_get_argv:
    adrp x9, runtime_saved_sp       // load address to variable into x9
    add x9, x9, :lo12:runtime_saved_sp
    ldr x9, [x9]                    // load saved stackpointer at x9 and store it to x9 (overwrite)
    add x0, x9, #8                  // add 8 bytes to the stored, initial, pointer. We know ARGV is located there
    ret

//
// RUNTIME_GET_ENVP
// Get pointer to the start of envp
//
// Returns:
//      x0 - pointer to first entry in envp
//
runtime_get_envp:
    adrp x9, runtime_saved_sp       // load address to variable into x9
    add x9, x9, :lo12:runtime_saved_sp
    ldr x9, [x9]                    // load saved stackpointer at x9 and store it to x9 (overwrite)
    ldr x10, [x9]                   // load the value (argc) at pointer in x9 into x10, this is the register for return value

    mov x11, #8                     // store the nuber 8, this is our multiplicand
    add x10, x10, #2                // add #2 to the stored argc. the formula to find first envp is: SP + (argc+2)*8
    madd x0, x10, x11, x9           // multiply argc by 8 and add another 8 and store it in x0. x0 now points to envp[0]
    ret

//
// RUNTIME_GET_AUXV
// Get pointer to the start of aux vector
//
// Returns:
//      x0 - pointer to first entry in argv
//
runtime_get_auxv:
    str x30, [sp, #-16]!            // allocate 16 bytes on the stack, store x30 (link register, return address)  
    bl runtime_get_envp             // get pointer to envp into x0
    ldr x30, [sp], #16              // restore x30 from stack

runtime_get_aux_loop:    
    ldr x9, [x0], #8                // read current envp pointer and advance to next enttry
    cbnz x9, runtime_get_aux_loop   // if x21 is NULL, we have reached the end
    ret