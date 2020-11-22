#pragma once

#include <lua.h>
#include "mmo.h"

int is_command(USER*,const char*,int);
int at_command(USER*,const char*,int);
int command_reload(USER *, char *, lua_State *);