.section .rodata 
.align 4 

cpu_banner: 
.asciz "                                                 \n" 
.asciz " CPU                                             \n" 
.asciz " ----------------------------------------------- \n" 
.byte 0

architecture_heading:
.asciz " Architecture: "

.global print_cpu

.section .text

print_cpu:
    // PROLOGUE: often used to store x29 and x30
    stp x29, x30, [sp, #-16]!           // Allokera 16 bytes OCH spara x29/x30
    mov x29, sp                         // Uppdatera frame pointer till nuvarande stacktop

//
// CPU Banner
//
print_cpu_banner:
    adrp x19, cpu_banner                // get the address to jlinfo_banner with the correct offset (this is  equal to ldr, x19, =jlinfo_banner)
    add x19, x19, :lo12:cpu_banner   

print_cpu_banner_loop:
    ldrb w20, [x19]                     // read the first byte from string
    cbz w20, print_cpu_banner_done      // if null, no more strings

    mov x0, x19                         // jl_puts wants a string in x0
    bl jl_puts                          // print string and return size in x0

    add x19, x19, x0                    // jump ahead with the number of bytes written
    add x19, x19, #1                    // jump ahead one more byte to skipp null-pointer
    b print_cpu_banner_loop             // start over with the next line

print_cpu_banner_done:
//
// CPU Banner End
//

//
// CPU Architecture
//
print_cpu_architecture:
    adrp x19, architecture_heading
    add x19, x19, :lo12:architecture_heading

    mov x0, x19
    bl jl_puts

//
// CPU Architecture End
//

done:
    // EPILOGUE: often used to restore x29 and x30
    ldp x29, x30, [sp], #16     // restore x29, x30 and stack

    ret     