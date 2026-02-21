#!make

# Rust-based build system
all:
	@echo "Building all servers..."
	@cargo build --workspace

char_server:
	@echo "Building char_server..."
	@cargo build --bin char_server

login_server:
	@echo "Building login_server..."
	@cargo build --bin login_server

map_server:
	@echo "Building map_server..."
	@cargo build --bin map_server

cli:
	@echo "Building CLI tools..."
	@cargo build -p cli

test: all
	@echo "All servers built successfully!"

clean:
	@cargo clean

release:
	@echo "Building release versions..."
	@cargo build --release --workspace

.PHONY: all char_server login_server map_server cli test clean release
