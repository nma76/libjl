//
// Module that handles memory info
//

.section .rodata 
.align 4 

memory_banner: 
.ascii "\033[1;34m"
.ascii "                                                 \n" 
.ascii " Memory                                          \n" 
.ascii "\033[0m\033[1;36m" 
.ascii " ----------------------------------------------- \n" 
.asciz "\033[0m" 
.byte 0

//
// Headings --------------------------------------------
//
memory_total_heading:
.asciz "\033[2;37m Total RAM: \033[0m"

memory_available_heading:
.asciz "\033[2;37m Available RAM: \033[0m"

memory_free_heading:
.asciz "\033[2;37m Free RAM: \033[0m"

memory_cached_heading:
.asciz "\033[2;37m Cached: \033[0m"
//
// -----------------------------------------------------
// 

.include "macros.inc"

.section .text

.global memory_print

memory_print:
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
    PRINT_HEADING_BLOCK memory_banner
//
// -----------------------------------------------------
//

//
// Total Memory ----------------------------------------
//
memory_print_total:
    PRINT_STRING memory_total_heading
    PRINT_STRING_FROM_FUNC meminfo_get_memtotal
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Memory Available-------------------------------------
//
memory_print_available:
    PRINT_STRING memory_available_heading
    PRINT_STRING_FROM_FUNC meminfo_get_memavailable
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Memory Free -----------------------------------------
//
memory_print_free:
    PRINT_STRING memory_free_heading
    PRINT_STRING_FROM_FUNC meminfo_get_memfree
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Memory Cached ---------------------------------------
//
memory_print_cached:
    PRINT_STRING memory_cached_heading
    PRINT_STRING_FROM_FUNC meminfo_get_cached
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE   