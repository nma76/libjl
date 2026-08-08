# libjl and jlinfo Style Guide

This document reflects the conventions currently used in **libjl** and **jlinfo**. The goal is consistency, readability and maintainability across the assembly sources in this repository.

---

# General Principles

- Prefer simple and direct code over clever tricks.
- Keep each function focused on one responsibility.
- Comments should explain intent, structure or data flow.
- Reuse existing patterns and macros before introducing new ones.

---

# File Organization

Each module should have one clear responsibility.

Examples from the current codebase:

```asm
cpuinfo.S     Reads and parses /proc/cpuinfo
cpu.S         Prints CPU information
uname.S       Wraps uname() and exposes getters
system.S      Prints system information
```

Use explicit sections for data and code:

- `.section .rodata` for constants and string literals
- `.section .bss` for buffers and uninitialized data
- `.section .text` for executable code

Export public symbols with `.global`.

jlinfo modules commonly include `macros.inc` when they use shared printing and stack helpers.

---

# Function Layout

Functions should follow a straightforward top-to-bottom structure.

```asm
function_name:
    PROLOGUE

    ...

    EPILOGUE
    ret
```

Leaf functions may omit prologue and epilogue when they do not need stack space or callee-saved register preservation. The library helpers in `jl_strlen.S` and `jl_memcpy.S` follow this style.

When a function needs to preserve `x29`/`x30` or use stack space, use the shared `PROLOGUE` and `EPILOGUE` macros from `macros.inc`.

---

# Labels

Use descriptive labels in snake_case.

Examples:

```asm
cpuinfo_corecount_loop
cpuinfo_corecount_done
next_entry
found
not_found
done
```

Avoid generic names such as:

```asm
loop1
loop2
label1
```

Local helper labels should describe their purpose clearly.

---

# Register Policy

## x0-x7

Used for:

- function arguments
- return values
- syscall arguments

Do not rely on these surviving a `bl` call.

---

## x9-x15

These are the default scratch registers.

Use them for:

- pointers
- counters
- temporary values
- loop variables

The current libjl helpers commonly use `x9` and `w10` as temporary registers.

---

## x19-x28

Use these when a value must survive one or more `bl` calls.

Examples:

- file descriptors
- pointers used across function calls
- long-lived state

If a function modifies a callee-saved register, it must preserve it on the stack.

Example:

```asm
stp x19, x20, [sp, #-16]!

...

ldp x19, x20, [sp], #16
```

---

# Stack

Maintain 16-byte stack alignment.

Do not leave the stack unbalanced.

The shared `PROLOGUE`/`EPILOGUE` macros use a 16-byte frame and preserve `x29`/`x30`.

---

# Comments

Prefer comments that describe intent or structure.

Good:

```asm
// Read next byte from needle
```

Also common in this codebase:

```asm
// CPU Banner
// CPU Architecture
// System Banner
```

Avoid comments that restate the instruction in plain words. The instruction itself is usually clear enough.

Comments are written in English in the current sources.

---

# Naming

Use names that make the role of the function obvious.

Library functions:

```asm
jl_strlen
jl_strcmp
jl_strstr
jl_memcpy
```

jlinfo helpers:

```asm
cpuinfo_get_corecount
cpuinfo_get_architecture
uname_get_sysname
system_print
```

Use prefixes consistently:

- `jl_` for libjl functions
- `print_` for output functions
- `get_` or `read_` for accessors and readers

---

# Macros

Macros are used to remove repetitive boilerplate.

The current jlinfo code uses macros for:

- common prologue and epilogue
- loading addresses of labels
- printing strings and numbers
- emitting newlines
- iterating over heading blocks

Examples from the codebase include:

- `PROLOGUE`
- `EPILOGUE`
- `PRINT_STRING`
- `PRINT_NUMBER_FROM_FUNC`
- `PRINT_NEWLINE`
- `UNAME_GETTER`

Keep the main logic in the function body. Avoid hiding important behavior inside macros.

---

# Documentation

Public functions should be documented with a short comment block that explains:

- purpose
- input registers
- return value
- scratch registers used when relevant

The libjl sources use simple block comments above the function body. Keep that style for exported helpers.

Example:

```asm
//
// JL_STRLEN
//
// Count the length of a string.
//
// Input:
//      x0 - pointer to the string
//
// Returns:
//      x0 - string length
//
// Scratch registers:
//      w9
//      w10
//
```

---

# Testing

Every public libjl function should have at least one unit test.

Tests should cover:

- normal case
- empty or boundary conditions
- failure or null cases where applicable

---

# Philosophy

Keep the assembly readable by a human.

Prefer:

- small focused functions
- straightforward control flow
- explicit sections and labels
- reusable helpers over dense micro-optimizations

The code in this repository favors clarity first, with macros and structure used to keep the sources maintainable.
