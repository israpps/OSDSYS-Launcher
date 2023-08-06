EE_BIN = sd2psx_bl.ELF
EE_BIN_PACKED = sd2psx_bl-packed.ELF
EE_BIN_STRIPPED = sd2psx_bl-stripped.ELF
EE_BIN_ENCRYPTED = SYSTEM.XLF
EE_OBJS = sd2psx_bl.o 
EE_LIBS = -ldebug -lpatches -lmc
NEWLIB_NANO = 1

PSX ?= 0

ifeq ($(PSX), 1)
  EE_CFLAGS += -DPSX
  EE_BIN_ENCRYPTED = XSYSTEM.XLF
endif

all:
	$(MAKE) $(EE_BIN_PACKED)

clean:
	rm -fr *.ELF *.o *.bak

$(EE_BIN_STRIPPED): $(EE_BIN)
	$(EE_STRIP) -o $@ $<
	
$(EE_BIN_PACKED): $(EE_BIN_STRIPPED)
ifeq ($(USE_LOCAL_PACKER),1)
	ps2-packer/ps2-packer -v $< $@
else
	ps2-packer $< $@
endif

$(EE_BIN_ENCRYPTED): $(EE_BIN_PACKED)
	thirdparty/kelftool_dnasload.exe encrypt dnasload $< $@

kelf: $(EE_BIN_ENCRYPTED)

full:
	$(MAKE) clean kelf
	$(MAKE) clean kelf PSX=1
	$(MAKE) clean

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
