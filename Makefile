NAME = bootloader

# Directories
SRC_DIR = src
BIN_DIR = bin
OBJ_DIR = $(BIN_DIR)/obj

# Files
BOOTLOADER_BIN = $(BIN_DIR)/$(NAME).bin

all: run

$(BOOTLOADER_BIN): $(SRC_DIR)/bootloader.asm
	mkdir -p $(dir $@)
	nasm $< -f bin -o $@

bin: $(BOOTLOADER_BIN)

run: $(BOOTLOADER_BIN)
	qemu-system-x86_64 $<

clean:
	rm -Rf $(BIN_DIR)
