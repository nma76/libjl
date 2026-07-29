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
.asciz "\033[0m\n" 
.byte 0

.global print_banner

.section .text

//
// jlinfo Banner ---------------------------------------
//
print_banner:
    // PROLOGUE: often used to store x29 and x30
    stp x29, x30, [sp, #-16]!           // Allokera 16 bytes OCH spara x29/x30
    mov x29, sp                         // Uppdatera frame pointer till nuvarande stacktop

    adrp x19, jlinfo_banner             // get the address to jlinfo_banner with the correct offset (this is  equal to ldr, x19, =jlinfo_banner)
    add x19, x19, :lo12:jlinfo_banner   

loop:
    ldrb w20, [x19]                     // read the first byte from string
    cbz w20, done                       // if null, no more strings

    mov x0, x19                         // jl_puts wants a string in x0
    bl jl_puts                          // print string and return size in x0

    add x19, x19, x0                    // jump ahead with the number of bytes written
    add x19, x19, #1                    // jump ahead one more byte to skipp null-pointer
    b loop                              // start over with the next line

done:
    // EPILOGUE: often used to restore x29 and x30
    ldp x29, x30, [sp], #16             // restore x29, x30 and stack

    ret     