// Handles arguments for apps written in assembly
//
// Input:
//      x0 
//
// temporary registers:

.global argv_get

.text

// x0 is index of arg to get pointer to
argv_get:
    str x30, [sp, #-16]!            // allocate 16 bytes on the stack, store x30 (link register, return address)  
    str x0, [sp, #-16]!             // store x0 (pointer to argv passed as input) to stack since it's getting overwritten by our call
    bl runtime_get_argv             // get pointer to envp into x0
    ldr x9, [sp], #16               // load argv back from stack
    mov x10, #8                     // store multiplicand #8 in x10 since madd needs a register
    madd x0, x9, x10, x0            // multiply x9 by x10 and  add x0. Store result in x0
    ldr x0, [x0]                    // get pointer in x0
    ldr x30, [sp], #16              // restore x30 from stack
    ret
