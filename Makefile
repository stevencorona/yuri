#!make

CC ?= clang
MAKE = make -s

SRC_DIRS ?= ./src
export BUILD_DIR = ./build
export BINDIR = ./bin

PKG_CONFIG ?= pkg-config

CFLAGS ?= -pipe -Wall -Werror=implicit-function-declaration -Werror=unused-variable
CFLAGS += -std=gnu17
CFLAGS += -g3 -DDEBUG
CFLAGS += -fno-stack-protector
CFLAGS += -DFD_SETSIZE=1024
CFLAGS += -I../common
CFLAGS += $(shell ${PKG_CONFIG} --cflags mysqlclient)
CFLAGS += $(shell ${PKG_CONFIG} --cflags zlib)
CFLAGS += $(shell ${PKG_CONFIG} --cflags lua5.1)

LIBS := $(shell ${PKG_CONFIG} --libs mysqlclient)
LIBS += $(shell ${PKG_CONFIG} --libs zlib)
LIBS += $(shell ${PKG_CONFIG} --libs lua5.1)
LIBS += -lm -ldl -lcrypt -pthread

COMMON_OBJ = ../common/core.o ../common/session.o ../common/timer.o ../common/net_crypt.o ../common/db.o  ../common/db_mysql.o ../common/md5calc.o ../common/ers.o ../common/strlib.o ../common/showmsg.o ../common/rndm.o
COMMON_H = ../common/core.h ../common/session.h ../common/timer.h ../common/net_crypt.h ../common/db.h ../common/mmo.h ../common/malloc.h ../common/db_mysql.h ../common/md5calc.h ../common/ers.h ../common/strlib.h ../common/showmsg.h ../common/rndm.h

MKDEF = CC="$(CC)" CFLAGS="$(CFLAGS)" CLIBS="$(LIBS)" COMMON_OBJ="$(COMMON_OBJ)" COMMON_H="$(COMMON_H)"
METADEF = CC="$(CC)" CFLAGS="$(CFLAGS)" CLIBS="$(LIBS)" COMMON_OBJ="../common/db.o ../common/db_mysql.o ../common/timer.o ../common/strlib.o ../common/showmsg.o ../common/ers.o ../common/md5calc.o" COMMON_H="../common/db.h ../common/malloc.h ../common/db_mysql.h ../common/timer.h ../common/md5calc.h"

all: title common login char map metan decrypt

title:
	@echo "Hyul [Make]"
	@echo "-----------"

common:
	@echo "Common:"
	@$(MAKE) $(MKDEF) -C src/common/

login: common
	@echo "Login Server:"
	@$(MAKE) $(MKDEF) -C src/login/ clean
	@$(MAKE) $(MKDEF) -C src/login/

char: common
	@echo "Char Server:"
	@$(MAKE) $(MKDEF) -C src/char/ clean
	@$(MAKE) $(MKDEF) -C src/char/

map: common
	@echo "Map Server:"
	@$(MAKE) $(MKDEF) -C src/map/ clean
	@$(MAKE) $(MKDEF) -C src/map/

metan: common
	@echo "Meta Creator:"
	@$(MAKE) $(METADEF) -C src/metan/ clean
	@$(MAKE) $(METADEF) -C src/metan/

decrypt: common
	@echo "Decrypt Packet Tool: "
	@$(MAKE) $(METADEF) -C src/decrypt/ clean
	@$(MAKE) $(METADEF) -C src/decrypt/

clean:
	@$(MAKE) $(MKDEF) $@ -C src/common/
	@$(MAKE) $(MKDEF) $@ -C src/login/
	@$(MAKE) $(MKDEF) $@ -C src/char/
	@$(MAKE) $(MKDEF) $@ -C src/map/
	@$(MAKE) $(MKDEF) $@ -C src/metan/
	@$(MAKE) $(MKDEF) $@ -C src/decrypt/
