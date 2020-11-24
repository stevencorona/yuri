// Centralized global configuration and variables used across the entire
// application Globals are not thread-safe

#include "mmo.h"

// Maximum number of meta files
#define META_MAX 20

extern struct point start_pos;

extern char login_id[];
extern char login_pw[];

extern int login_ip;
extern int login_port;

extern int require_reg;
extern int nex_version;
extern int nex_deep;
extern char meta_file[META_MAX][256];

extern int char_port;

extern char char_id[];
extern char char_pw[];

extern unsigned int map_ip;
extern unsigned int map_port;

extern int serverid;
extern int save_time;
extern int xp_rate;
extern int d_rate;

struct town_data {
  char name[32];
};

extern struct town_data towns[];

extern char sql_id[];
extern char sql_pw[];
extern char sql_ip[];
extern char sql_db[];
extern int sql_port;