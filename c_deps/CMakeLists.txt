find_package(PkgConfig)
pkg_check_modules(MySQL REQUIRED mysqlclient>=5.7)

include_directories(PUBLIC ${MySQL_INCLUDE_DIRS})

add_library(deps STATIC db_mysql.c db.c ers.c md5calc.c rndm.c showmsg.c strlib.c timer.c)
target_link_libraries(deps PUBLIC mysqlclient)
