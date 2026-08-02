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

.include "macros.inc"

.section .text

.global init_uname
.global get_sysname
.global get_nodename
.global get_kernelversion
.global get_compilerdetails
.global get_architecture
.global get_nisdomain

init_uname:
    //
    // sys call to uname to read information into buffer
    //
    adrp x0, uname_buffer                   // get base address to buffer
    add x0, x0, :lo12:uname_buffer
    mov x8, #160                          // syscall 160 = uname
    svc #0                                  // call Linux kernel

    cmp x0, #0                              // check if syscall was successfull (less than 0)

    ret

get_sysname:
    UNAME_GETTER 0

get_nodename:
    UNAME_GETTER 65

get_kernelversion:
    UNAME_GETTER 130

get_compilerdetails:
    UNAME_GETTER 195

get_architecture:
    UNAME_GETTER 260

get_nisdomain:
    UNAME_GETTER 325
