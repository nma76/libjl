//
// Global runtime data used by jlinfo
//
.section .bss
.align 3

.global temp_itoa_buffer
.global temp_buffer

// Temporary buffer used to convert integers to string
temp_itoa_buffer:
    .skip 33

temp_buffer:
    .skip 100

