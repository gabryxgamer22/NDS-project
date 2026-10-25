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

# Usiamo solo le macro native di devkitPro per evitare doppioni
CFLAGS      := $(ARM9FLAGS) -I$(LIBNDS)/include
LDFLAGS     := $(NDS_LDFLAGS) -L$(LIBNDS)/lib

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
