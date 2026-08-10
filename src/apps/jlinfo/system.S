// Module that handles memory info
//

.section .rodata 
.align 4 

system_banner: 
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
system_os_heading:
.asciz "\033[2;37m OS: \033[0m"

system_nodename_heading:
.asciz "\033[2;37m Hostname: \033[0m"

system_kernel_heading:
.asciz "\033[2;37m Kernel: \033[0m"

system_compilerdetails_heading:
.asciz "\033[2;37m Compiler: \033[0m"

system_architecture_heading:
.asciz "\033[2;37m Architecture: \033[0m"

system_nisdomain_heading:
.asciz "\033[2;37m NIS Domain: \033[0m"
//
// -----------------------------------------------------
// 

.include "macros.inc"

.section .text

.global system_print

system_print:
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
    PRINT_HEADING_BLOCK system_banner
//
// -----------------------------------------------------
//

//
// Host ------------------------------------------------
//
system_print_nodename:
    PRINT_STRING system_nodename_heading
    PRINT_STRING_FROM_FUNC uname_get_nodename
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// OS --------------------------------------------------
//
system_print_os:
    PRINT_STRING system_os_heading
    PRINT_STRING_FROM_FUNC uname_get_sysname
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Kernel ----------------------------------------------
//
system_print_kernel:
    PRINT_STRING system_kernel_heading
    PRINT_STRING_FROM_FUNC uname_get_kernelversion
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Compiler --------------------------------------------
//
system_print_compilerdetails:
    PRINT_STRING system_compilerdetails_heading
    PRINT_STRING_FROM_FUNC uname_get_compilerdetails
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Architecture ----------------------------------------
//
system_print_architecture:
    PRINT_STRING system_architecture_heading
    PRINT_STRING_FROM_FUNC uname_get_architecture
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// NIS Domain ------------------------------------------
//
system_print_nisdomain:
    PRINT_STRING system_nisdomain_heading
    PRINT_STRING_FROM_FUNC uname_get_nisdomain
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE