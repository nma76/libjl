#include <stdio.h>
#include "libjl.h"
#include "test.h"

void test_strchr(void) {
    char search;

    const char *source1 = "Hejsan!";
    search = 'j';
    char *result1 = jl_strchr(source1, search);
    ASSERT_STR_EQ(result1, "jsan!");

    const char *source2 = "Hello!";
    search = 'j';
    char *result2 = jl_strchr(source2, search);
    ASSERT_EQ(result2, NULL);
}
