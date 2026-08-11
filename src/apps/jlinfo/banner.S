//
// Module that handles program banner
//

.section .rodata 
.align 4 

jlinfo_banner: 
.ascii "\033[1;36m"
.ascii "                                                \n" 
.ascii " ██████╗██╗     ██╗███╗   ██╗███████╗ ██████╗   \n" 
.ascii " ╚════██║██║     ██║████╗  ██║██╔════╝██╔═══██╗ \n" 
.ascii "      ██║██║     ██║██╔██╗ ██║█████╗  ██║   ██║ \n" 
.ascii " ██   ██║██║     ██║██║╚██╗██║██╔══╝  ██║   ██║ \n" 
.ascii " ╚██████╔╝███████╗██║██║ ╚████║██║     ╚██████╔╝\n" 
.ascii "  ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ \n" 
.ascii "                                                \n"
.asciz "\033[0m" 
.byte 0

.include "macros.inc"

.section .text

.global banner_print

//
// jlinfo Banner ---------------------------------------
//
banner_print:
    // PROLOGUE: often used to store x29 and x30
    PROLOGUE

    PRINT_HEADING_BLOCK jlinfo_banner

    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE 