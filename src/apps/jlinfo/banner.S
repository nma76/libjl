// Module that handles program banner
//
// scratch registers:
//      x19  - index of argument to get
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

.global print_banner

//
// jlinfo Banner ---------------------------------------
//
print_banner:
    // PROLOGUE: often used to store x29 and x30
    PROLOGUE

    PRINT_HEADING_BLOCK jlinfo_banner

done:
    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE 