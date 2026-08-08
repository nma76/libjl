//
// Module that handles /proc/cpuinfo
//
// scratch registers:
//      x19  - index of argument to get
//

.section .rodata 
.align 4 

cpuinfo_path:
.asciz "/proc/cpuinfo"

processor_label:
.asciz "processor"

bogomips_label:
.asciz "BogoMIPS"

.section .bss
.align 3

cpuinfo_buffer: .skip 8192

.include "macros.inc"

.section .text

.global init_cpuinfo
.global print_cpuinfo_debug
.global get_corecount
.global get_bogomips

init_cpuinfo:
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
    mov x0, x19
    bl jl_close

    ldr x19, [sp], #16                          // restore x19 from stack

    EPILOGUE

//
// get_corecount
// search the content from /proc/cpuinfo and count occurencies of "processor" to get number of cores
//
get_corecount:
    PROLOGUE
    str x19, [sp, #-16]!                        // store x19 on the stack so we can restore it. It's callee-saved, so it's important not to destroy!

    mov x19, #0                                 // use x19 as a counter to count occurencies

    adrp x0, cpuinfo_buffer                     // load the haystack, which is the content from proc/cpuinfo
    add x0, x0, :lo12:cpuinfo_buffer

corecount_loop:
    adrp x1, processor_label                    // load the needle, in this case "processor"
    add x1, x1, :lo12:processor_label

    bl jl_strstr                                // find the firs occurence using jl_strstr

    cbz x0, corecount_done                      // if x0 is null, no more occurencies was found
    add x0, x0, #1                              // if we found the string we was looking for, add a byte so we can search again without getting the same hit
    add x19, x19, #1                            // increase the counter
    b corecount_loop                            // and do another search

corecount_done:
    mov x0, x19                                 // move counter to x0, our return value

    ldr x19, [sp], #16                          // restore x19 from stack
    EPILOGUE

//
// get_bogomips
// get  bogomips value from /proc/cpuinfo
//
get_bogomips:
    PROLOGUE

    adrp x0, cpuinfo_buffer                     // load the content from proc/cpuinfo
    add x0, x0, :lo12:cpuinfo_buffer

    adrp x1, bogomips_label                    // load the key to look for
    add x1, x1, :lo12:bogomips_label

    bl find_value

    EPILOGUE
