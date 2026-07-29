// Module that handles memory info
//
// scratch registers:
//      x19  - index of argument to get
//

.section .rodata 
.align 4 

mem_banner: 
.ascii "\033[1;34m"
.ascii "                                                 \n" 
.ascii " Memory                                          \n" 
.ascii "\033[0m\033[1;36m" 
.ascii " ----------------------------------------------- \n" 
.asciz "\033[0m\n" 
.byte 0

//
// Headings --------------------------------------------
//
mem_total_heading:
.asciz "\033[2;37m Total RAM: \033[0m"

mem_available_heading:
.asciz "\033[2;37m Available RAM: \033[0m"
//
// -----------------------------------------------------
// 

//
// Dummy values ----------------------------------------
//
mem_total_value:
.asciz "\033[1;37m8GB \033[0m\n"

mem_available_value:
.asciz "\033[1;37m6GB \033[0m\n"
//
// -----------------------------------------------------
// 

.include "macros.inc"

.section .text

.global print_mem

print_mem:
//
// PROLOGUE: often used to store x29 and x30 -----------
//
    PROLOGUE
//
// -----------------------------------------------------
//

//
// Memory Banner ------------------------------------------
//
    PRINT_HEADING_BLOCK mem_banner
//
// -----------------------------------------------------
//

//
// Total Memory ----------------------------------------
//
print_mem_total:
    PRINT_FIELD mem_total_heading, mem_total_value
//
// -----------------------------------------------------
//

//
// Memory Available-------------------------------------
//
print_mem_available:
    PRINT_FIELD mem_available_heading, mem_available_value
//
// -----------------------------------------------------
//

done:
    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE

    ret     