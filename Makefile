NAME = bootloader

# Directories
SRC_DIR = src
BIN_DIR = bin
OBJ_DIR = $(BIN_DIR)/obj

# Files
BOOTLOADER_BIN = $(BIN_DIR)/$(NAME).bin

# Parameters
DISK_SECTOR_NB = 2

all: run

$(BOOTLOADER_BIN): $(SRC_DIR)/bootloader.asm
	mkdir -p $(dir $@)
	nasm $< -f bin -o $@ -DDISK_SECTOR_NB=$(DISK_SECTOR_NB)

bin: $(BOOTLOADER_BIN)

run: $(BOOTLOADER_BIN)
	qemu-system-x86_64 $<

clean:
	rm -Rf $(BIN_DIR)
