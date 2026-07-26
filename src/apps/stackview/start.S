.section .rodata
argc_heading:
    .asciz "------------ ARGC ------------\n"
argv_heading:
    .asciz "------------ ARGV ------------\n"
env_heading:
    .asciz "------------ ENV  ------------\n"
at_heading:
    .asciz "------------  AT  ------------\n"
end_heading:
    .asciz "------------------------------\n\n"

hex_prefix:
    .asciz "0x"

newline:
    .asciz "\n"
colon:
    .asciz ":"
debug:
    .asciz "Debug"

.section .bss
.align 3
buffer:
    .space 33

.global _start

.section .text

_start:
    //
    // Initialize callee-saved registers
    //
    // We use them for two reasons: 
    //      1. Any external function could overwrite the scratch registers 
    //      2. It's ok not to restore them in an ELF binary, because the process terminates and there's no caller to return to. 
    //
    mov x19, #0             // x19 is used to store argc
    mov x20, #0             // x20 is used to temporary store stack pointer

    // Init stuff
    add x20, sp, #8         // store stack pointer so we can step by 8 instead of 16

    //
    // Helper functions
    //

    //
    // Help functions ends
    //

print_argc:
    //
    // ARGC - Argument Count
    // first 8 bytes on the stack is argc (number of arguments)
    // we use jl_itoa to convert the number to ASCII and jl_puts to print to stdout
    //
    ldr x0, =argc_heading   // print section heading
    bl jl_puts

    ldr x19, [sp]           // load argc into register x19
    mov w0, w19             // jl_itoa needs the integer in x0
    ldr x1, =buffer         // buffer holding the result
    bl jl_itoa              // call jl_itoa

    ldr x0, =buffer         // load buffer to print into x0
    bl jl_puts              // and print it

    ldr x0, =newline        // load newline into x0
    bl jl_puts              // and print it

    ldr x0, =end_heading   // print section heading end
    bl jl_puts
    //
    // ARGC Ends
    //

print_argv:
    //
    // ARGV - Argument Vector (list of arguments)
    // the next part of stack contains a list of arguments. Length of the list is argc.
    // the list is NULL terminated, but we use argc as counter instead of looping until we find \0
    //
    ldr x0, =argv_heading   // print section heading
    bl jl_puts

loop_argv:                 // we need to loop according to argc, which is stored in x9
    cbz w19, done_argv       // if x9 reach 0, loop is done!

    ldr x0, [x20], #8       // load pointer 
    bl jl_puts              // print whatever is at that pointer

    ldr x0, =newline        // load newline into x0
    bl jl_puts              // and print it

    sub w19, w19, #1
    b loop_argv
done_argv:
    ldr x0, =end_heading   // print section heading end
    bl jl_puts

    add x20, x20, #8        // the next 8 bytes after the last argv is null termination, we skip that
    //
    // ARGV Ends
    //

    // 
    // ENV Vector - Environment variables
    // the next part of the stack contains environment variables.
    // the list is NULL terminated, so we loop until we reach \0
    //
    ldr x0, =env_heading   // print section heading
    bl jl_puts

print_env:
    ldr x0, [x20], #8       // load pointer on address into x0
    cbz x0, done_env        // if we get NULL, we quit

    bl jl_puts              // print whatever string is at that pointer

    ldr x0, =newline        // load newline into x0
    bl jl_puts              // and print it

    b print_env
