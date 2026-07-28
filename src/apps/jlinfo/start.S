.section .rodata 
.align 4 

jlinfo_title: 
.asciz " ██████╗██╗     ██╗███╗   ██╗███████╗ ██████╗   \n" 
.asciz " ╚════██║██║     ██║████╗  ██║██╔════╝██╔═══██╗ \n" 
.asciz "      ██║██║     ██║██╔██╗ ██║█████╗  ██║   ██║ \n" 
.asciz " ██   ██║██║     ██║██║╚██╗██║██╔══╝  ██║   ██║ \n" 
.asciz " ╚██████╔╝███████╗██║██║ ╚████║██║     ╚██████╔╝\n" 
.asciz "  ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ \n" 
.byte 0

.global _start

.section .text

_start:

print_banner:
    adrp x19, jlinfo_title
    add x19, x19, :lo12:jlinfo_title

print_banner_loop:
    ldrb w20, [x19]                 // read the first byte from string
    cbz w20, print_banner_done      // if null, no more strings

    mov x0, x19                     // jl_puts wants a string in x0
    bl jl_puts                      // print string and return size in x0

    add x19, x19, x0                // jump ahead with the number of bytes written
    add x19, x19, #1                // jump ahead one more byte to skipp null-pointer
    b print_banner_loop             // start over with the next line

print_banner_done:

exit:
    // Exit using linux syscall
    mov x8, #93                         // exit syscall
    svc #0                              // invoke syscall
     