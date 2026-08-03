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

.section .bss
.align 3

cpuinfo_buffer: .skip 8192

.include "macros.inc"

.section .text

.global init_cpuinfo
.global print_cpuinfo_debug
.global get_corecount

init_cpuinfo:
    PROLOGUE

    str x19, [sp, #-16]!

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
    mov x2, #8191                             // bytes to read. This is the size of buffer
    bl jl_read
    strb wzr, [x1, x0]                          // add null termination to buffer.

    //
    // Prepare to close file with jl_close
    //
    mov x0, x19
    bl jl_close

    ldr x19, [sp], #16

    EPILOGUE

print_cpuinfo_debug:
    PROLOGUE

    ldr x0, =cpuinfo_buffer
    bl jl_puts

    EPILOGUE

get_corecount:
    //
    // Idea:    Insted of counting occurences of the term "processor", it should be fine
    //          to just find the last occurence of the term, get the value and add one. 
    //          Eg. if the last occurence is "processor: 3", we know the system hqve 4 cores

    ret