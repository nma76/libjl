#include <stdio.h>
#include <limits.h>
#include "libjl.h"
#include "test.h"

void test_utoa(void) {
    uint64_t source;
    char dest[33];
    bool result = false;
    char expected[33];

    source = 42;
    result = my_utoa(source, dest);
    sprintf(expected, "%ld", 42);
    ASSERT_TRUE(result);
    ASSERT_STR_EQ(dest, expected);

    source = 4294967295;
    result = my_utoa(source, dest);
    sprintf(expected, "%ld", 4294967295);
    ASSERT_TRUE(result);
    ASSERT_STR_EQ(dest, expected);

    source = +42;
    result = my_utoa(source, dest);
    sprintf(expected, "%ld", 42);
    ASSERT_TRUE(result);
    ASSERT_STR_EQ(dest, expected);

    source = 0;
    result = my_utoa(source, dest);
    sprintf(expected, "%ld", 0);
    ASSERT_TRUE(result);
    ASSERT_STR_EQ(dest, expected);

    source = -42;
    result = my_utoa(source, dest);
    sprintf(expected, "%ld", 0);
    ASSERT_EQ(result, 1);
}