//
// Module that handles /proc/cpuinfo
//
// scratch registers:
//      x19  - file handle
//             counter to count occurrences
//

.section .rodata 
.align 4 

cpuinfo_path:
.asciz "/proc/cpuinfo"

cpuinfo_processor_label:
.asciz "processor"

cpuinfo_architecture_label:
.asciz "CPU architecture"

cpuinfo_implementer_label:
.asciz "CPU implementer"

.section .bss
.align 3

cpuinfo_buffer: .skip 8192

.include "macros.inc"

.section .text

.global cpuinfo_read
.global cpuinfo_get_corecount
.global cpuinfo_get_architecture
.global cpuinfo_get_implementer

//
// cpuinfo_read
// reads the file /proc/cpuinfo into a buffer and closes the file
//
// scratch registers:
//      x19 - file handle
//
cpuinfo_read:
    PROLOGUE

    str x19, [sp, #-16]!                        // store x19 on the stack so we can restore it. It's callee-saved, so it's important not to destroy!

    //
    // prepare to open file with jl_open 
    //
    adrp x0, cpuinfo_path                       // x0 now points to beginning of variable holding the path to open
    add x0, x0, :lo12:cpuinfo_path
    mov x1, #0                                  // open file as read-only
    bl jl_open                                  // open file, the file descriptor is in x0
    mov x19, x0                                 // store file handle in x19 to prevent overwriting

    //
    // Read the file with jl_read
    // x0 already contains the file handle, so we only set x1 and x2
    //
    adrp x1, cpuinfo_buffer                     // point x1 to buffer where file content is stored
    add x1, x1, :lo12:cpuinfo_buffer
    mov x2, #8191                             // bytes to read. This is the size of buffer -1 to make room for \0
    bl jl_read
    strb wzr, [x1, x0]                          // add null termination to buffer.

    //
    // Prepare to close file with jl_close
    //
    mov x0, x19                                 // read file handle from x19 back to x0 
    bl jl_close                                 // close the file

    ldr x19, [sp], #16                          // restore x19 from stack

    EPILOGUE

//
// cpuinfo_get_corecount
// search the content from /proc/cpuinfo and count occurrences of "processor" to get number of cores
//
// Returns:
//      x0 - number of cores
//
// Scratch registers:
//      x19 - counter
//
cpuinfo_get_corecount:
    PROLOGUE
    str x19, [sp, #-16]!                        // store x19 on the stack so we can restore it. It's callee-saved, so it's important not to destroy!

    mov x19, #0                                 // use x19 as a counter to count occurrences

    adrp x0, cpuinfo_buffer                     // load the haystack, which is the content from proc/cpuinfo
    add x0, x0, :lo12:cpuinfo_buffer

cpuinfo_corecount_loop:
    adrp x1, cpuinfo_processor_label            // load the needle, in this case "processor"
    add x1, x1, :lo12:cpuinfo_processor_label

    bl jl_strstr                                // find the first occurrence using jl_strstr

    cbz x0, cpuinfo_corecount_done              // if x0 is null, no more occurrences was found
    add x0, x0, #1                              // if we found the string we was looking for, add a byte so we can search again without getting the same hit
    add x19, x19, #1                            // increase the counter
    b cpuinfo_corecount_loop                    // and do another search

cpuinfo_corecount_done:
    mov x0, x19                                 // move counter to x0, our return value

    ldr x19, [sp], #16                          // restore x19 from stack
    EPILOGUE

//
// cpuinfo_get_architecture
// get cpu architecture value from /proc/cpuinfo
//
// Returns:
//      x0  - pointer to string containing cpu architecture
//
cpuinfo_get_architecture:
    PROLOGUE

    adrp x0, cpuinfo_buffer                     // load the content from proc/cpuinfo
    add x0, x0, :lo12:cpuinfo_buffer

    adrp x1, cpuinfo_architecture_label         // load the key to look for
    add x1, x1, :lo12:cpuinfo_architecture_label

    bl util_find_key_value

    EPILOGUE

//
// cpuinfo_get_implementer
// get cpu implementer (model) value from /proc/cpuinfo
//
// Returns:
//      x0  - pointer to string containing cpu implementer
//
cpuinfo_get_implementer:
    PROLOGUE

    adrp x0, cpuinfo_buffer                     // load the content from proc/cpuinfo
    add x0, x0, :lo12:cpuinfo_buffer

    adrp x1, cpuinfo_implementer_label          // load the key to look for
    add x1, x1, :lo12:cpuinfo_implementer_label

    bl util_find_key_value

    EPILOGUE
