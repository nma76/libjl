// Module that handles memory info
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

user_home_heading:
.asciz "\033[2;37m Home: \033[0m"

user_shell_heading:
.asciz "\033[2;37m Shell: \033[0m"
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
user_print_username:
    PRINT_STRING user_name_heading
    PRINT_STRING_FROM_FUNC env_get_username
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Home Directory --------------------------------------
//
user_print_home:
    PRINT_STRING user_home_heading
    PRINT_STRING_FROM_FUNC env_get_home
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

//
// Home Directory --------------------------------------
//
user_print_shell:
    PRINT_STRING user_shell_heading
    PRINT_STRING_FROM_FUNC env_get_shell
    PRINT_NEWLINE
//
// -----------------------------------------------------
//

    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE 