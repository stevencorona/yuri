
#ifndef _MALLOC_H_
#define _MALLOC_H_
#define __func__ __FUNCTION__
#include <stddef.h>

#define ALC_MARK __FILE__, __LINE__, __func__

#define aMalloc(n) malloc(n)
#define aCalloc(m,n) calloc(m,n)
#define aRealloc(p,n) realloc(p,n)
#define aFree(p) free(p)
#define STRDUP(p,file,line,func)	strdup(p)

#define aStrdup(a) aStrdup_(a,ALC_MARK)
char* aStrdup_(const char*, const char*, int, const char*);
//////////////////////////////////////////////////////////////////////
// Athena's built-in Memory Manager


char* strlwr(char*);
void add_log(char*, ...);
#ifndef strcmpi
#define strcmpi(x,y) strcasecmp(x,y)
#endif

#define CALLOC(result, type, number) if (!((result) = (type *)aCalloc((number),sizeof(type)))) \
	printf("SYS_ERR: calloc failure at %s:%d(%s).\n", __FILE__, __LINE__, __func__), exit(1)

#define REALLOC(result, type, number)  (result) = (type *)aRealloc((result), sizeof(type) * (number))

#define FREE(result) do { aFree(result); result = NULL; } while(0)

int free_lock(void);
int free_unlock(void);
char* s_inject(char*);

#define nullpo_ret(result, target) if (!(target)) return (result)

#define nullpo_chk(target) if (!(target)) \
	printf("SYS_ERR: nullpo failure at %s:%d(%s).\n", __FILE__, __LINE__, __func__), exit(1)

#endif
