#include "core.h"

#include <ctype.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>

#include "db.h"
#include "session.h"
#include "timer.h"

int (*func_parse_it)(char *) = default_parse_input;
static void (*term_func)(void) = NULL;
struct timeval start;
static long long check2 = 0;

// Main server entry point that runs the networking/logic loop for the
// map/login/char servers
int main(int argc, char **argv) {
  gettimeofday(&start, NULL);

  int next;
  int tick;

  int run = 1;
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

    nanosleep((struct timespec[]){{0, 10000000}}, NULL);
  }

  return 0;
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