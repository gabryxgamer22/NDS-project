# 1. Prima includiamo le regole di sistema
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

# 2. Ora definiamo il nome del gioco e le cartelle
TARGET      := IlMioGiocoNDS
SOURCES     := source
BUILD       := build

# 3. Forziamo i parametri esatti usando += così devkitPro non li cancella
CFLAGS      += -DARM9 -march=armv5te -mtune=arm946e-s -mthumb -mthumb-interwork -specs=ds_arm9.specs -I$(LIBNDS)/include
LDFLAGS     += -specs=ds_arm9.specs -L$(LIBNDS)/lib

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@echo "--- Creazione del file .nds finale ---"
	ndstool -c $@ -9 $<

$(TARGET).elf: $(SOURCES)/main.c
	@echo "--- Compilazione in corso ---"
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $< $(LDFLAGS) -lnds9 -o $@

clean:
	@echo "Pulizia file temporanei..."
	@rm -rf $(BUILD) *.elf *.nds
