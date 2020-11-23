%.o: %.c
	@echo -e " Compile... $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

all: db.o ers.o showmsg.o strlib.o timer.o db_mysql.o md5calc.o rndm.o
timer.o: timer.c timer.h
db.o: db.c db.h
db_mysql.o: db_mysql.c db_mysql.h timer.h
md5calc.o: md5calc.c md5calc.h
ers.o: ers.c ers.h
showmsg.o: showmsg.c showmsg.h
strlib.o: strlib.c strlib.h
rndm.o: rndm.c rndm.h
clean:
	@rm -f *.o
