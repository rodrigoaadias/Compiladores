# Makefile for C-Minus compiler

CC = gcc
BISON = bison
LEX = flex

BIN = compiler

OBJS = Cminus.tab.o lex.yy.o main.o util.o

$(BIN): $(OBJS)
	$(CC) $(OBJS) -o $(BIN)

main.o: main.c globals.h util.h scan.h analyze.h
	$(CC) -c main.c

util.o: util.c util.h globals.h
	$(CC) -c util.c

lex.yy.o: cminus.l scan.h util.h globals.h
	$(LEX) -o lex.yy.c lex/Cminus.l
	$(CC) -c lex.yy.c

cminus.tab.o: Cminus.y globals.h
	$(BISON) -d yacc/Cminus.y
	$(CC) -c Cminus.tab.c

clean:
	-rm -f $(BIN)
	-rm -f Cminus.tab.c
	-rm -f Cminus.tab.h
	-rm -f lex.yy.c
	-rm -f $(OBJS)
