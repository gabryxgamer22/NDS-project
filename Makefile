.SUFFIXES:

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

TARGET		:=	$(notdir $(CURDIR))
BUILD		:=	build
SOURCES		:=	source
INCLUDES	:=	include

CFLAGS	:=	-g -Wall -O2\
			-march=armv5te -mtune=arm946e-s -fomit-frame-pointer\
			-ffast-math \
			$(ARCH)

CFLAGS	+=	-DARM9
CXXFLAGS	:= $(CFLAGS) -fno-rtti -fno-exceptions

LDFLAGS	=	-g $(ARCH) -mthumb -mthumb-interwork

LIBS	:=	-lnds9

LIBDIRS	:=	$(LIBNDS)

export COMPILING_ARM9	:=	1

.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@ndstool -c $@ -9 $<

$(TARGET).elf: $(SOURCES)/main.c
	@mkdir -p $(BUILD)
	@$(CC) $(CFLAGS) $(INCLUDES) -I$(LIBNDS)/include -c $< -o $(BUILD)/main.o
	@$(CC) $(LDFLAGS) -specs=ds_arm9.specs $(BUILD)/main.o -L$(LIBNDS)/lib $(LIBS) -o $@

clean:
	@rm -fr $(BUILD) *.elf *.nds
