INSTALL		:= $D/install

MODULES		:= $D/common.py  \
               $D/cutgen.py  \
               $D/lexer.py   \
               $D/options.py \
               $D/parser.py


.PHONY: $(INSTALL)

$(INSTALL):
	$(MKDIR) $(BINPATH)
	$(COPY) $(MODULES) $(BINPATH)

ALL_INSTALLS += $(INSTALL)

