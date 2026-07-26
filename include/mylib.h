#include <stdint.h>

#ifndef MYLIB_H
#define MYLIB_H

size_t my_strlen(const char *source);
char *my_strcpy(char *dest, const char *source);
char *my_strchr(const char *string, int c);
int my_strcmp(char *source1, char *source2); 

void *my_memcpy(void *restrict dest, const void *restrict src, size_t n);
void *my_memset(void *dest, int c, size_t n);

ssize_t my_write(int fd, const void *buf, size_t count);
ssize_t my_read(int fd, void *buf, size_t count);
int my_putchar(int c);
int my_puts(const char *str);
int my_getchar(void);

bool my_atoi(const char *source, int *value);
bool my_itoa(int value, char *dest);
bool my_utoa(uint64_t source, char *dest);
bool my_htoa(uint64_t source, char *dest);

#endif