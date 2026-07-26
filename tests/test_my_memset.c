#include <stdio.h>
#include "libjl.h"
#include "test.h"

void test_memset(void) {
    char b[10];
    my_memset(b, 65, sizeof(b));

    ASSERT_ARR_EQ(b, "AAAAAAAAAA", 10);
}