#!make

# Rust-based build system
all: libyuri char_server login_server map_server

libyuri:
	@echo "Building yuri library..."
	@cargo build -p yuri

yuri.h:
	@cbindgen --config cbindgen.toml --crate yuri --output ./c_deps/yuri.h --lang c

char_server: libyuri
	@echo "Building char_server..."
	@cargo build --bin char_server

login_server: libyuri
	@echo "Building login_server..."
	@cargo build --bin login_server

map_server: libyuri
	@echo "Building map_server..."
	@cargo build --bin map_server

# CLI tools still use CMake for now
metan_cli:
	@cmake -H. -Bbuild
	@cmake --build build --target metan_cli --parallel --

decrypt_cli:
	@cmake -H. -Bbuild
	@cmake --build build --target decrypt_cli --parallel --

test: all
	@echo "All servers built successfully!"

clean:
	@cargo clean
	@rm -rf ./build

release: libyuri
	@echo "Building release versions..."
	@cargo build --release --workspace

.PHONY: all libyuri char_server login_server map_server metan_cli decrypt_cli test clean release