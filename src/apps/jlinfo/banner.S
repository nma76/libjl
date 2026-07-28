.section .rodata 
.align 4 

jlinfo_banner: 
.asciz "                                                \n" 
.asciz " ██████╗██╗     ██╗███╗   ██╗███████╗ ██████╗   \n" 
.asciz " ╚════██║██║     ██║████╗  ██║██╔════╝██╔═══██╗ \n" 
.asciz "      ██║██║     ██║██╔██╗ ██║█████╗  ██║   ██║ \n" 
.asciz " ██   ██║██║     ██║██║╚██╗██║██╔══╝  ██║   ██║ \n" 
.asciz " ╚██████╔╝███████╗██║██║ ╚████║██║     ╚██████╔╝\n" 
.asciz "  ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ \n" 
.asciz "                                                \n" 
.byte 0

.global print_banner

.section .text

print_banner:
    // PROLOGUE: often used to store x29 and x30
    str x30, [sp, #-16]!                // allocate 16 bytes on the stack and store x30 (link register, return address).

    adrp x19, jlinfo_banner             // get the address to jlinfo_banner with the correct offset (this is  equal to ldr, x19, =jlinfo_banner)
    add x19, x19, :lo12:jlinfo_banner   

loop:
    ldrb w20, [x19]     // read the first byte from string
    cbz w20, done       // if null, no more strings

    mov x0, x19         // jl_puts wants a string in x0
    bl jl_puts          // print string and return size in x0

    add x19, x19, x0    // jump ahead with the number of bytes written
    add x19, x19, #1    // jump ahead one more byte to skipp null-pointer
    b loop              // start over with the next line

done:
    // EPILOGUE: often used to restore x29 and x30
    ldr x30, [sp], #16          // restore x30 from stack

    ret     