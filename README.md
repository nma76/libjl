# libjl

**libjl** is a small standard library written from scratch in ARM64 Assembly for Linux.

The purpose of the project is to explore the ARM64 architecture, Linux system calls, and how a custom library can be built without relying on libc. The library is used by example programs, with **jlinfo** as the end goal.

This project started as an exercise in ARM64 Assembly, but gradually grew into a small standalone standard library and a collection of tools built on top of it.

---

## Project Structure

```
.
├── include/
│   └── libjl.h
├── src/
│   ├── apps/
│   └── lib/
├── tests/
├── obj/
├── bin/
└── libjl.a
```

---

## include/

Header files used by C programs and tests.

### `libjl.h`

Declares all public functions exported by **libjl**.

Examples:

- String functions
- Memory functions
- Linux syscall wrappers
- Helper functions

---

## src/apps/

Contains example programs that use **libjl**.

Each application is placed in its own directory.

Example:

```
src/apps/
└── jlinfo/
    ├── start.S
    ├── banner.S
    ├── cpu.S
    ├── memory.S
    └── ...
```

Each module is responsible for a specific part of the program.

---

## src/lib/

The implementation of the library.

Each function is implemented in its own Assembly file.

Example:

```
src/lib/

jl_strlen.S
jl_strcpy.S
jl_memcpy.S
jl_write.S
jl_open.S
...
```

All object files are linked together into the static library:

```
libjl.a
```

---

## tests/

Tests written in C.

The purpose is to verify that the functions in **libjl** work correctly by calling the library from a regular C program.

Example:

```
tests/

test_strlen.c
test_memcpy.c
test_write.c
...
```

All tests are linked against `libjl.a`.

---

## Building the Project

Build the library, tests, and applications:

```bash
make
```

Remove all build artifacts:

```bash
make clean
```

---

## Goals

The long-term goal of the project is to build a small but useful ARM64 Assembly library containing:

- String handling
- Memory handling
- Linux syscall wrappers
- Simple I/O functions
- Helper functions for system programs

The library is then used by custom programs, such as **jlinfo**, to demonstrate its functionality in practice.

---

## Status

The project is under active development and serves at the same time as a practical study of:

- ARM64 Assembly
- Linux ABI
- ELF format
- Linux system calls
- Static libraries
- Linking