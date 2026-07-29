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

// print pair

// print multiline headers
