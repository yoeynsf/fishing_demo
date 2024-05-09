.PHONY: all clean run dir

OUTPUT := output

SRCDIR	:= src
ROM_NAME := $(OUTPUT)/fish.nes
DBG_NAME := $(OUTPUT)/fish.dbg

OBJ_DIR := $(OUTPUT)/obj

# Specify files to build the ROM
PRG_FILES := $(wildcard $(SRCDIR)/*.s)
PRG_OBJ_FILES := $(patsubst $(SRCDIR)/%.s, $(OBJ_DIR)/%.o, $(PRG_FILES))

all: $(ROM_NAME)

clean:
	@rmdir /s output

run:
	@start Mesen.exe $(ROM_NAME)

dir:
	@md output
	@md output\obj

# Link object files into ROM
$(ROM_NAME): $(PRG_OBJ_FILES)
	ld65 --dbgfile $(DBG_NAME) -o $@ -C N163.cfg $^

# Assemble 6502 code
$(OBJ_DIR)/%.o: $(SRCDIR)/%.s
	ca65 -s -g $< -o $@