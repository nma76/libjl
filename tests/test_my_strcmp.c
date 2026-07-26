#include <stdio.h>
#include "libjl.h"
#include "test.h"

void test_strcmp(void) {
    int result;

    char *str11 = "Hejsan";
    char *str12 = "Hejsan";
    result = jl_strcmp(str11, str12);
    ASSERT_EQ(result, 0);

    char *str21 = "Hejsan";
    char *str22 = "hejsan";
    result = jl_strcmp(str21, str22);
    ASSERT_LT(str21, str22);

    char *str31 = "hejsan";
    char *str32 = "Hejsan";
    result = jl_strcmp(str31, str32);
    ASSERT_GT(str31, str32);
}
