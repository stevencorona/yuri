#pragma once

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef CALLOC
#define CALLOC(result, type, number) \
  (result) = (type *)calloc((number), sizeof(type))

#define REALLOC(result, type, number) \
  (result) = (type *)realloc((result), sizeof(type) * (number))

#define FREE(result) \
  do {               \
    free(result);    \
    (result) = NULL; \
  } while (0)

#define nullpo_ret(result, target) \
  if (!(target)) return (result)
#endif

#define SERVER_TICK_RATE_NS 10000000

typedef void (*term_func_t)(void);