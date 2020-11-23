#include "../common/malloc.h"

#include <ctype.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>

#include "../common/showmsg.h"

char *strlwr(char *string) {
  char *s;

  if (string) {
    for (s = string; *s; ++s) {
      *s = tolower(*s);
    }
  }
  return string;
}

void add_log(char *fmt, ...) {
  FILE *logfp;
  va_list ap;
  struct timeval tv;
  char tmpstr[128];

  char log_filename[] = "logs/generallog.txt";

  va_start(ap, fmt);

  logfp = fopen(log_filename, "a");
  char date_format[32] = "%Y-%m-%d %H:%M:%S";

  if (logfp) {
    if (fmt[0] == '\0') {  // jump a line if no message
      fprintf(logfp, "\n");
    } else {
      gettimeofday(&tv, NULL);
      strftime(tmpstr, 24, date_format, localtime(&(tv.tv_sec)));
      sprintf(tmpstr + strlen(tmpstr), ".%03d: %s", (int)tv.tv_usec / 1000,
              fmt);
      vfprintf(logfp, tmpstr, ap);
    }
    fclose(logfp);
  }

  va_end(ap);
}