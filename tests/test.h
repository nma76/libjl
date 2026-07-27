#ifndef TEST_H
#define TEST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern unsigned tests_run;
extern unsigned assertions;
extern unsigned failures;

typedef void (*test_fn)(void);
struct test_case {
    const char *name;
    test_fn fn;
};

void test_atoi(void);
void test_getchar(void);
void test_itoa(void);
void test_memcpy(void);
void test_memset(void);
void test_putchar(void);
void test_puts(void);
void test_read(void);
void test_strchr(void);
void test_strcmp(void);
void test_strcpy(void);
void test_strlen(void);
void test_utoa(void);
void test_htoa(void);
void test_write(void);
void test_open(void);
void test_close(void);

#define ASSERT_TRUE(expr) \
    do { \
        assertions++; \
        if(!(expr)) { \
            fprintf(stderr, "Assertion failed: %s (%s:%d)\n", #expr, __FILE__, __LINE__); \
            failures++; \
        } \
    } while (0)

#define ASSERT_EQ(a, b) \
    do { \
        assertions++; \
        if((a) !=(b)) { \
            fprintf(stderr, "Assertion failed: %s == %s (%d != %d) at %s:%d\n", #a, #b, (a), (b), __FILE__, __LINE__); \
            failures++; \
        } \
    } while (0) 

#define ASSERT_LT(a, b) \
    do { \
        assertions++; \
        if((a) >=(b)) { \
            fprintf(stderr, "Assertion failed: %s < %s (%d <= %d) at %s:%d\n", #a, #b, (a), (b), __FILE__, __LINE__); \
            failures++; \
        } \
    } while (0) 

#define ASSERT_GT(a, b) \
    do { \
        assertions++; \
        if((a) <=(b)) { \
            fprintf(stderr, "Assertion failed: %s > %s (%d >= %d) at %s:%d\n", #a, #b, (a), (b), __FILE__, __LINE__); \
            failures++; \
        } \
    } while (0) 


#define ASSERT_STR_EQ(a, b) \
    do { \
        assertions++; \
        if(strcmp((a), (b)) != 0) { \
            fprintf(stderr, "Assertion failed: %s == %s (%s != %s) at %s:%d\n", #a, #b, (a), (b), __FILE__, __LINE__); \
            failures++; \
        } \
    } while (0) 

#define ASSERT_ARR_EQ(a, b, n) \
    do { \
        assertions++; \
        for (size_t i = 0; i < (n); i++) { \
            if ((a)[i] != (b)[i]) { \
                fprintf(stderr, "Assertion failed: %s[%zu] == %s[%zu] (%d != %d) at %s:%d\n", #a, i, #b, i, (a)[i], (b)[i], __FILE__, __LINE__); \
                failures++; \
                break; \
            } \
        } \
    } while (0)

#endif