// Module that handles uname
//

.section .bss
.align 3

//
// Uname structure. Reserve 390 bytes:
//      0-64        sysname (os)
//      65-129      nodename
//      130-194     kernel version
//      195-259     compiler details
//      260-324     architecture
//      325-389     NIS-domain
//
uname_buffer: .skip 390

.section .data
.align 3

.global uname_sysname
.global uname_nodename

uname_sysname:
    .quad 0
uname_nodename:
    .quad 0


.include "macros.inc"

.section .text

.global read_uname

read_uname:
    //
    // sys call to uname to read information into buffer
    //
    adrp x0, uname_buffer                   // get base address to buffer
    add x0, x0, :lo12:uname_buffer
    mov x8, #160                          // syscall 160 = uname
    svc #0                                  // call Linux kernel

    cmp x0, #0                              // check if syscall was successfull (less than 0)
    blt read_uname_error

    //
    // store sysname into uname_sysname
    //
    adrp x0, uname_buffer                   // x0 now points to beginning of buffer
    add x0, x0, :lo12:uname_buffer

    adrp x1, uname_sysname
    add x1, x1, :lo12:uname_sysname
    str x0, [x1]

    //
    // store nodename into uname_sysname
    //
    adrp x0, uname_buffer                   // x0 now points to beginning of buffer
    add x0, x0, :lo12:uname_buffer
    add x0, x0, #65

    adrp x1, uname_nodename
    add x1, x1, :lo12:uname_nodename
    str x0, [x1]

    // TODO: add the remaining 4 values in uname structure
    // TODO: turn this into a macro


read_uname_error:
    ret