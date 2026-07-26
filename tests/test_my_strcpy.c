#include <stdio.h>
#include "libjl.h"
#include "test.h"

void test_strcpy(void) {
    char source[] = "Hejsan";
    char dest[6];
    char *r = my_strcpy(dest, source);
    ASSERT_ARR_EQ(source, dest, 6);
    ASSERT_STR_EQ(source, dest);
}
