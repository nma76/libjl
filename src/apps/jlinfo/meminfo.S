//
// Module that handles /proc/meminfo
//
// scratch registers:
//      x19  - file handle
//

.section .rodata 
.align 4 

meminfo_path:
.asciz "/proc/meminfo"

meminfo_memtotal_label:
.asciz "MemTotal"

meminfo_memavailable_label:
.asciz "MemAvailable"

meminfo_memfree_label:
.asciz "MemFree"

meminfo_cached_label:
.asciz "Cached"

.section .bss
.align 3

meminfo_buffer: .skip 8192

.include "macros.inc"

.section .text

.global meminfo_read
.global meminfo_get_memtotal
.global meminfo_get_memavailable
.global meminfo_get_memfree
.global meminfo_get_cached

//
// meminfo_read
// reads the file /proc/meminfo into a buffer and closes the file
//
// scratch registers:
//      x19 - file handle
//
meminfo_read:
    PROLOGUE

    str x19, [sp, #-16]!                        // store x19 on the stack so we can restore it. It's callee-saved, so it's important not to destroy!

    //
    // prepare to open file with jl_open 
    //
    adrp x0, meminfo_path                       // x0 now points to beginning of variable holding the path to open
    add x0, x0, :lo12:meminfo_path
    mov x1, #0                                  // open file as read-only
    bl jl_open                                  // open file, the file descriptor is in x0
    mov x19, x0                                 // store file handle in x19 to prevent overwriting

    //
    // Read the file with jl_read
    // x0 already contains the file handle, so we only set x1 and x2
    //
    adrp x1, meminfo_buffer                     // point x1 to buffer where file content is stored
    add x1, x1, :lo12:meminfo_buffer
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
// meminfo_get_memtotal
// get the total amount of memory
//
// Returns:
//      x0  - pointer to string containing total amount of memory
//
meminfo_get_memtotal:
    PROLOGUE

    adrp x0, meminfo_buffer                         // load the content from proc/cpuinfo
    add x0, x0, :lo12:meminfo_buffer

    adrp x1, meminfo_memtotal_label                 // load the key to look for
    add x1, x1, :lo12:meminfo_memtotal_label

    bl util_find_key_value

    EPILOGUE

//
// meminfo_get_memavailable
// get the total amount of memory available
//
// Returns:
//      x0  - pointer to string containing memory available
//
meminfo_get_memavailable:
    PROLOGUE

    adrp x0, meminfo_buffer                         // load the content from proc/cpuinfo
    add x0, x0, :lo12:meminfo_buffer

    adrp x1, meminfo_memavailable_label             // load the key to look for
    add x1, x1, :lo12:meminfo_memavailable_label

    bl util_find_key_value

    EPILOGUE

//
// meminfo_get_memfree
// get the total amount of memory free
//
// Returns:
//      x0  - pointer to string containing free memory
//
meminfo_get_memfree:
    PROLOGUE

    adrp x0, meminfo_buffer                         // load the content from proc/cpuinfo
    add x0, x0, :lo12:meminfo_buffer

    adrp x1, meminfo_memfree_label                 // load the key to look for
    add x1, x1, :lo12:meminfo_memfree_label

    bl util_find_key_value

    EPILOGUE

//
// meminfo_get_cached
// get the total amount of memory used for file cache
//
// Returns:
//      x0  - pointer to string containing cached memory
meminfo_get_cached:
    PROLOGUE

    adrp x0, meminfo_buffer                         // load the content from proc/cpuinfo
    add x0, x0, :lo12:meminfo_buffer

    adrp x1, meminfo_cached_label                   // load the key to look for
    add x1, x1, :lo12:meminfo_cached_label

    bl util_find_key_value

    EPILOGUE
