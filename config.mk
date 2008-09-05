CC			:= gcc
CCFLAGS 	:= -O2 -fomit-frame-pointer
LD			:= gcc
LDFLAGS 	:=
HC			:= ghc
HCFLAGS 	:= -ibin

# PREFIX	:= /Programs/OpenAX.25/0.0
BINPATH		:= $(PREFIX)/bin
SBINPATH	:= $(PREFIX)/sbin
LIBPATH		:= $(PREFIX)/lib
INCPATH		:= $(PREFIX)/include

DELETE		:= rm -rf
COPY		:= cp
MKDIR		:= mkdir -p

