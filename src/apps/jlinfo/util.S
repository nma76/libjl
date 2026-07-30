//
// Misc utils
//
.section .rodata 
.align 4 

clear_screen_string: 
.asciz "\033[H\033[2J"

.include "macros.inc"

.section .text

.global clear_screen

clear_screen:
    // PROLOGUE: often used to store x29 and x30
    PROLOGUE

    // Clear Screen
    PRINT_STRING clear_screen_string

    // EPILOGUE: often used to restore x29 and x30
    EPILOGUE

    ret
