#pragma once

#include "map.h"

struct creation_data {
  int id;
  int count;
  int amount;
  int item[10];
  int item_count[10];
  int item_created;
};

extern struct DBMap *create_db;

int createdb_init();
int createdb_start(USER *);
int createdb_term();