
%.o: %.c
	@echo -e " Compile... $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

all: core.o session.o timer.o db.o net_crypt.o db_mysql.o md5calc.o ers.o showmsg.o strlib.o rndm.o
core.o: core.c core.h
session.o: session.c session.h malloc.h
timer.o: timer.c timer.h malloc.h
db.o: db.c db.h malloc.h
net_crypt.o: net_crypt.c net_crypt.h
db_mysql.o: db_mysql.c db_mysql.h malloc.h timer.h
md5calc.o: md5calc.c md5calc.h
ers.o: ers.c ers.h
showmsg.o: showmsg.c showmsg.h
strlib.o: strlib.c strlib.h
rndm.o: rndm.c rndm.h
clean:
	@rm -f *.o
