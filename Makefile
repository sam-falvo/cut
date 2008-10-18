#
# This file generally should not be changed.  If you need to make
# alterations to the configuration, you really ought to edit config.mk
# instead.
#

include config.mk
include nrmf.mk

ALL_BINS			:=
ALL_CLEAN			:=
ALL_INSTALLS		:=
ALL_LIBS			:=


$(call subdir,lib)
$(call subdir,src)
$(call subdir,include)


all: $(ALL_LIBS) $(ALL_BINS)


.c.o:
	$(CC) $(CCFLAGS) -c -o $@ $<




.PHONY: clean

clean: $(ALL_CLEAN)


.PHONY: install

install: all $(ALL_INSTALLS)
