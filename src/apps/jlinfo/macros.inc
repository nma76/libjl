.macro print_label label
    adrp x0, \label                    
    add  x0, x0, :lo12:\label
    bl   jl_puts  
.endm
