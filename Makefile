#---------------------------------------------------------------------------------
# Nome della ROM finale (senza estensione)
#---------------------------------------------------------------------------------
TARGET		:=	IlMioGiocoNDS

#---------------------------------------------------------------------------------
# Cartelle del progetto
#---------------------------------------------------------------------------------
BUILD		:=	build
SOURCES		:=	source
INCLUDES	:=	include
DATA		:=	data
GRAPHICS	:=	graphics

#---------------------------------------------------------------------------------
# Controllo ambiente devkitARM
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

# Include le regole ufficiali per Nintendo DS
include $(DEVKITARM)/ds_rules

#---------------------------------------------------------------------------------
# Opzioni del compilatore per ARM9 (Nintendo DS)
#---------------------------------------------------------------------------------
ARCH	:=	-mthumb -mthumb-interwork

CFLAGS	:=	-g -Wall -O2\
			-march=armv5te -mtune=arm946e-s -fomit-frame-pointer\
			-ffast-math \
			$(ARCH)

CFLAGS	+=	-DARM9
CXXFLAGS	:= $(CFLAGS) -fno-rtti -fno-exceptions

LDFLAGS	=	-g $(ARCH) -mthumb -mthumb-interwork

# Collegamento alle librerie standard (libnds9)
LIBS	:=	-lnds9
LIBDIRS	:=	$(LIBNDS)

#---------------------------------------------------------------------------------
# Direttive per i file sorgenti
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(CURDIR))

export OUTPUT	:=	$(CURDIR)/$(TARGET)
export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir))
export DEPSDIR	:=	$(CURDIR)/$(BUILD)

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))

export OFILES	:=	$(CFILES:.c=.o) $(CPPFILES:.cpp=.o) $(SFILES:.s=.o)
export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
					$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
					-I$(CURDIR)/$(BUILD)

.PHONY: $(BUILD) clean all

all: $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $@ -f $(CURDIR)/Makefile

clean:
	@echo pulizia progetto ...
	@rm -fr $(BUILD) *.elf *.nds

else

#---------------------------------------------------------------------------------
# Regole di compilazione effettive
#---------------------------------------------------------------------------------
DEPENDS	:=	$(OFILES:.o=.d)

$(OUTPUT).nds: $(OUTPUT).elf

$(OUTPUT).elf: $(OFILES)

%.o: %.c
	@echo  $(notdir $<)
	$(CC) -MMD -MP -MF $(DEPSDIR)/$*.d $(CFLAGS) $(INCLUDE) -c $< -o $@

%.o: %.cpp
	@echo  $(notdir $<)
	$(CXX) -MMD -MP -MF $(DEPSDIR)/$*.d $(CXXFLAGS) $(INCLUDE) -c $< -o $@

-include $(DEPENDS)

endif
