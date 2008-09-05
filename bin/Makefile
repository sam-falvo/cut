CLEAN		:=	$D/clean
CUTGEN_NAME	:=	cutgen
CUTGEN		:=	$D/$(CUTGEN_NAME)
INSTALL		:=	$D/install


MAIN		:=	$D/Main
MODULES		:=	$D/CutEmit		\
				$D/CutLexer		\
				$D/CutOptions	\
				$D/CutParser
SRCS		:=	$(MODULES:%=%.hs)
OBJS		:=	$(MODULES:%=%.o)
HIS			:=	$(MODULES:%=%.hi)


$(CUTGEN): $(SRCS)
	$(HC) -ibin --make -o $(CUTGEN) $(MAIN:%=%.hs)

ALL_BINS += $(CUTGEN)


.PHONY: $(CLEAN)
$(CLEAN):
	$(DELETE) $(CUTGEN) $(OBJS) $(HIS) $(MAIN:%=%.o) $(MAIN:%=%.hi)

ALL_CLEAN += $(CLEAN)


.PHONY: $(INSTALL)
$(INSTALL):
	$(MKDIR) $(BINPATH)
	$(COPY) $(CUTGEN) $(BINPATH)/$(CUTGEN_NAME)

ALL_INSTALLS += $(INSTALL)

