#include "char_server.h"

#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zlib.h>

#include "char_db.h"
#include "char_login.h"
#include "char_map.h"
#include "config.h"
#include "core.h"
#include "db.h"
#include "mmo.h"
#include "session.h"
#include "timer.h"

struct DBMap *login_data;
struct mmo_charstatus *char_dat;
struct char_login_data *clogin_dat;
struct map_fifo_data map_fifo[MAX_MAP_SERVER];

int map_fifo_n = 0;
int map_fifo_max = 0;
struct Sql *sql_handle;
int char_fd;
int login_fd;

int zlib_init(void) {
  z_stream strm;
  int ret;
  strm.zalloc = Z_NULL;
  strm.zfree = Z_NULL;
  strm.opaque = Z_NULL;
  ret = deflateInit(&strm, Z_DEFAULT_COMPRESSION);
  return ret;
}
int mapfifo_from_mapid(int map) {
  int i, j;
  for (i = 0; i < map_fifo_max; i++) {
    if (map_fifo[i].fd > 0) {
      for (j = 0; j < map_fifo[i].map_n; j++) {
        if (map_fifo[i].map[j] == map) {
          return i;
        }
      }
    }
  }
  return -1;
}

/*==========================================
 * Login Data
 *  Register online character via memory
 *  and sql. But we prefer to use memory
 *  for fast and accurate result.
 *------------------------------------------
 */
int logindata_init() {
  login_data = uidb_alloc(DB_OPT_BASE);
  // mmo_setallonline(0);
  return 0;
}

int logindata_final(void *key, void *data, va_list ap) {
  struct item_data *dat;
  nullpo_ret(0, dat = data);
  FREE(dat);
  return 0;
}

int logindata_term() {
  if (login_data) {
    // numdb_final(login_data, logindata_final);
    login_data = NULL;
  }
  // mmo_setallonline(0);
  return 0;
}

struct char_login_data *logindata_search(unsigned int id) {
  struct char_login_data *dat;
  dat = (struct char_login_data *)uidb_get(login_data, id);
  if (!dat) {
    return NULL;
  }

  return dat;
}

/*int logindata_del(unsigned int id) {
        struct char_login_data *dat;
        dat = numdb_search(login_data, id);
        //mmo_setonline(id,0);

        if (!dat)
                return 0;

        FREE(dat);
        numdb_erase(login_data, id);
        //mmo_setonline(id, 0);
        return 0;
}*/

int logindata_change(unsigned int id, int map_server) {
  struct char_login_data *dat;
  dat = (struct char_login_data *)uidb_get(login_data, id);
  if (!dat) {
    return -1;
  }

  dat->map_server = map_server;
  return 0;
}

/*==========================================
 * Configuration File Read
 *------------------------------------------
 */
int config_read(const char *cfg_file) {
  char line[1024], r1[1024], r2[1024];
  char login_ip_s[16];

  int line_num = 0;
  FILE *fp;
  int m, x, y;

  fp = fopen(cfg_file, "r");
  if (fp == NULL) {
    printf("[char] [config_read] File (%s) not found.\n", cfg_file);
    exit(1);
  }

  while (fgets(line, sizeof(line), fp)) {
    line_num++;
    if (line[0] == '/' && line[1] == '/') {
      continue;
    }

    if (sscanf(line, "%[^:]: %[^\r\n]", r1, r2) == 2) {
      // CHAR
      if (strcasecmp(r1, "char_port") == 0) {
        char_port = atoi(r2);
      } else if (strcasecmp(r1, "char_id") == 0) {
        strncpy(char_id, r2, 32);
        char_id[31] = '\0';
      } else if (strcasecmp(r1, "char_pw") == 0) {
        strncpy(char_pw, r2, 32);
        char_pw[31] = '\0';
        // LOGIN
      } else if (strcasecmp(r1, "login_ip") == 0) {
        strncpy(login_ip_s, r2, 16);
        login_ip_s[15] = '\0';
        login_ip = inet_addr(login_ip_s);
      } else if (strcasecmp(r1, "login_port") == 0) {
        login_port = atoi(r2);
      } else if (strcasecmp(r1, "login_id") == 0) {
        strncpy(login_id, r2, 32);
        login_id[31] = '\0';
      } else if (strcasecmp(r1, "login_pw") == 0) {
        strncpy(login_pw, r2, 32);
        login_pw[31] = '\0';
      } else if (strcasecmp(r1, "sql_ip") == 0) {
        strcpy(sql_ip, r2);
      } else if (strcasecmp(r1, "sql_port") == 0) {
        sql_port = atoi(r2);
      } else if (strcasecmp(r1, "sql_id") == 0) {
        strcpy(sql_id, r2);
      } else if (strcasecmp(r1, "sql_pw") == 0) {
        strcpy(sql_pw, r2);
      } else if (strcasecmp(r1, "sql_db") == 0) {
        strcpy(sql_db, r2);
        // DUMP & LOG
      } else if (strcasecmp(r1, "start_point") == 1) {
        sscanf(r2, "%d,%d,%d", &m, &x, &y);
      }
    }
  }
  fclose(fp);
  printf("[char] [config_read_success] file=%s\n", cfg_file);
  start_pos.m = m;
  start_pos.x = x;
  start_pos.y = y;

  return 0;
}

void do_term() {
  logindata_term();
  char_db_term();
  session_eof(login_fd);
  printf("[char] [shutdown] Char Server Shutdown.\n");
}

void help_screen() {
  printf("HELP LIST\n");
  printf("---------\n");
  printf(" --conf [FILENAME]  : set config file\n");
  exit(0);
}
int keep_login_alive(int n, int a) {
  if (login_fd) {
    WFIFOB(login_fd, 0) = 0xFF;
    WFIFOB(login_fd, 1) = 1;
    WFIFOSET(login_fd, 2);
  }
  return 0;
}
int do_init(int argc, char **argv) {
  int i;
  char *CONF_FILE = "conf/server.conf";

  srand(gettick());

  for (i = 1; i < argc; i++) {
    if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "--h") == 0 ||
        strcmp(argv[i], "--?") == 0 || strcmp(argv[i], "/?") == 0) {
      help_screen();
    } else if (strcmp(argv[i], "--conf") == 0) {
      CONF_FILE = argv[i + 1];
    }
  }

  config_read(CONF_FILE);
  set_termfunc(do_term);

  printf("[char] [started] Char Server Started.\n");

  char_db_init();
  logindata_init();

  set_defaultparse(mapif_parse_auth);
  char_fd = make_listen_port(char_port);

  timer_insert(1000, 1000 * 10, check_connect_login, (uintptr_t *)&login_ip,
               (uintptr_t *)&login_port);

  CALLOC(char_dat, struct mmo_charstatus, 1);

  printf("[char] [ready] port=%d\n", char_port);

  zlib_init();
  return 0;
}
