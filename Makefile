#---------------------------------------------------------------------------------
# PARAMETRI FONDAMENTALI
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

TARGET      := IlMioGiocoNDS
SOURCES     := source
BUILD       := build

# Opzioni di architettura e flag obbligatori per Nintendo DS
ARCH        := -mthumb -mthumb-interwork
CFLAGS      := -g -Wall -O2 -march=armv5te -mtune=arm946e-s -fomit-frame-pointer -ffast-math $(ARCH) -DARM9 -I$(LIBNDS)/include
LDFLAGS     := -g $(ARCH) -mthumb -mthumb-interwork -specs=ds_arm9.specs -L$(LIBNDS)/lib

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@echo "--- Creazione del file .nds finale ---"
	ndstool -c $@ -9 $<

$(TARGET).elf: $(SOURCES)/main.c
	@echo "--- Compilazione in corso ---"
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $(BUILD)/main.o
	$(CC) $(LDFLAGS) $(BUILD)/main.o -lnds9 -o $@

clean:
	@echo "Pulizia file temporanei..."
	@rm -rf $(BUILD) *.elf *.nds
