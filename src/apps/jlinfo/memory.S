// Module that handles memory info
//
// scratch registers:
//      x19  - index of argument to get
//

.section .rodata 
.align 4 

mem_banner: 
.ascii "\033[1;34m"
.ascii "                                                 \n" 
.ascii " Memory                                          \n" 
.ascii "\033[0m\033[1;36m" 
.ascii " ----------------------------------------------- \n" 
.asciz "\033[0m\n" 
.byte 0

//
// Headings --------------------------------------------
//
mem_total_heading:
.asciz "\033[2;37m Total RAM: \033[0m"

mem_available_heading:
.asciz "\033[2;37m Available RAM: \033[0m"
//
// -----------------------------------------------------
// 

//
// Dummy values ----------------------------------------
//
mem_total_value:
.asciz "\033[1;37m8GB \033[0m\n"

mem_available_value:
.asciz "\033[1;37m6GB \033[0m\n"
//
// -----------------------------------------------------
// 

.include "macros.inc"

.section .text

.global print_mem

print_mem:
    // PROLOGUE: often used to store x29 and x30
    stp x29, x30, [sp, #-16]!                       // Allokera 16 bytes OCH spara x29/x30
    mov x29, sp                                     // Uppdatera frame pointer till nuvarande stacktop

//
// Memory Banner ------------------------------------------
//
print_mem_banner:
    adrp x19, mem_banner                            // get the address to mem_banner with the correct offset (this is  equal to ldr, x19, =mem_banner)
    add x19, x19, :lo12:mem_banner   

print_mem_banner_loop:
    ldrb w20, [x19]                                 // read the first byte from string
    cbz w20, print_mem_banner_done                  // if null, no more strings

    mov x0, x19                                     // jl_puts wants a string in x0
    bl jl_puts                                      // print string and return size in x0

    add x19, x19, x0                                // jump ahead with the number of bytes written
    add x19, x19, #1                                // jump ahead one more byte to skipp null-pointer
    b print_mem_banner_loop                         // start over with the next line

print_mem_banner_done:
//
// -----------------------------------------------------
//

//
// Total Memory ----------------------------------------
//
print_mem_total:
    print_label mem_total_heading
    print_label mem_total_value
//
// -----------------------------------------------------
//

//
// Memory Available-------------------------------------
//
print_mem_available:
    print_label mem_available_heading
    print_label mem_available_value
//
// -----------------------------------------------------
//

done:
    // EPILOGUE: often used to restore x29 and x30
    ldp x29, x30, [sp], #16                         // restore x29, x30 and stack

    ret     