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

# Opzioni di compilazione obbligatorie per l'architettura ARM9 del DS
ARCH        := -mthumb -mthumb-interwork
CFLAGS      := -g -Wall -O2 -march=armv5te -mtune=arm946e-s -fomit-frame-pointer -ffast-math $(ARCH) -DARM9
LDFLAGS     := -g $(ARCH) -mthumb -mthumb-interwork -specs=ds_arm9.specs

LIBS        := -lnds9
LIBDIRS     := -I$(LIBNDS)/include -L$(LIBNDS)/lib

#---------------------------------------------------------------------------------
# REGOLE DI COMPILAZIONE DIRECTE
#---------------------------------------------------------------------------------
.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@echo "--- Creazione del file .nds finale ---"
	ndstool -c $@ -9 $<

$(TARGET).elf: $(SOURCES)/main.c
	@echo "--- Compilazione in corso ---"
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(LIBDIRS) $(LIBS) $< -o $@

clean:
	@echo "Pulizia file temporanei..."
	@rm -rf $(BUILD) *.elf *.nds
