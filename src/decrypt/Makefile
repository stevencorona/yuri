
%.o: %.c
	@echo -e " Compile... $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

all: decrypt

decrypt: main.o $(COMMON_OBJ)
	@echo -e " Linking... $<"
	@$(CC) -o ../../$(BINDIR)/$@ main.o $(COMMON_OBJ) $(CLIBS)

main.o: main.c $(COMMON_H)
clean:
	@rm -f *.o ../../$(BINDIR)/decrypt
