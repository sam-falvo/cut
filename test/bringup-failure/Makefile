.phony: help
help:
	@echo "Use: make check1 PREFIX=<installation dir>"
	@echo " or: make check2 PREFIX=<installation dir>"
	@echo " or: make clean"

.c.o:
	gcc -g -I$(PREFIX)/include -c -o $@ $<

check1: cutcheck1.c
	gcc -g -I$(PREFIX)/include -L$(PREFIX)/lib cutcheck1.c cut-explode1.o -o cutcheck -lcut
	./cutcheck

check2: cutcheck2.c
	gcc -g -I$(PREFIX)/include -L$(PREFIX)/lib cutcheck2.c cut-explode2.o -o cutcheck -lcut
	./cutcheck

cutcheck1.c: cut-explode1.o
	$(PREFIX)/bin/cutgen cut-explode1.c -o cutcheck1.c

cutcheck2.c: cut-explode2.o
	$(PREFIX)/bin/cutgen cut-explode2.c -o cutcheck2.c

clean:
	rm -f *.o *~ cutcheck*

