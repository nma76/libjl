#include <stdio.h>
#include "libjl.h"
#include "test.h"

void test_atoi(void) {
    // holds the results
    int result;
    bool status;

    status = jl_atoi("   123", &result);
    ASSERT_EQ(status, true);
    ASSERT_EQ(result, 123);

    status = jl_atoi("23", &result);
    ASSERT_EQ(status, true);
    ASSERT_EQ(result, 23);

    status = jl_atoi("123-456", &result);
    ASSERT_EQ(status, true);
    ASSERT_EQ(result, 123);

    status = jl_atoi("-45", &result);
    ASSERT_EQ(status, true);
    ASSERT_EQ(result, -45);

    status = jl_atoi("abc123", &result);
    ASSERT_EQ(status, false);
    ASSERT_EQ(result, 0);

    status = jl_atoi("+42", &result);
    ASSERT_EQ(status, true);
    ASSERT_EQ(result, 42);

    status = jl_atoi("12 abc", &result);
    ASSERT_EQ(status, true);
    ASSERT_EQ(result, 12);
}