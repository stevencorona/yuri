#!make

CC ?= clang
MAKE = make -s

all: clean libyuri cmake metan_cli decrypt_cli char_server login_server map_server
libyuri:
	@echo "libyuri:"
	@cargo build --lib
yuri.h:
	@cbindgen --config cbindgen.toml --crate yuri --output ./c_deps/yuri.h --lang c
cmake:
	@cmake -H. -Bbuild
common: deps
	@cmake --build build --target common --
deps: cmake libyuri
	@cmake --build build --target deps --
metan_cli: common
	@cmake --build build --target metan_cli --
decrypt_cli: common 
	@cmake --build build --target decrypt_cli --
char_server: common
	@cmake --build build --target char_server --
login_server: common
	@cmake --build build --target login_server --
map_server: common
	@cmake --build build --target map_server --
clean:
	@rm -rf ./bin/*
	@rm -rf ./build
clean-crate:
	@cargo clean