done_env:    
    ldr x0, =end_heading   // print section heading end
    bl jl_puts

    add x20, x20, #8        // Skip null terminator by skipping 8 bytes
    //
    // ENV Ends
    //


    //
    // Auxiliary Vector
    //
    // String value types:
    //  15 (AT_PLATFORM) - Hårdvaruplattformen (t.ex. strängen "aarch64").
    //  24 (AT_BASE_PLATFORM) - Sträng som beskriver den underliggande arkitekturen (t.ex. "aarch64"). Liknar AT_PLATFORM (#15).
    //  31 (AT_EXECFN) - Den exakta sökvägen som användes för att starta programmet (t.ex. "/bin/ls" eller "./mitt_program").
    //
    // Pointers or binary data:
    //  3 (AT_PHDR) - Pekare till programmets Program Headers (början av ELF-strukturen i minnet).
    //  7 (AT_BASE) - Basadressen i minnet där den dynamiska länkaren (ld.so) laddades in.
    //  9 (AT_ENTRY) - Den virtuella minnesadressen där programmets kod startar (adressen till _start).
    //  16 (AT_HWCAP) - Viktig! Detta är den faktiska primära bitmasken för hårdvarustöd på Linux. (Du hade skrivit #26 för AT_HWCAP i din kod, men #26 är egentligen AT_HWCAP2 eller AT_NOTELF).
    //  18 (AT_FPUCW) - Kontrollord för flyttalsprocessorn (FPU), används mest på äldre x86 men kan dyka upp.
    //  25 (AT_RANDOM) - Pekare till 16 slumpmässiga bytes som operativsystemet skapat (används av kompilatorn för att skapa "stack canaries" som skyddar mot buffertöverskridning).
    //  26 (AT_HWCAP) och 38 (AT_HWCAP2) - Ibland pekare eller bitmasker som talar om vilka processorinstruktioner som stöds (t.ex. om NEON, AES eller CRC32 är aktiverat i hårdvaran).
    //  33 (AT_SYSINFO_EHDR) - Pekare till vDSO (Virtual Dynamic Shared Object). Det är en liten virtuell ELF-fil som operativsystemet mappar in i ditt minne för att göra systemanrop (syscalls) mycket snabbare.
    //  40 (AT_L1I_CACHESHAPE) - Beskriver geometrin (associativitet, linjestorlek) för L1-instruktionscachen.
    //  41 (AT_L1D_CACHESHAPE) - Beskriver geometrin för L1-datacachen.
    //  42 (AT_L2_CACHESHAPE) - Beskriver geometrin för L2-cachen.
    //  43 (AT_L3_CACHESHAPE) - Beskriver geometrin för L3-cach    
    //
    // Numeric values, safe for itoa
    //  0 (AT_NULL) - Slutmarkör för hela tabellen. Både typ och värde är 0.
    //  2 (AT_PHNUM)
    //  4 (AT_PHENT) - Storleken i bytes på en enskild Program Header-post (på 64-bit är detta alltid 56 bytes).
    //  5 (AT_PHNUM) - Totalt antal Program Headers som filen innehåller.
    //  6 (AT_PAGESZ) - Systemets minnessidstorlek i bytes (oftast 4096 eller 65536 på ARM64).
    //  8 (AT_FLAGS) - Systemflaggor för processen (oftast 0).
    //  11 (AT_UID) - Det reella användar-ID:t (User ID) för användaren som kör programmet (t.ex. 1000).
    //  12 (AT_EUID) - Det effektiva användar-ID:t (används vid setuid).
    //  13 (AT_GID) - Det reella grupp-ID:t (Group ID).
    //  14 (AT_EGID) - Det effektiva grupp-ID:t.
    //  17 (AT_CLKTCK) - Systemets klockfrekvens för processor-ticks (oftast 100 på Linux, används för att mäta tid med funktionen times()).
    //  19 (AT_DCACHEBSIZE) - Storleken på processorns datacache-block i bytes.
    //  20 (AT_ICACHEBSIZE) - Storleken på processorns instruktionscache-block i bytes.
    //  21 (AT_UCACHEBSIZE) - Storleken på en enhetlig cache (unified cache), om sådan finns.
    //  23 (AT_SECURE) - En flagga (1 eller 0) som talar om ifall programmet körs med förhöjda rättigheter (t.ex. via sudo). Om den är 1 rensar Linux bort vissa osäkra miljövariabler.
    //  46 (AT_MINSIGSTKSZ) - Mycket vanlig på ARM64! Minsta tillåtna stackstorlek i bytes för att kunna hantera signaler (används för arkitekturspecifika tillägg som SVE/SME-register).
    //
    ldr x0, =at_heading   // print section heading
    bl jl_puts

