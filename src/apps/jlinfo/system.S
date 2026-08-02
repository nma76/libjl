// Module that handles memory info
//
// scratch registers:
//      x19  - index of argument to get
//

.section .rodata 
.align 4 

sys_banner: 
.ascii "\033[1;34m"
.ascii "                                                 \n" 
.ascii " System                                          \n" 
.ascii "\033[0m\033[1;36m" 
.ascii " ----------------------------------------------- \n" 
.asciz "\033[0m" 
.byte 0

//
// Headings --------------------------------------------
//
sys_os_heading:
.asciz "\033[2;37m OS: \033[0m"

sys_nodename_heading:
.asciz "\033[2;37m Hostname: \033[0m"

sys_kernel_heading:
.asciz "\033[2;37m Kernel: \033[0m"

sys_compilerdetails_heading:
.asciz "\033[2;37m Compiler: \033[0m"

sys_architecture_heading:
.asciz "\033[2;37m Architecture: \033[0m"

sys_nisdomain_heading:
.asciz "\033[2;37m NIS Domain: \033[0m"
//
// -----------------------------------------------------
// 

.include "macros.inc"

.section .text

.global print_sys

print_sys:
//
// PROLOGUE: often used to store x29 and x30 -----------
//
    PROLOGUE
//
// -----------------------------------------------------
//

//
// System Banner ---------------------------------------
//
    PRINT_HEADING_BLOCK sys_banner
//
// -----------------------------------------------------
//

//
// Host ------------------------------------------------
//
print_sys_nodename:
    PRINT_STRING sys_nodename_heading
    PRINT_STRING_FROM_FUNC get_nodename
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// OS --------------------------------------------------
//
print_sys_os:
    PRINT_STRING sys_os_heading
    PRINT_STRING_FROM_FUNC get_sysname
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Kernel ----------------------------------------------
//
print_sys_kernel:
    PRINT_STRING sys_kernel_heading
    PRINT_STRING_FROM_FUNC get_kernelversion
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Compiler --------------------------------------------
//
print_sys_compilerdetails:
    PRINT_STRING sys_compilerdetails_heading
    PRINT_STRING_FROM_FUNC get_compilerdetails
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Architecture ----------------------------------------
//
print_sys_architecture:
    PRINT_STRING sys_architecture_heading
    PRINT_STRING_FROM_FUNC get_architecture
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// NIS Domain ------------------------------------------
//
print_sys_nisdomain:
    PRINT_STRING sys_nisdomain_heading
    PRINT_STRING_FROM_FUNC get_nisdomain
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

done:
    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE