#pragma once

#include "mmo.h"

struct char_login_data {
  char name[16];
  int map_server;
};

struct map_fifo_data {
  int fd;
  unsigned int ip, port;
  unsigned short map[MAX_MAP_PER_SERVER];
  unsigned int map_n;
};

extern struct mmo_charstatus *char_dat;
extern struct char_login_data *clogin_dat;
extern struct map_fifo_data map_fifo[];

extern int map_fifo_max;
extern int map_fifo_n;

extern int login_fd;
extern int char_fd;

extern struct Sql *sql_handle;

// int logindata_del(unsigned int);
int logindata_change(unsigned int, int);
struct char_login_data *logindata_search(unsigned int);

int mapfifo_from_mapid(int);

int config_read(const char *);

void do_term(void);