print_aux:    
    ldr x21, [x20], #8      // load AT_type
    cbz x21, done_aux       // if x21 is NULL, we have reached the end
    ldr x22, [x20], #8      // load AT_val

    // print numeric value of x21 and a colon    
    mov x0, x21             // copy x21 to work with jl_itoa
    ldr x1, =buffer         // set output buffer
    bl jl_itoa              // call jl_itoa to get the number

    ldr x0, =buffer         // load buffer to print into x0
    bl jl_puts              // and print it

    mov x0, #':'
    bl jl_putchar

    // string values
    cmp x21, #15            
    b.eq print_aux_string
    cmp x21, #24            
    b.eq print_aux_string
    cmp x21, #31            
    b.eq print_aux_string

    // numeric values
    cmp x21, #2             
    b.eq print_aux_numeric
    cmp x21, #4             
    b.eq print_aux_numeric
    cmp x21, #5             
    b.eq print_aux_numeric
    cmp x21, #6             
    b.eq print_aux_numeric
    cmp x21, #8             
    b.eq print_aux_numeric
    cmp x21, #11            
    b.eq print_aux_numeric
    cmp x21, #12            
    b.eq print_aux_numeric
    cmp x21, #13            
    b.eq print_aux_numeric
    cmp x21, #14            
    b.eq print_aux_numeric
    cmp x21, #17            
    b.eq print_aux_numeric
    cmp x21, #19            
    b.eq print_aux_numeric
    cmp x21, #20            
    b.eq print_aux_numeric
    cmp x21, #21            
    b.eq print_aux_numeric
    cmp x21, #23            
    b.eq print_aux_numeric
    cmp x21, #46            
    b.eq print_aux_numeric

    // print HEX
    cmp x21, #7             
    b.eq print_aux_hex
    cmp x21, #9             
    b.eq print_aux_hex
    cmp x21, #16            
    b.eq print_aux_hex
    cmp x21, #18            
    b.eq print_aux_hex
    cmp x21, #26            
    b.eq print_aux_hex

    // print HEX-dump (dump mem at pointer)
    cmp x21, #25            
    b.eq print_aux_hexdump
    // Maybe just the first 64 bytes?
    cmp x21, #3             
    b.eq print_aux_hexdump
    cmp x21, #33            
    b.eq print_aux_hexdump
    cmp x21, #40            
    b.eq print_aux_hexdump
    cmp x21, #41            
    b.eq print_aux_hexdump
    cmp x21, #42            
    b.eq print_aux_hexdump
    cmp x21, #43            
    b.eq print_aux_hexdump

print_aux_unknown:
    // Debug - we found something else
    //mov x0, x21             // copy x21 to work with jl_itoa
    //ldr x1, =buffer         // set output buffer
    //bl jl_itoa              // call jl_itoa to get the number

    //ldr x0, =buffer         // load buffer to print into x0
    //bl jl_puts              // and print it

    //ldr x0, =newline        // load newline into x0
    //bl jl_puts              // and print it

    ldr x0, =newline        // load newline into x0
    bl jl_puts              // and print it

    b print_aux

print_aux_hexdump:
    mov x0, #'D'
    bl jl_putchar

    ldr x0, =newline        // load newline into x0
    bl jl_puts              // and print it

    b print_aux

print_aux_hex:
    mov x0, #'H'
    bl jl_putchar

    ldr x0, =newline        // load newline into x0
    bl jl_puts              // and print it

    b print_aux

print_aux_numeric:
    mov x0, x22             // jl_itoa needs the integer in x0
    ldr x1, =buffer         // buffer holding the result
    bl jl_itoa              // call jl_itoa
    
    ldr x0, =buffer
    bl jl_puts

    ldr x0, =newline        // load newline into x0
    bl jl_puts              // and print it

    b print_aux

print_aux_string:
    mov x0, x22
    bl jl_puts              // print whatever string is at that pointer

    ldr x0, =newline        // load newline into x0
    bl jl_puts              // and print it

    b print_aux

done_aux:
    ldr x0, =end_heading   // print section heading
    bl jl_puts



    // 
    // EXIT - using Linux Syscal
    //
    mov x0, #42
    mov x8, #93
    svc #0
     