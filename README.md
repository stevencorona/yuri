# Yuri MMORPG Server

## Project Goals

Provide a clean fork/drop-in replacement of the Mithia server that is 100% compatible with existing LUA files and database. Slowly improve the codebase from spaghetti C to C11 to Rust.

## TODO
- [x] Remove bundled zlib
- [x] Fix pointer to int casts for 64-bit support
- [x] Compile with Clang
- [x] clang-fmt/clang-modernize codebase
- [ ] Remove dead code
- [ ] BCrypt Passwords
- [ ] Flatten source directory
- [x] Clean up and document configs
- [ ] Receive mysql / net config as cli flag and env
- [ ] Produce a single server binary instead of 3x
- [ ] All logging to STDOUT
- [ ] Use OpenSSL MD5
- [ ] Fix SQL autoincrement / numbering issues
- [ ] Compile with -O3 without segfaulting
- [ ] Compile without stack smashing off
- [ ] Address all clang warnings
- [ ] Switch to LuaJIT
- [ ] Smoke Tests
- [ ] Automated CI
- [ ] Include SQL Migration & Minimum amount of LUA to run server

## Non Goals

- Will not accept any C++ code. The end goal is to port the C to Rust, and using C++ significantly complicates calling between the two languages
- Must be able to run Mithia lua code out of the box. New lua interfaces may be added, but must retain backwards compatability
- No copyrighted material - including client, game maps, or storyline. This is not a game, just a server emulator
