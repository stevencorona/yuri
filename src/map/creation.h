#pragma once

#include "map.h"

#define CREATEDB_FILE "db/createdb.txt"

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