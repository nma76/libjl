CC      := gcc
AS      := gcc
LD      := ld

CFLAGS  := -Wall -Iinclude

#
# ----------------------------------------------------------------------
# Library
# ----------------------------------------------------------------------
#

LIB_SRC := $(wildcard src/lib/*.S)
LIB_OBJ := $(patsubst src/lib/%.S,obj/lib_%.o,$(LIB_SRC))

LIBRARY := libjl.a

#
# ----------------------------------------------------------------------
# Applications
# Each application lives in src/apps/<name>/
# and must contain start.S
# ----------------------------------------------------------------------
#

APP_DIRS := $(wildcard src/apps/*)
APP_NAMES := $(notdir $(APP_DIRS))
APP_BINS := $(addprefix bin/,$(APP_NAMES))

#
# ----------------------------------------------------------------------
# Tests
# One single test runner built from all C files in tests/
# ----------------------------------------------------------------------
#

TEST_SRC := $(wildcard tests/*.c)
TEST_BIN := bin/tests

#
# ----------------------------------------------------------------------
# Default targets
# ----------------------------------------------------------------------
#

.PHONY: all clean tests apps

all: $(LIBRARY) tests apps

tests: $(TEST_BIN)

apps: $(APP_BINS)

#
# ----------------------------------------------------------------------
# Library
# ----------------------------------------------------------------------
#

$(LIBRARY): $(LIB_OBJ)
	ar rcs $@ $^

obj/lib_%.o: src/lib/%.S
	@mkdir -p obj
	$(CC) -c $< -o $@

#
# ----------------------------------------------------------------------
# Test runner
# ----------------------------------------------------------------------
#

$(TEST_BIN): $(TEST_SRC) $(LIBRARY)
	@mkdir -p bin
	$(CC) $(CFLAGS) $^ -L. -ljl -o $@

#
# ----------------------------------------------------------------------
# Applications
# ----------------------------------------------------------------------
#

bin/%: src/apps/%/start.S $(LIBRARY)
	@mkdir -p bin obj
	$(AS) -c $< -o obj/$*.o
	$(LD) obj/$*.o $(LIBRARY) -o $@

#
# ----------------------------------------------------------------------
# Cleanup
# ----------------------------------------------------------------------
#

clean:
	rm -rf obj/*
	rm -rf bin/*
	rm -f $(LIBRARY)