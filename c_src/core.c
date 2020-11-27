#include "core.h"

#include <ctype.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>

#include "db.h"
#include "session.h"
#include "timer.h"

extern int do_init(int, char **);
static term_func_t term_func;

// Main server entry point that runs the networking/logic loop for the
// map/login/char servers
int main(int argc, char **argv) {
  struct timeval start;
  int tick = 0;
  bool run = true;

  gettimeofday(&start, NULL);

  server_shutdown = 0;

  do_socket();

  signal(SIGPIPE, handle_signal);
  signal(SIGTERM, handle_signal);
  signal(SIGINT, handle_signal);
  db_init();
  timer_init();

  // Each server is required to implement their own do_init function callback
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
    do_sendrecv();
    do_parsepacket();

    if (server_shutdown == 1) {
      run = false;
    }

    nanosleep((struct timespec[]){{0, SERVER_TICK_RATE_NS}}, NULL);
  }

  return 0;
}

void handle_signal(int signal) {
  switch (signal) {
    case SIGINT:
    case SIGTERM:
      printf("[core] [signal] signal=SIGTERM\n");
      if (term_func != NULL) {
        term_func();
      }
      timer_clear();
      for (int i = 0; i < fd_max; i++) {
        if (!session[i]) {
          continue;
        }
        // close(i);
        session_eof(i);
      }
      exit(0);
      break;
    case SIGPIPE:
    default:
      break;
  }
}

void set_termfunc(term_func_t new_term_func) { term_func = new_term_func; }