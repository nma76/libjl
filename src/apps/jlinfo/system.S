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
sys_kernel_heading:
.asciz "\033[2;37m Kernel: \033[0m"

sys_os_heading:
.asciz "\033[2;37m OS: \033[0m"
//
// -----------------------------------------------------
// 

//
// Dummy values ----------------------------------------
//
sys_kernel_value:
.asciz "\033[1;37m7.0.0-28-generic \033[0m\n"

sys_os_value:
.asciz "\033[1;37maarch64 GNU/Linux \033[0m\n"
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
// Kernel ----------------------------------------------
//
print_mem_total:
    PRINT_FIELD sys_kernel_heading, sys_kernel_value
//
// -----------------------------------------------------
//

//
// OS --------------------------------------------------
//
print_mem_available:
    PRINT_FIELD sys_os_heading, sys_os_value
//
// -----------------------------------------------------
//

done:
    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE

    ret     