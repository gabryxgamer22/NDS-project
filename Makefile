#---------------------------------------------------------------------------------
# Configurazione build per NDS (ARM9)
#---------------------------------------------------------------------------------
TARGET   := IlMioGiocoNDS
SOURCES  := source
BUILD    := build

DEVKITPRO ?= /opt/devkitpro
DEVKITARM := $(DEVKITPRO)/devkitARM
NDSLIB    := $(DEVKITPRO)/libnds
CC        := $(DEVKITARM)/bin/arm-none-eabi-gcc
NDSTOOL   := $(DEVKITPRO)/tools/bin/ndstool

# Compatibilità locale per toolchain incompleti: alcuni nds.h richiedono
# calico.h / calico/types.h anche se non sono indispensabili per un minimo project
CFLAGS    := -g -O2 -Wall -Wextra -march=armv5te -mtune=arm946e-s -mthumb -mthumb-interwork -DARM9 -D__NDS__ \
             -I$(CURDIR)/include -I$(NDSLIB)/include -I$(NDSLIB)/include/arm9
LDFLAGS   := -specs=ds_arm9.specs -L$(NDSLIB)/lib
LDLIBS    := -lnds9

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@echo "--- Creazione del file .nds finale ---"
	$(NDSTOOL) -c $@ -9 $<

$(TARGET).elf: $(SOURCES)/main.c | $(BUILD)
	@echo "--- Compilazione in corso ---"
	$(CC) $(CFLAGS) -c $< -o $(BUILD)/main.o
	$(CC) $(LDFLAGS) $(BUILD)/main.o $(LDLIBS) -o $@

$(BUILD):
	@mkdir -p $(BUILD)

clean:
	@echo "Pulizia file temporanei..."
	@rm -rf $(BUILD) *.elf *.nds
