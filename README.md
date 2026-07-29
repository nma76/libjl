# libjl

**libjl** är ett litet standardbibliotek skrivet från grunden i ARM64 Assembly för Linux.

Projektets syfte är att utforska ARM64-arkitekturen, Linux systemanrop och hur ett eget bibliotek kan byggas upp utan beroende av libc. Biblioteket används av exempelprogram, där **jlinfo** är slutmålet.

---

## Projektstruktur

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

Header-filer som används av C-program och tester.

### `libjl.h`

Deklarerar alla publika funktioner som exporteras av **libjl**.

Exempel:

- String-funktioner
- Minnesfunktioner
- Linux syscall-wrapperar
- Hjälpfunktioner

---

## src/apps/

Innehåller exempelprogram som använder **libjl**.

Varje applikation ligger i en egen katalog.

Exempel:

```
src/apps/
└── jlinfo/
    ├── start.S
    ├── banner.S
    ├── cpu.S
    ├── memory.S
    └── ...
```

Varje modul ansvarar för ett specifikt område av programmet.

---

## src/lib/

Bibliotekets implementation.

Varje funktion implementeras i en egen Assembly-fil.

Exempel:

```
src/lib/

jl_strlen.S
jl_strcpy.S
jl_memcpy.S
jl_write.S
jl_open.S
...
```

Alla objektfiler länkas samman till det statiska biblioteket:

```
libjl.a
```

---

## tests/

Tester skrivna i C.

Syftet är att verifiera att funktionerna i **libjl** fungerar korrekt genom att anropa biblioteket från ett vanligt C-program.

Exempel:

```
tests/

test_strlen.c
test_memcpy.c
test_write.c
...
```

Alla tester länkas mot `libjl.a`.

---

## Bygga projektet

Bygg bibliotek, tester och applikationer:

```bash
make
```

Rensa alla byggda filer:

```bash
make clean
```

---

## Mål

Projektets långsiktiga mål är att bygga ett litet men användbart ARM64 Assembly-bibliotek som innehåller:

- Stränghantering
- Minneshantering
- Linux syscall-wrapperar
- Enkla I/O-funktioner
- Hjälpfunktioner för systemprogram

Biblioteket används sedan av egna program, exempelvis **jlinfo**, som demonstrerar bibliotekets funktionalitet i praktiken.

---

## Status

Projektet är under aktiv utveckling och fungerar samtidigt som en praktisk studie av:

- ARM64 Assembly
- Linux ABI
- ELF-format
- Linux systemanrop
- Statiska bibliotek
- Länkning