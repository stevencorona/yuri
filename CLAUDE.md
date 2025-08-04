# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

### Full Build
```bash
make all
```

### Individual Components
- `make libyuri` - Build Rust library (required for C builds)
- `make char_server` - Build character server
- `make login_server` - Build login server  
- `make map_server` - Build map server
- `make metan_cli` - Build metan CLI tool
- `make decrypt_cli` - Build decrypt CLI tool

### Clean Build
```bash
make clean        # Clean build artifacts
make clean-crate  # Clean Rust/cargo artifacts
```

### Regenerate FFI Header
```bash
cargo install cbindgen  # One-time setup
make yuri.h            # Regenerate c_deps/yuri.h
```

## Architecture Overview

Yuri is a MMORPG server emulator with three main components:

1. **Login Server** (`login_server`) - Handles authentication and character creation
2. **Character Server** (`char_server`) - Manages character state and global features (boards, etc)
3. **Map Server** (`map_server`) - Runs the game world, can run multiple instances for load distribution

### Communication
- Servers communicate via TCP using a custom binary protocol (see PROTOCOL.md)
- Client-server protocol is similar to inter-server protocol
- All use custom encryption (see `net_crypt.c/h`)

### Technology Stack
- **C** (C11/C17) - Core server implementation
- **Rust** - Gradual migration target, currently provides utility functions
- **LuaJIT** - Game logic scripting (2-20x faster than standard Lua)
- **MySQL** - Game state persistence
- **CMake** - C build system
- **Cargo** - Rust build system

### Key Directories
- `c_src/` - C source files
- `src/` - Rust source files
- `data/lua/` - Lua scripts for game logic
- `data/maps/` - Game map files (.map format)
- `conf/` - Server configuration (server.yaml)

### Important C Files
- `map_server.c` - Main map server entry point
- `map_parse.c` - Client packet parsing for map server
- `scripting.c` - LuaJIT integration
- `net_crypt.c/h` - Network encryption implementation
- `session.c` - Session management
- `mmo.h` - Core game structures

## Development Notes

### Current State
- No linting configured for C code yet
- No automated tests yet
- Compiles with warnings disabled for stack protection (legacy buffer overflow issues)
- Single-threaded architecture (performance bottleneck)

### Security Considerations
- This codebase handles network protocols and game logic
- Focus on defensive programming when modifying network code
- Never store plaintext passwords (BCrypt migration planned)
- Validate all client input