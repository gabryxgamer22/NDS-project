#---------------------------------------------------------------------------------
# PARAMETRI DI COMPILAZIONE DIRETTI (SENZA REGOLE ESTERNE)
#---------------------------------------------------------------------------------
TARGET      := IlMioGiocoNDS
SOURCES     := source
BUILD       := build

# Il segreto è passare sia il flag -DARM9 sia le specifiche minime senza raddoppiare i link
CFLAGS      := -march=armv5te -mtune=arm946e-s -mthumb -mthumb-interwork -DARM9 -D__NDS__ -I/opt/devkitpro/libnds/include
LDFLAGS     := -specs=ds_arm9.specs -L/opt/devkitpro/libnds/lib

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@echo "--- Creazione del file .nds finale ---"
	/opt/devkitpro/tools/bin/ndstool -c $@ -9 $<

$(TARGET).elf: $(SOURCES)/main.c
	@echo "--- Compilazione in corso ---"
	@mkdir -p $(BUILD)
	# Compiliamo il file oggetto inserendo la costante di sistema __NDS__ richiesto dai nuovi header
	/opt/devkitpro/devkitARM/bin/arm-none-eabi-gcc $(CFLAGS) -c $< -o $(BUILD)/main.o
	# Uniamo il file applicando le specifiche hardware del DS
	/opt/devkitpro/devkitARM/bin/arm-none-eabi-gcc $(LDFLAGS) $(BUILD)/main.o -lnds9 -o $@

clean:
	@echo "Pulizia file temporanei..."
	@rm -rf $(BUILD) *.elf *.nds
