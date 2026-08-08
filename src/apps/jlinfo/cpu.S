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

.global print_cpu


print_cpu:
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
print_cpu_architecture:
    PRINT_STRING cpu_architecture_heading
    PRINT_STRING_FROM_FUNC get_architecture_value
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// CPU Model -------------------------------------------
//
print_cpu_model:
    PRINT_STRING cpu_model_heading
    PRINT_STRING_FROM_FUNC get_implementer_value
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// CPU Cores -------------------------------------------
//
print_cpu_cores:
    PRINT_STRING cpu_cores_heading
    PRINT_NUMBER_FROM_FUNC get_corecount_value
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

done:
//
// EPILOGUE: often used to restore x29 and x30 ---------
//
    EPILOGUE