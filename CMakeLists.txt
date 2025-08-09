cmake_minimum_required(VERSION 3.10)

project(yuri)

set(CMAKE_C_COMPILER clang)
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu17 -pipe -Wall -Werror=implicit-function-declaration -Werror=unused-variable -Werror=return-type")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g3 -DDEBUG -DFD_SETSIZE=1024")

# Currently has to be build with stack protecter turned off because of numerous buffer overflows.
# Eventually disable this
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-stack-protector")

find_package(PkgConfig REQUIRED)

# Find mysqlclient with pkg-config
pkg_check_modules(PC_MYSQL QUIET mysqlclient)

if(NOT PC_MYSQL_FOUND)
  # Fallback to mysql_config if pkg-config fails
  find_program(MYSQL_CONFIG_EXECUTABLE mysql_config
    PATHS
    /opt/homebrew/opt/mysql/bin
    /usr/local/opt/mysql/bin
    /usr/bin
    /usr/local/bin
  )

  if(MYSQL_CONFIG_EXECUTABLE)
    execute_process(COMMAND ${MYSQL_CONFIG_EXECUTABLE} --cflags OUTPUT_VARIABLE MYSQL_CFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(COMMAND ${MYSQL_CONFIG_EXECUTABLE} --libs OUTPUT_VARIABLE MYSQL_LIBS OUTPUT_STRIP_TRAILING_WHITESPACE)

    # Parse include dir
    string(REGEX MATCH "-I[^ ]+" MYSQL_INCLUDE_DIR "${MYSQL_CFLAGS}")
    string(REPLACE "-I" "" MYSQL_INCLUDE_DIR "${MYSQL_INCLUDE_DIR}")
  else()
    message(FATAL_ERROR "Cannot find MySQL")
  endif()
else()
  set(MYSQL_LIBS ${PC_MYSQL_LINK_LIBRARIES})
  set(MYSQL_INCLUDE_DIR ${PC_MYSQL_INCLUDE_DIRS})
endif()

find_package(ZLIB)
# find_package(Lua5.1)

# For LuaJIT
find_package(PkgConfig REQUIRED)
pkg_check_modules(LUAJIT REQUIRED IMPORTED_TARGET luajit)

include_directories(${LUA_INCLUDE_DIR})

include_directories("${PROJECT_SOURCE_DIR}/c_deps")
include_directories("${PROJECT_SOURCE_DIR}/c_src")
add_subdirectory("${PROJECT_SOURCE_DIR}/c_deps")

add_library(common STATIC c_src/config.c c_src/core.c c_src/net_crypt.c c_src/session.c)

add_executable(char_server c_src/char/char_db.c c_src/char/char_server.c c_src/char/char_login.c c_src/char/char_map.c)
target_link_libraries(char_server common)
target_link_libraries(char_server deps)
target_link_libraries(char_server ZLIB::ZLIB)
target_link_libraries(char_server ${PROJECT_SOURCE_DIR}/target/debug/libyuri.a)

add_executable(login_server c_src/login/login_server.c c_src/login/login_char.c c_src/login/login_parse.c)
target_link_libraries(login_server common)
target_link_libraries(login_server deps)
target_link_libraries(login_server ZLIB::ZLIB)
target_link_libraries(login_server ${PROJECT_SOURCE_DIR}/target/debug/libyuri.a)

add_executable(map_server c_src/map/board_db.c c_src/map/clan_db.c c_src/map/class_db.c c_src/map/map_char.c c_src/map/gm_command.c c_src/map/creation_db.c c_src/map/map_parse.c c_src/map/item_db.c c_src/map/magic_db.c c_src/map/map_server.c c_src/map/mob.c c_src/map/npc.c c_src/map/pc.c c_src/map/recipe_db.c c_src/map/scripting.c)
target_link_libraries(map_server common)
target_link_libraries(map_server deps)
target_link_libraries(map_server ZLIB::ZLIB)
target_link_libraries(map_server PkgConfig::LUAJIT)
target_link_libraries(map_server m)
target_link_libraries(map_server ${PROJECT_SOURCE_DIR}/target/debug/libyuri.a)

add_executable(decrypt_cli c_src/decrypt_cli.c)
target_link_libraries(decrypt_cli common)
target_link_libraries(decrypt_cli deps)
target_link_libraries(decrypt_cli ${PROJECT_SOURCE_DIR}/target/debug/libyuri.a)

add_executable(metan_cli c_src/metan_cli.c c_src/map/item_db.c c_src/map/class_db.c)
target_include_directories(metan_cli PRIVATE ${MYSQL_INCLUDE_DIR})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${MYSQL_LIBS}")

target_link_libraries(metan_cli common)
target_link_libraries(metan_cli deps)
target_link_libraries(metan_cli ${PROJECT_SOURCE_DIR}/target/debug/libyuri.a)
