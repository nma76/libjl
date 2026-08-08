// Module that handles memory info
//
// scratch registers:
//      x19  - index of argument to get
//

.section .rodata 
.align 4 

user_banner: 
.ascii "\033[1;34m"
.ascii "                                                 \n" 
.ascii " User                                            \n" 
.ascii "\033[0m\033[1;36m" 
.ascii " ----------------------------------------------- \n" 
.asciz "\033[0m" 
.byte 0

//
// Headings --------------------------------------------
//
user_name_heading:
.asciz "\033[2;37m Username: \033[0m"

user_homedir_heading:
.asciz "\033[2;37m Home: \033[0m"
//
// -----------------------------------------------------
// 

//
// Dummy values ----------------------------------------
//
user_name_value:
.asciz "\033[1;37mdarklord \033[0m"

user_homedir_value:
.asciz "\033[1;37m/home/darklord \033[0m"
//
// -----------------------------------------------------
// 

.include "macros.inc"

.section .text

.global user_print

user_print:
//
// PROLOGUE: often used to store x29 and x30 -----------
//
    PROLOGUE
//
// -----------------------------------------------------
//

//
// User Banner -----------------------------------------
//
    PRINT_HEADING_BLOCK user_banner
//
// -----------------------------------------------------
//

//
// User ------------------------------------------------
//
print_mem_total:
    PRINT_STRING user_name_heading
    PRINT_STRING user_name_value
    //PRINT_STRING_FROM_FUNC get_nodename
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Home Directory --------------------------------------
//
print_mem_available:
    PRINT_STRING user_homedir_heading
    PRINT_STRING user_homedir_value
    //PRINT_STRING_FROM_FUNC get_nodename
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE 