// Handles arguments
//
// scratch registers:
//      x9  - index of argument to get
//      x10 - the multiplicand used
//

.global argv_exists
.global argv_get

.text

//
// ARGV_EXISTS
// Check if a given command-line argument exists
//
// Input:
//      x0 - argument index
//
// Returns:
//      true/false depending on if it exists
//
argv_exists:
    // prologue - save link register on the stack
    str x30, [sp, #-16]!            // allocate 16 bytes on the stack, store x30 (link register, return address)  
    str x0, [sp, #-16]!             // store argument index, x0, to stack since it's getting overwritten by our call to runtime_get_argv

    bl runtime_get_argc             // call runtime to get argc. Linux ABI guarantee argc to be at least 1
    sub x0, x0, #1                  // convert argc to the highest valid argument index. (zero is the executable itself)
    ldr x9, [sp], #16               // load argument index back from stack into x9

    cmp x9, x0                      // compare index sent to function with the number of args that exists
    b.ls argv_exists_true           // if x9 (requested index) is less than, or equal to x0 (number of existing arguments), requested argument exists

    mov x0, #0                      // else, we set x0 to zero to return false
    b argv_exists_epilogue

argv_exists_true:
    mov x0, #1                      // set x0 to one, return true

argv_exists_epilogue:
    ldr x30, [sp], #16              // restore x30 from stack
    ret

//
// ARGV_GET
// Get a pointer to the requested command-line argument
//
// Input:
//      x0 - argument index
//
// Returns:
//      Pointer to the requested argument, or NULL if index is invalid
//
argv_get:
    str x30, [sp, #-16]!            // allocate 16 bytes on the stack, store x30 (link register, return address)  
    str x0, [sp, #-16]!             // store argument index, x0, to stack since it's getting overwritten by our call to runtime_get_argv

    bl runtime_get_argv             // get pointer to envp into x0
    ldr x9, [sp], #16               // load argument index back from stack into x9
    mov x10, #8                     // store multiplicand #8 in x10 since madd needs a register, not a value
    madd x0, x9, x10, x0            // calculate the address of argv[index]
    ldr x0, [x0]                    // dereference argv[index]

    ldr x30, [sp], #16              // restore x30 from stack
    ret
