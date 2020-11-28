#pragma once
#define MSG_MAX 11

enum {
  LGN_ERRSERVER,
  LGN_WRONGPASS,
  LGN_WRONGUSER,
  LGN_ERRDB,
  LGN_USEREXIST,
  LGN_ERRPASS,
  LGN_ERRUSER,
  LGN_NEWCHAR,
  LGN_CHGPASS,
  LGN_DBLLOGIN,
  LGN_BANNED
};

extern int char_fd;
extern char login_msg[MSG_MAX][256];
extern struct Sql *sql_handle;
int getInvalidCount(unsigned int);
int setInvalidCount(unsigned int);

int lang_read(const char *);
int string_check(const char *, int);
int string_check_allchars(const char *, int);
void do_term(void);