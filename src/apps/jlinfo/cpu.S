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

//
// Dummy values ----------------------------------------
//
cpu_architecture_value:
.asciz "\033[1;37maarch64 \033[0m\n"

cpu_model_value:
.asciz "\033[1;37mARM \033[0m\n"

cpu_cores_value:
.asciz "\033[1;37m8 \033[0m\n"
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
    PRINT_FIELD cpu_architecture_heading, cpu_architecture_value
//
// -----------------------------------------------------
//

//
// CPU Model -------------------------------------------
//
print_cpu_model:
    PRINT_FIELD cpu_model_heading, cpu_model_value
//
// -----------------------------------------------------
//

//
// CPU Cores -------------------------------------------
//
print_cpu_cores:
    PRINT_FIELD cpu_cores_heading, cpu_cores_value
//
// -----------------------------------------------------
//

done:
//
// EPILOGUE: often used to restore x29 and x30 ---------
//
    EPILOGUE