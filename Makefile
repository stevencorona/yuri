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
CFLAGS += -I../common -I../../c_deps
CFLAGS += $(shell ${PKG_CONFIG} --cflags mysqlclient)
CFLAGS += $(shell ${PKG_CONFIG} --cflags zlib)
CFLAGS += $(shell ${PKG_CONFIG} --cflags lua5.1)

LIBS := $(shell ${PKG_CONFIG} --libs mysqlclient)
LIBS += $(shell ${PKG_CONFIG} --libs zlib)
LIBS += $(shell ${PKG_CONFIG} --libs lua5.1)
LIBS += -lm -ldl -lcrypt -pthread

DEPS_OBJ = ../../target/debug/libyuri.a ../../c_deps/db_mysql.o ../../c_deps/db.o ../../c_deps/ers.o ../../c_deps/md5calc.o ../../c_deps/rndm.o ../../c_deps/showmsg.o ../../c_deps/strlib.o ../../c_deps/timer.o
COMMON_OBJ = ../common/core.o ../common/session.o ../common/net_crypt.o $(DEPS_OBJ)
COMMON_H = ../common/core.h ../common/session.h ../common/net_crypt.h ../common/mmo.h

MKDEF = CC="$(CC)" CFLAGS="$(CFLAGS)" CLIBS="$(LIBS)" COMMON_OBJ="$(COMMON_OBJ)" COMMON_H="$(COMMON_H)"
METADEF = CC="$(CC)" CFLAGS="$(CFLAGS)" CLIBS="$(LIBS)" COMMON_OBJ="$(DEPS_OBJ)" COMMON_H="$(COMMON_H)"

all: title libyuri common login char map metan decrypt

title:
	@echo "Hyul [Make]"
	@echo "-----------"

libyuri:
	@echo "libyuri:"
	@cargo build --lib

yuri.h:
	@cbindgen --config cbindgen.toml --crate yuri --output ./c_deps/yuri.h --lang c

common: libyuri
	@echo "Common:"
	@$(MAKE) $(MKDEF) -C c_deps/
	@$(MAKE) $(MKDEF) -C c_src/common/

login: common
	@echo "Login Server:"
	@$(MAKE) $(MKDEF) -C c_src/login/ clean
	@$(MAKE) $(MKDEF) -C c_src/login/

char: common
	@echo "Char Server:"
	@$(MAKE) $(MKDEF) -C c_src/char/ clean
	@$(MAKE) $(MKDEF) -C c_src/char/

map: common
	@echo "Map Server:"
	@$(MAKE) $(MKDEF) -C c_src/map/ clean
	@$(MAKE) $(MKDEF) -C c_src/map/

metan: common
	@echo "Meta Creator:"
	@$(MAKE) $(METADEF) -C c_src/metan/ clean
	@$(MAKE) $(METADEF) -C c_src/metan/

decrypt: common
	@echo "Decrypt Packet Tool: "
	@$(MAKE) $(METADEF) -C c_src/decrypt/ clean
	@$(MAKE) $(METADEF) -C c_src/decrypt/

clean:
	@cargo clean
	@$(MAKE) $(MKDEF) $@ -C c_src/common/
	@$(MAKE) $(MKDEF) $@ -C c_src/login/
	@$(MAKE) $(MKDEF) $@ -C c_src/char/
	@$(MAKE) $(MKDEF) $@ -C c_src/map/
	@$(MAKE) $(MKDEF) $@ -C c_src/metan/
	@$(MAKE) $(MKDEF) $@ -C c_src/decrypt/
