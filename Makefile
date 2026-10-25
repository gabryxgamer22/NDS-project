#---------------------------------------------------------------------------------
# PARAMETRI DI COMPILAZIONE DIRETTI (CON INCLUSIONE ARM9)
#---------------------------------------------------------------------------------
TARGET      := IlMioGiocoNDS
SOURCES     := source
BUILD       := build

# Aggiunto il percorso assoluto verso la cartella libnds/include/arm9 per trovare calico.h
CFLAGS      := -march=armv5te -mtune=arm946e-s -mthumb -mthumb-interwork -DARM9 -D__NDS__ -I/opt/devkitpro/libnds/include -I/opt/devkitpro/libnds/include/arm9
LDFLAGS     := -specs=ds_arm9.specs -L/opt/devkitpro/libnds/lib

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@echo "--- Creazione del file .nds finale ---"
	/opt/devkitpro/tools/bin/ndstool -c $@ -9 $<

$(TARGET).elf: $(SOURCES)/main.c
	@echo "--- Compilazione in corso ---"
	@mkdir -p $(BUILD)
	# Compilazione del file oggetto con tutti i percorsi di inclusione corretti
	/opt/devkitpro/devkitARM/bin/arm-none-eabi-gcc $(CFLAGS) -c $< -o $(BUILD)/main.o
	# Collegamento finale con le specifiche hardware del DS
	/opt/devkitpro/devkitARM/bin/arm-none-eabi-gcc $(LDFLAGS) $(BUILD)/main.o -lnds9 -o $@

clean:
	@echo "Pulizia file temporanei..."
	@rm -rf $(BUILD) *.elf *.nds
