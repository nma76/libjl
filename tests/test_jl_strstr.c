#include <stdio.h>
#include "libjl.h"
#include "test.h"

void test_strstr(void) {
    const char *haystack1 = "This is my haystack!";
    const char *needle1 = "my";
    char *result1 = jl_strstr(haystack1, needle1);
    ASSERT_STR_EQ(result1, "my haystack!");

    const char *haystack2 = "This is my haystack!";
    const char *needle2 = "myx";
    char *result2 = jl_strstr(haystack2, needle2);
    ASSERT_EQ(result2, NULL);
}
