#---------------------------------------------------------------------------------
# CLEAR VARIABLES
#---------------------------------------------------------------------------------
.SUFFIXES:

#---------------------------------------------------------------------------------
# CHECK DEVKITARM
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

#---------------------------------------------------------------------------------
# TARGET CONFIGURATION
#---------------------------------------------------------------------------------
TARGET		:=	NDS_Project
BUILD		:=	build
SOURCES		:=	source
INCLUDES	:=	include

#---------------------------------------------------------------------------------
# FLAGS
#---------------------------------------------------------------------------------
ARCH	:=	-mthumb -mthumb-interwork

CFLAGS	:=	-g -Wall -O2\
			-march=armv5te -mtune=arm946e-s -fomit-frame-pointer\
			-ffast-math \
			$(ARCH) -DARM9

CXXFLAGS	:= $(CFLAGS) -fno-rtti -fno-exceptions

LDFLAGS	=	-g $(ARCH) -mthumb -mthumb-interwork

LIBS	:=	-lnds9
LIBDIRS	:=	$(LIBNDS)

#---------------------------------------------------------------------------------
# RULES
#---------------------------------------------------------------------------------
.PHONY: all clean

all: $(TARGET).nds

$(TARGET).nds: $(TARGET).elf
	@ndstool -c $@ -9 $<

$(TARGET).elf: $(SOURCES)/main.c
	@mkdir -p $(BUILD)
	@$(CC) $(CFLAGS) -I$(LIBNDS)/include -c $< -o $(BUILD)/main.o
	@$(CC) $(LDFLAGS) -specs=ds_arm9.specs $(BUILD)/main.o -L$(LIBNDS)/lib $(LIBS) -o $@

clean:
	@rm -fr $(BUILD) *.elf *.nds
