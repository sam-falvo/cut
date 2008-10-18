PREFIX		?= .
BINPATH		:= $(PREFIX)/bin
SBINPATH	:= $(PREFIX)/sbin
LIBPATH		:= $(PREFIX)/lib
INCPATH		:= $(PREFIX)/include

CC			:= gcc
CCFLAGS 	:= -O2 -fomit-frame-pointer -I$(INCPATH)
LD			:= gcc
LDFLAGS 	:=
HC			:= ghc
HCFLAGS 	:= -ibin

DELETE		:= rm -rf
COPY		:= cp
MKDIR		:= mkdir -p

