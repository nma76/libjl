.macro PRINT_STRING label
    adrp x0, \label                    
    add  x0, x0, :lo12:\label
    bl   jl_puts  
.endm

.macro PRINT_FIELD heading, value
    PRINT_STRING \heading
    PRINT_STRING \value
.endm

.macro PROLOGUE
    stp x29, x30, [sp, #-16]!           // Allokera 16 bytes OCH spara x29/x30
    mov x29, sp                         // Uppdatera frame pointer till nuvarande stacktop
.endm

.macro EPILOGUE
    ldp x29, x30, [sp], #16             // restore x29, x30 and stack
.endm

.macro PRINT_HEADING_BLOCK heading_block
    adrp x19, \heading_block            // get the address of label with the correct offset
    add x19, x19, :lo12:\heading_block   

loop_\@:
    ldrb w20, [x19]                     // read the first byte from string
    cbz w20, done_\@                    // if null, no more strings

    mov x0, x19                         // jl_puts wants a string in x0
    bl jl_puts                          // print string and return size in x0

    add x19, x19, x0                    // jump ahead with the number of bytes written
    add x19, x19, #1                    // jump ahead one more byte to skipp null-pointer
    b loop_\@                           // start over with the next line

done_\@:
.endm
