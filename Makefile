BUILD	?= ./build
VERSION	?= 2.6


clean:
	rm -f *.o *.a *.pyc


cut.o: cut.c cut.h
	$(CC) -c -o cut.o cut.c


libcut.a: cut.o
	ar r libcut.a cut.o


build: libcut.a
	rm -rf $(BUILD)
	mkdir -p $(BUILD)/bin
	mkdir -p $(BUILD)/lib
	mkdir -p $(BUILD)/include/$(VERSION)
	cp *.py $(BUILD)/bin
	cp libcut.a $(BUILD)/lib
	cp cut.h $(BUILD)/include/$(VERSION)

