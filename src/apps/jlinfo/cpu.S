// Module that handles cpu info
//
// scratch registers:
//      x19  - index of argument to get
//

.section .rodata 
.align 4 

cpu_banner: 
.ascii "\033[1;34m"
.ascii "                                                 \n" 
.ascii " CPU                                             \n" 
.ascii "\033[0m\033[1;36m" 
.ascii " ----------------------------------------------- \n" 
.asciz "\033[0m\n" 
.byte 0

//
// Headings --------------------------------------------
//
cpu_architecture_heading:
.asciz "\033[2;37m Architecture: \033[0m"

cpu_model_heading:
.asciz "\033[2;37m Model: \033[0m"

cpu_cores_heading:
.asciz "\033[2;37m Cores: \033[0m"
//
// -----------------------------------------------------
// 

//
// Dummy values ----------------------------------------
//
cpu_architecture_value:
.asciz "\033[1;37maarch64 \033[0m\n"

cpu_model_value:
.asciz "\033[1;37mARM \033[0m\n"

cpu_cores_value:
.asciz "\033[1;37m8 \033[0m\n"
//
// -----------------------------------------------------
// 


.global print_cpu

.section .text

print_cpu:
    // PROLOGUE: often used to store x29 and x30
    stp x29, x30, [sp, #-16]!                       // Allokera 16 bytes OCH spara x29/x30
    mov x29, sp                                     // Uppdatera frame pointer till nuvarande stacktop

//
// CPU Banner ------------------------------------------
//
print_cpu_banner:
    adrp x19, cpu_banner                            // get the address to cpu_banner with the correct offset (this is  equal to ldr, x19, =cpu_banner)
    add x19, x19, :lo12:cpu_banner   

print_cpu_banner_loop:
    ldrb w20, [x19]                                 // read the first byte from string
    cbz w20, print_cpu_banner_done                  // if null, no more strings

    mov x0, x19                                     // jl_puts wants a string in x0
    bl jl_puts                                      // print string and return size in x0

    add x19, x19, x0                                // jump ahead with the number of bytes written
    add x19, x19, #1                                // jump ahead one more byte to skipp null-pointer
    b print_cpu_banner_loop                         // start over with the next line

print_cpu_banner_done:
//
// -----------------------------------------------------
//

//
// CPU Architecture ------------------------------------
//
print_cpu_architecture:
    adrp x19, cpu_architecture_heading              // get address to the banner
    add x19, x19, :lo12:cpu_architecture_heading

    mov x0, x19                                     // jl_puts wants a string in x0
    bl jl_puts                                      // print string and return size in x0

    adrp x19, cpu_architecture_value                // get address to the dummy value
    add x19, x19, :lo12:cpu_architecture_value

    mov x0, x19                                     // jl_puts wants a string in x0
    bl jl_puts                                      // print string and return size in x0
//
// -----------------------------------------------------
//

//
// CPU Model -------------------------------------------
//
print_cpu_model:
    adrp x19, cpu_model_heading
    add x19, x19, :lo12:cpu_model_heading

    mov x0, x19                                     // jl_puts wants a string in x0
    bl jl_puts                                      // print string and return size in x0

    adrp x19, cpu_model_value                       // get address to the dummy value
    add x19, x19, :lo12:cpu_model_value

    mov x0, x19                                     // jl_puts wants a string in x0
    bl jl_puts                                      // print string and return size in x0
//
// -----------------------------------------------------
//

//
// CPU Cores -------------------------------------------
//
print_cpu_cores:
    adrp x19, cpu_cores_heading
    add x19, x19, :lo12:cpu_cores_heading

    mov x0, x19                                     // jl_puts wants a string in x0
    bl jl_puts                                      // print string and return size in x0

    adrp x19, cpu_cores_value                       // get address to the dummy value
    add x19, x19, :lo12:cpu_cores_value

    mov x0, x19                                     // jl_puts wants a string in x0
    bl jl_puts                                      // print string and return size in x0
//
// -----------------------------------------------------
//

done:
    // EPILOGUE: often used to restore x29 and x30
    ldp x29, x30, [sp], #16                         // restore x29, x30 and stack

    ret     