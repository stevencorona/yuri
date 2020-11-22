# Yuri MMORPG Server

## Project Goals

Provide a clean fork/drop-in replacement of the Mithia server that is 100% compatible with existing LUA files and database. Slowly improve the codebase from spaghetti C to C11 to Rust.

## TODO
[x] Remove bundled zlib
[x] Fix pointer to int casts for 64-bit support
[x] Compile with Clang
[] clang-fmt/clang-modernize codebase
[] Remove dead code
[] Use OpenSSL MD5
[] Switch to LuaJIT
[] Include sql migrations
[] Fix SQL autoincrement / numbering issues
[] Compile with -O3 without segfaulting
[] Switch to CMake
[] Smoke Tests
[] Automated CI
[] Address header file spaghetti
[] Address all clang warnings
