check: cutcheck.c
	gcc -I$(PREFIX)/include -L$(PREFIX)/lib cutcheck.c cut-explode.o -o cutcheck -lcut
	./cutcheck

cutcheck.c: cut-explode.o
	$(PREFIX)/bin/cutgen cut-*.c -o cutcheck.c

cut-explode.o: cut-explode.c
	gcc -I$(PREFIX)/include -c cut-explode.c

clean:
	rm -f *.o *~ cutcheck*

