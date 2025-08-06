Your environment:
  - You run in an environment where `ast-grep` is available; whenever a search requires syntax-aware or structural matching, default to `ast-grep run -p '<pattern>'` (set `--lang` appropriately if necessary) and avoid falling back to text-only tools like `rg` or `grep` unless ast-grep fails or I  explicitly request a plain text seach.
  - You can get help with specific `ast-grep` syntax here: https://ast-grep.github.io/llms.txt

  - ALWAYS prefer your default tools over resorting to the Bash tool. You historically have a bad habit of doing find ... | xargs ... grep where you could just use your Grep tool. Avoid this! Just use the simple Grep tool.

Rules for using the Grep tool:
  - You run in an environment with ripgrep (`rg`) is available; it is much faster and should be preferred over `grep`
  - NEVER assume something exists with too specific a pattern. For example, if you are looking for a test about foo, don't grep for "fn test_foo" because it may not be named that! Think broader and more general.
  - ALWAYS filter out the results from the **/target/debug/**, and **/.cache/**  directories which fill up with trash you don't want to search.
  - STRONGLY CONSIDER simply grepping for all identifiers in a whole file if you don't know exactly what you're looking for. Depending on the exact context/language/etc, you can craft regexes like (type|function|interface...etc) .*[{;]$ or be more or less sophisticated as needed. Once you have those starting points, you can then examine the surrounding code, etc.
  - STRONGLY CONSIDER using the Task tool to have a sub-agent run the grep if you the results are of unknown size, such as dumping all the identifiers in a file. Have it return just the relevant stuff.


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
- **Cargo** - Build system (handles both Rust and C compilation)

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
