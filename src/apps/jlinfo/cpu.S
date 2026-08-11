//
// Module that handles cpu info
//
// scratch registers:
//      x19  - index of argument to get
//

.section .rodata 
.align 4 

cpu_banner: 
.ascii "\033[1;34m"
.ascii "                                                 \n" 
.ascii " CPU                                             \n" 
.ascii "\033[0m\033[1;36m" 
.ascii " ----------------------------------------------- \n" 
.asciz "\033[0m" 
.byte 0

//
// Headings --------------------------------------------
//
cpu_architecture_heading:
.asciz "\033[2;37m Architecture: \033[0m"

cpu_model_heading:
.asciz "\033[2;37m Model: \033[0m"

cpu_cores_heading:
.asciz "\033[2;37m Cores: \033[0m"
//
// -----------------------------------------------------
// 

.include "macros.inc"

.section .text

.global cpu_print

cpu_print:
//
// PROLOGUE: often used to store x29 and x30 -----------
//
    PROLOGUE
//
// -----------------------------------------------------
//

//
// CPU Banner ------------------------------------------
//
    PRINT_HEADING_BLOCK cpu_banner
//
// -----------------------------------------------------
//

//
// CPU Architecture ------------------------------------
//
cpu_print_architecture:
    PRINT_STRING cpu_architecture_heading
    PRINT_STRING_FROM_FUNC cpuinfo_get_architecture
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// CPU Model -------------------------------------------
//
cpu_print_model:
    PRINT_STRING cpu_model_heading
    PRINT_STRING_FROM_FUNC cpuinfo_get_implementer
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// CPU Cores -------------------------------------------
//
cpu_print_cores:
    PRINT_STRING cpu_cores_heading
    PRINT_NUMBER_FROM_FUNC cpuinfo_get_corecount
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// EPILOGUE: often used to restore x29 and x30 ---------
//
    EPILOGUE