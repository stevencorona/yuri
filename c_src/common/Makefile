
%.o: %.c
	@echo -e " Compile... $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

all: config.o core.o session.o net_crypt.o
config.o: config.c config.h
core.o: core.c core.h
session.o: session.c session.h core.h
net_crypt.o: net_crypt.c net_crypt.h
clean:
	@rm -f *.o
