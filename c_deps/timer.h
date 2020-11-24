#pragma once

#include <stdint.h>

#define DIFF_TICK(a, b) ((int)((a) - (b)))
#define INVALID_TIMER -1

// timer flags
#define TIMER_ONCE_AUTODEL 0x01
#define TIMER_INTERVAL 0x02
#define TIMER_REMOVE_HEAP 0x10

struct TimerData {
  unsigned int tick;
  int (*func)(uintptr_t *, uintptr_t *);
  int type;
  unsigned int interval;
  int heap_pos;

  // general-purpose storage
  int id;
  uintptr_t *data1;
  uintptr_t *data2;
};

int timer_insert(unsigned int, unsigned int, int (*)(uintptr_t *, uintptr_t *),
                 uintptr_t *, uintptr_t *);
int timer_remove(int);
int timer_do(unsigned int tick);
int getDay(void);
int getHour(void);
int getMinute(void);
int getSecond(void);
int timer_clear();
void timer_init();
unsigned int gettick_nocache();
unsigned int gettick();
