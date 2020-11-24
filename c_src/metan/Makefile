
%.o: %.c
	@echo -e " Compile... $<"
	@$(CC) $(CFLAGS) -c -o $@ $<

all: metan

metan: metan.o ../map/itemdb.o ../map/class_db.o $(COMMON_OBJ)
	@echo -e " Linking... $<"
	@$(CC) -o ../../$(BINDIR)/$@ metan.o ../map/itemdb.o ../map/class_db.o $(COMMON_OBJ) $(CLIBS)

metan.o: metan.c metan.h $(COMMON_H)
../map/itemdb.o: ../map/itemdb.c ../map/itemdb.h $(COMMON_H)
../map/class_db.o: ../map/class_db.c ../map/class_db.h $(COMMON_H)
clean:
	@rm -f *.o ../../$(BINDIR)/metan

