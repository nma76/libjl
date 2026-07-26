#include <stdio.h>
#include <limits.h>
#include "libjl.h"
#include "test.h"

void test_htoa(void) {
    uint64_t source;
    char dest[33];
    bool result = false;
    char expected[33];

    source = 0;
    result = my_htoa(source, dest);
    sprintf(expected, "%llX", 0x0);
    ASSERT_TRUE(result);
    ASSERT_STR_EQ(dest, expected);

    source = 0x1234ABCD;
    result = my_htoa(source, dest);
    sprintf(expected, "%llX", 0x1234ABCD);
    ASSERT_TRUE(result);
    ASSERT_STR_EQ(dest, expected);

    source = 0x41;
    result = my_htoa(source, dest);
    sprintf(expected, "%llX", 0x41);
    ASSERT_TRUE(result);
    ASSERT_STR_EQ(dest, expected);

    source = 42;
    result = my_htoa(source, dest);
    sprintf(expected, "%llX", 0x2A);
    ASSERT_TRUE(result);
    ASSERT_STR_EQ(dest, expected);
}