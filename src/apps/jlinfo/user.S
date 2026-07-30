// Module that handles memory info
//
// scratch registers:
//      x19  - index of argument to get
//

.section .rodata 
.align 4 

usr_banner: 
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
usr_name_heading:
.asciz "\033[2;37m Username: \033[0m"

usr_homedir_heading:
.asciz "\033[2;37m Home: \033[0m"
//
// -----------------------------------------------------
// 

//
// Dummy values ----------------------------------------
//
usr_name_value:
.asciz "\033[1;37mdarklord \033[0m\n"

usr_homedir_value:
.asciz "\033[1;37m/home/darklord \033[0m\n"
//
// -----------------------------------------------------
// 

.include "macros.inc"

.section .text

.global print_usr

print_usr:
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
    PRINT_HEADING_BLOCK usr_banner
//
// -----------------------------------------------------
//

//
// User ------------------------------------------------
//
print_mem_total:
    PRINT_FIELD usr_name_heading, usr_name_value
//
// -----------------------------------------------------
//

//
// Home Directory --------------------------------------
//
print_mem_available:
    PRINT_FIELD usr_homedir_heading, usr_homedir_value
//
// -----------------------------------------------------
//

done:
    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE

    ret     