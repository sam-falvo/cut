CLEAN		:= $D/clean
INSTALL		:= $D/install


CUT_H		:= $(INCPATH)/cut/2.6/cut.h

MODULES		:= $D/cut
SRCS		:= $(MODULES:%=%.c)
OBJS		:= $(MODULES:%=%.o)
LIBNAME		:= libcut.a
LIB			:= $D/$(LIBNAME)

AR			:= ar
AROPTS		:= r $(LIB)


$(LIB): $(OBJS)
	$(AR) $(AROPTS) $(OBJS)


ALL_LIBS += $(LIB)


.PHONY: $(CLEAN)

$(CLEAN):
	$(DELETE) $(OBJS) $(LIB)

ALL_CLEAN += $(CLEAN)


.PHONY: $(INSTALL)

$(INSTALL):
	$(MKDIR) $(LIBPATH)
	$(COPY) $(LIB) $(LIBPATH)/$(LIBNAME)

ALL_INSTALLS += $(INSTALL)

