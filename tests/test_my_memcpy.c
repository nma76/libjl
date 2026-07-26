#include <stdio.h>
#include "libjl.h"
#include "test.h"

void test_memcpy(void) {
    int s1[] = {1, 2, 3, 4, 5};
    int d1[5];
    my_memcpy(d1, s1, 5 * sizeof(int));
    ASSERT_ARR_EQ(s1, d1, 5);

    char s2[] = "12345";
    char d2[5];
    my_memcpy(d2, s2, 5 * sizeof(char));
    ASSERT_ARR_EQ(s2, d2, 5);
}