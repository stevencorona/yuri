#pragma once

#define __func__ __FUNCTION__
#include <stddef.h>
#include <stdio.h>

#define CALLOC(result, type, number)                                    \
  if (!((result) = (type*)calloc((number), sizeof(type))))              \
  printf("SYS_ERR: calloc failure at %s:%d(%s).\n", __FILE__, __LINE__, \
         __func__),                                                     \
      exit(1)

#define REALLOC(result, type, number) \
  (result) = (type*)realloc((result), sizeof(type) * (number))

#define FREE(result) \
  do {               \
    free(result);    \
    result = NULL;   \
  } while (0)

#define nullpo_ret(result, target) \
  if (!(target)) return (result)