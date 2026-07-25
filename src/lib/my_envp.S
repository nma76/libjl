// Handles environment variables for apps written in assembly
//
// Input:
//      x0  - name of variable to look for (eg. ldr x0, =envp_name)
//
// temporary registers:
//      x9  - pointer to envp, fetched from runtime
//      x10 - current envp entry 
//      x11 - temporary copy of pointer to input string (env name)
//      x12 - temporary copy of pointer to the current envp entry
//      x13 - current char from input string
//      x14 - current char from current envp entry
//

.global envp_get

.text

envp_get:
    // prologue - save link register and x0 on the stack
    str x30, [sp, #-16]!            // allocate 16 bytes on the stack, store x30 (link register, return address)  
    str x0, [sp, #-16]!             // store x0 (pointer to envp name to look for, passed as input) to stack since it's getting overwritten by our call

    bl runtime_get_envp             // get pointer to envp into x0
    mov x9, x0                      // save pointer to envp into x9
    ldr x0, [sp], #16               // restore x0 from stack, which we saved earlier

envp_get_loop:
    ldr x10, [x9], #8               // load next entry in envp into x10
    cbz x10, envp_get_not_found     // if we get NULL, we are done looping envp!

    mov x11, x0                     // copy pointer to input env name to x11
    mov x12, x10                    // copy pointer to current envp entry to x12

envp_get_prefix_cmp:
    ldrb w13, [x11], #1             // load next byte of search string (from our input) into x13 and bump pointer
    cbz w13, check_envp_get_equal   // we reached end of input string. A match only exists if the next char in current envp entry is =

    ldrb w14, [x12], #1             // load next byte of the current envp entry into x14 and bump pointer

    cmp w13, w14                    // compare current char in input with current char in current envp
    b.ne envp_get_loop              // if they are not equal, read next envp value
   
    b envp_get_prefix_cmp           // if the first byte matches, compare the next one

check_envp_get_equal:
    ldrb w14, [x12]                 // load next byte in current entry into x14
    cmp w14, #'='                   // is it an =?
    b.ne envp_get_loop              // if not, back to loop. Else, we fall through to envp_get_found

envp_get_found:
    add x0, x12, #1                 // move one char ahead to return everything after =
    b epilogue

envp_get_not_found:
    mov x0, #0                      // No match, return NULL

epilogue:
    ldr x30, [sp], #16              // restore x30 from stack
    ret