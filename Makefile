BUILD		?= ./build
VERSION		?= 2.6
INCPATH		?= $(BUILD)/include/cut/$(VERSION)
REFIX		?= .


help:
	@echo "To build CUT $(VERSION):"
	@echo ""
	@echo "make clean                   -- cleans the directory of all build artifacts."
	@echo "make install PREFIX=/abc/def -- installs CUT binaries and library into /abc/def."
	@echo ""


clean:
	rm -f *.o *.a *.pyc
	rm -rf $(BUILD)


cut.o: cut.c cut.h
	$(CC) -c -o cut.o cut.c


libcut.a: cut.o
	ar r libcut.a cut.o


build: libcut.a
	rm -rf $(BUILD)
	mkdir -p $(BUILD)/bin
	mkdir -p $(BUILD)/lib
	mkdir -p $(INCPATH)
	cp *.py $(BUILD)/bin
	chmod a+x $(BUILD)/bin/cutgen.py
	cp libcut.a $(BUILD)/lib
	cp cut.h $(INCPATH)

install: build
	mkdir -p $(PREFIX)
	cp -r $(BUILD)/* $(PREFIX)

