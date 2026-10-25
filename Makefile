ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

TARGET      := IlMioGiocoNDS
SOURCES     := source
BUILD       := build

# Flag separati per evitare conflitti di spec
CFLAGS      := -DARM9 -march=armv5te -mtune=arm946e-s -mthumb -mthumb-interwork -I$(LIBNDS)/include
LDFLAGS     := -specs=ds_arm9.specs -L$(LIBNDS)/lib

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@echo "--- Creazione del file .nds finale ---"
	ndstool -c $@ -9 $<

$(TARGET).elf: $(SOURCES)/main.c
	@echo "--- Compilazione in corso ---"
	@mkdir -p $(BUILD)
	# Fase 1: Compila solo il file sorgente in un file oggetto (.o) senza fare il link
	$(CC) $(CFLAGS) -c $< -o $(BUILD)/main.o
	# Fase 2: Unisce il file oggetto usando le specifiche corrette del DS
	$(CC) $(LDFLAGS) $(BUILD)/main.o -lnds9 -o $@

clean:
	@echo "Pulizia file temporanei..."
	@rm -rf $(BUILD) *.elf *.nds
