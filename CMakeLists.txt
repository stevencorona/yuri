cmake_minimum_required(VERSION 2.8)

project(yuri)

set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR})

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu17 -pipe -Wall -Werror=implicit-function-declaration -Werror=unused-variable -Werror=return-type")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g3 -DDEBUG -DFD_SETSIZE=1024")

# Currently has to be build with stack protecter turned off because of numerous buffer overflows.
# Eventually disable this
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-stack-protector")

find_package(ZLIB)
find_package(Lua51 REQUIRED)

include_directories(${LUA_INCLUDE_DIR})

include_directories("${PROJECT_SOURCE_DIR}/c_deps")
include_directories("${PROJECT_SOURCE_DIR}/c_src")
include_directories(${PROJECT_SOURCE_DIR}/c_src/common)
add_subdirectory("${PROJECT_SOURCE_DIR}/c_src/common")
add_subdirectory("${PROJECT_SOURCE_DIR}/c_deps")

add_executable(char-server c_src/char/char_db.c c_src/char/char.c c_src/char/logif.c c_src/char/mapif.c)
target_link_libraries(char-server PUBLIC common)
target_link_libraries(char-server PUBLIC deps)
target_link_libraries(char-server ZLIB::ZLIB)

add_executable(login-server c_src/login/clif.c c_src/login/intif.c c_src/login/login.c)
target_link_libraries(login-server PUBLIC common)
target_link_libraries(login-server PUBLIC deps)
target_link_libraries(login-server ZLIB::ZLIB)

add_executable(map-server c_src/map/board_db.c c_src/map/clan_db.c c_src/map/class_db.c c_src/map/clif.c c_src/map/command.c c_src/map/creation.c c_src/map/intif.c c_src/map/itemdb.c c_src/map/magic.c c_src/map/map.c c_src/map/mob.c c_src/map/npc.c c_src/map/pc.c c_src/map/recipedb.c c_src/map/sl.c)
target_link_libraries(map-server PUBLIC common)
target_link_libraries(map-server PUBLIC deps)
target_link_libraries(map-server ZLIB::ZLIB)
target_link_libraries(map-server lua5.1)
target_link_libraries(map-server m)

add_executable(decrypt_cli c_src/decrypt_cli.c)
target_link_libraries(decrypt_cli PUBLIC common)
target_link_libraries(decrypt_cli PUBLIC deps)

add_executable(metan_cli c_src/metan_cli.c c_src/map/itemdb.c c_src/map/class_db.c)
target_link_libraries(metan_cli PUBLIC common)
target_link_libraries(metan_cli PUBLIC deps)

