#include <stdint.h>

#ifndef LIBJL_H
#define LIBJL_H

size_t jl_strlen(const char *source);
char *jl_strcpy(char *dest, const char *source);
char *jl_strchr(const char *string, int c);
int jl_strcmp(char *source1, char *source2); 

void *jl_memcpy(void *restrict dest, const void *restrict src, size_t n);
void *jl_memset(void *dest, int c, size_t n);

ssize_t jl_write(int fd, const void *buf, size_t count);
ssize_t jl_read(int fd, void *buf, size_t count);
int jl_putchar(int c);
int jl_puts(const char *str);
int jl_getchar(void);

bool jl_atoi(const char *source, int *value);
bool jl_itoa(int value, char *dest);
bool jl_utoa(uint64_t source, char *dest);
bool jl_htoa(uint64_t source, char *dest);

#endif