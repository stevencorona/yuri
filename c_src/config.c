#include "config.h"

struct point start_pos;

int char_port = 2005;

char char_id[32] = "";
char char_pw[32] = "";

char login_id[32] = "";
char login_pw[32] = "";

int login_ip;
int login_port = 2010;

int require_reg = 1;
int nex_version;
int nex_deep;
char meta_file[META_MAX][256];

unsigned int map_ip;
unsigned int map_port;

int serverid;
int save_time = 60000;
int xp_rate;
int d_rate;
struct town_data towns[255];

char sql_id[32] = "";
char sql_pw[32] = "";
char sql_db[32] = "";
char sql_ip[32] = "";
int sql_port = 3306;

char *data_dir = "./data/";
char *lua_dir = "./data/lua/";
char *maps_dir = "./data/maps/";
char *meta_dir = "./data/meta/";