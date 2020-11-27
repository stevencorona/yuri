#!make

CC ?= clang
MAKE = make -s

all: clean libyuri cmake deps common metan_cli decrypt_cli char_server login_server map_server
libyuri:
	@echo "libyuri:"
	@cargo build --lib
yuri.h:
	@cbindgen --config cbindgen.toml --crate yuri --output ./c_deps/yuri.h --lang c
cmake:
	@cmake -H. -Bbuild
common:
	@cmake --build build --target common --
deps:
	@cmake --build build --target deps --
metan_cli:
	@cmake --build build --target metan_cli --
decrypt_cli:
	@cmake --build build --target decrypt_cli --
char_server:
	@cmake --build build --target char_server --
login_server:
	@cmake --build build --target login_server --
map_server:
	@cmake --build build --target map_server --
clean:
	@rm -rf ./bin/*
	@rm -rf ./build
clean-crate:
	@cargo clean