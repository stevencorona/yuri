#include "core.h"

#include <ctype.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

#include "db.h"
#include "session.h"
#include "timer.h"

int (*func_parse_it)(char *) = default_parse_input;
static void (*term_func)(void) = NULL;
char date_format[32] = "%Y-%m-%d %H:%M:%S";
static char h_svn_version[10] = "";
struct timeval start;
static long long check2 = 0;

pthread_t thread_id_packet;
pthread_t thread_sendrecv;
pthread_t thread_dotimer;

// --------------------------
// Main Routine
//----------------------------
int main(int argc, char **argv) {
  Last_Eof = 0;

  gettimeofday(&start, NULL);

  int next;
  int tick;

  int run = 1;
  // char str[65536];
  // memset(str,0,65536);
  server_shutdown = 0;

  do_socket();

  signal(SIGPIPE, sig_proc);
  signal(SIGTERM, sig_proc);
  signal(SIGINT, sig_proc);
  db_init();
  timer_init();

  do_init(argc, argv);

  /**
   * Run the main server loop, ticking every 10ms This is currently single
   * threaded and is not particularly efficient.
   *
   * Previously, do_sendrecv was setup to block but I have made it non-blocking
   * for the time being because the timers get wonky if they don't tick
   * frequently.
   *
   * In the future, timers should probably run in a dedicated thread and move
   * socket processing to an async event loop.
   **/
  while (run) {
    tick = gettick_nocache();

    timer_do(tick);
    do_sendrecv(next);
    do_parsepacket();

    nanosleep((struct timespec[]){{0, 10000}}, NULL);
  }

  return 0;
}

//#include <pthread.h>
const char *get_svn_revision(void) {
  FILE *fp;

  if (*h_svn_version) {
    return h_svn_version;
  }

  if ((fp = fopen(".svn/entries", "r")) != NULL) {
    char line[1024];
    int rev;
    // Check the version
    if (fgets(line, sizeof(line), fp)) {
      if (!isdigit(line[0])) {
        // XML File format
        while (fgets(line, sizeof(line), fp)) {
          if (strstr(line, "revision=")) {
            break;
          }
        }
        if (sscanf(line, " %*[^\"]\"%d%*[^\n]", &rev) == 1) {
          snprintf(h_svn_version, sizeof(h_svn_version), "%d", rev);
        }
      } else {
        // Bin File format
        fgets(line, sizeof(line), fp);      // Get the name
        fgets(line, sizeof(line), fp);      // Get the entries kind
        if (fgets(line, sizeof(line), fp))  // Get the rev numver
        {
          snprintf(h_svn_version, sizeof(h_svn_version), "%d", atoi(line));
        }
      }
    }
    fclose(fp);
  }

  if (!(*h_svn_version)) {
    snprintf(h_svn_version, sizeof(h_svn_version), "Unknown");
  }

  return h_svn_version;
}

unsigned int getTicks(void) {
  struct timeval now;
  unsigned long ticks;
  long long ticks2;

  gettimeofday(&now, NULL);
  ticks2 = (((long long)now.tv_sec) * 1000000) + now.tv_usec;
  check2 = ticks2;
  ticks =
      (now.tv_sec - start.tv_sec) * 1000 + (now.tv_usec - start.tv_usec) / 1000;
  return (ticks);
}

void crash_log(char *aids, ...) {}

// Add packet to dump
// Saved from RFIFO
//----------------------------
void add_dmp(int fd, int len) {
  /*
  FILE *dmpfp;
  int i;
  struct timeval tv;
  char timetmp[128];

  unsigned char *p = (unsigned char *) &session[fd]->client_addr.sin_addr;
  char ip[16];
  sprintf(ip, "%u.%u.%u.%u", p[0], p[1], p[2], p[3]);

  dmpfp = fopen("C:\\lastpacket.hex", "w");
  if (dmpfp) {
          gettimeofday(&tv, NULL);
          strftime(timetmp, 24, date_format, localtime(&(tv.tv_sec)));
          fprintf(dmpfp, "%s IP: %s len %d\n", timetmp, ip, len);
          fprintf(dmpfp, "[HEX]:");
          for(i=0;i < len;i++) {
                  fprintf(dmpfp, "[%02X]", RFIFOB(fd, i));
          }
          fprintf(dmpfp, "\n[CHR]:");
          for(i=0;i < len;i++) {
                  fprintf(dmpfp, "[ %c]", RFIFOB(fd, i));
          }
          fprintf(dmpfp, "\n");
  }
  fclose(dmpfp);
  */
}

// Set terminate function
//----------------------------
void set_termfunc(void (*termfunc)(void)) { term_func = termfunc; }

// Signal handling
//----------------------------
static void sig_proc(int sn) {
  int i;
  switch (sn) {
    case SIGINT:
    case SIGTERM:
      printf("[core] [signal] signal=SIGTERM\n");
      if (term_func) {
        term_func();
      }
      timer_clear();
      for (i = 0; i < fd_max; i++) {
        if (!session[i]) {
          continue;
        }
        // close(i);
        session_eof(i);
      }
      // endwin();
      exit(0);
      break;
    case SIGPIPE:
      break;
  }
}

int set_default_input(int (*func)(char *)) {
  func_parse_it = func;
  return 0;
}
int default_parse_input(char *val) { return 0; }