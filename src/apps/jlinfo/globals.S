//
// Global runtime data used by jlinfo
//
.section .bss
.align 3

.global global_temp_itoa_buffer
.global global_temp_value_buffer

// Temporary buffer used to convert integers to string
global_temp_itoa_buffer:
    .skip 33

global_temp_value_buffer:
    .skip 1000

