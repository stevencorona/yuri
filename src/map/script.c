#include <stdio.h>
#include <string.h>
#ifndef _WIN32
#include <sys/time.h>
#endif

#include "core.h"
#include "map.h"
#include "npc.h"

int script_config_read_sub(char *cfgName) {
  int i;
  char line[1024], w1[1024], w2[1024];
  FILE *fp;

  fp = fopen(cfgName, "r");
  if (fp == NULL) {
    return 1;
  }
  while (fgets(line, sizeof(line) - 1, fp)) {
    if (line[0] == '/' && line[1] == '/') continue;
    i = sscanf(line, "%[^:]: %[^\r\n]", w1, w2);
    if (i != 2) continue;

    if (strcasecmp(w1, "import") == 0) {
      script_config_read_sub(w2);
    } else if (strcasecmp(w1, "npc") == 0) {
      npc_src_add(w2);
    } else if (strcasecmp(w1, "map") == 0) {
      map_src_add(w2);
    } else if (strcasecmp(w1, "warp") == 0) {
      printf("%s\n", w2);
      npc_warp_add(w2);
    } else if (strcasecmp(w1, "town") == 0) {
      if (map_town_add(w2)) printf("CFG ERROR!!!\n");
    }
  }
  fclose(fp);

  return 0;
}
