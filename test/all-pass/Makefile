check: cutcheck.c cut-pass.o
	gcc -g -I$(PREFIX)/include -L$(PREFIX)/lib cutcheck.c cut-pass.o -o cutcheck  -lcut
	./cutcheck

cutcheck.c: cut-pass.o
	$(PREFIX)/bin/cutgen cut-*.c -o cutcheck.c

cut-pass.o: cut-pass.c
	gcc -g -I$(PREFIX)/include -c cut-pass.c

clean:
	rm -f *.o *~ cutcheck*

