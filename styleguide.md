# libjl Style Guide

This document defines the coding style used throughout **libjl** and **jlinfo**.
The purpose is consistency, readability and maintainability.

---

# General Principles

- Prefer readability over cleverness.
- Write code that explains *what* it does.
- Comments should explain **intent**, not individual instructions.
- Refactor only when duplication becomes obvious.

---

# File Organization

Each module should have one clear responsibility.

Example:

```
cpuinfo.S     Reads and parses /proc/cpuinfo
cpu.S         Prints CPU information
uname.S       Reads uname() information
system.S      Prints system information
```

Separate:

- data (.rodata / .bss)
- macros
- code (.text)

---

# Function Layout

Functions should follow the same structure whenever possible.

```asm
function_name:
    PROLOGUE

    ...

    EPILOGUE
    ret
```

Leaf functions should normally omit prologue/epilogue if no stack or callee-saved registers are needed.

---

# Labels

Use descriptive labels.

Example:

```
outer_loop
inner_loop
next_entry
found
not_found
done
```

Avoid generic labels like:

```
loop1
loop2
label1
```

Local helper labels inside a function should describe their purpose.

---

# Register Policy

## x0-x7

Used for:

- function arguments
- return values
- syscall arguments

Do not rely on these surviving a `bl`.

---

## x9-x15

Default scratch registers.

Use for:

- pointers
- counters
- temporary values
- loop variables

These are the preferred temporary registers.

---

## x19-x28

Use only when values must survive one or more `bl`.

Examples:

- file descriptors
- pointers used across function calls
- long-lived state

Always preserve callee-saved registers.

Example:

```asm
stp x19, x20, [sp, #-16]!

...

ldp x19, x20, [sp], #16
```

---

# Stack

Maintain 16-byte stack alignment.

Never leave the stack unbalanced.

---

# Comments

Prefer comments that describe intent.

Good:

```asm
// Read next byte from needle
```

Avoid:

```asm
// Load byte into w10
```

Instruction names already describe the second example.

---

# Naming

Functions:

```
jl_strlen
jl_strcmp
jl_strstr
```

Getters:

```
get_sysname
get_architecture
```

Readers / Initializers:

```
read_uname
init_cpuinfo
```

Printers:

```
print_sys
print_cpu
```

---

# Macros

Macros should remove repetitive boilerplate.

Good candidates:

- common prologue/epilogue
- loading labels
- printing
- repeated code sequences

Avoid hiding important program logic inside macros.

libjl should remain easy to read as ARM64 assembly.

jlinfo may use macros more aggressively.

---

# Documentation

Every public function should contain:

- purpose
- input registers
- return value
- scratch registers used

Example:

```asm
//
// JL_STRSTR
//
// Search a string for a substring.
//
// Input:
//      x0 - haystack
//      x1 - needle
//
// Returns:
//      x0 - pointer to first match
//           NULL if not found
//
// Scratch registers:
//
//      x2
//      x3
//      x4
//      w10
//      w11
//
```

---

# Testing

Every public function should have at least one unit test.

Include:

- normal case
- boundary conditions
- failure case

---

# Philosophy

Build simple functions.

Build reusable functions.

Only introduce abstractions after duplication appears.

Assembly should remain readable by a human.