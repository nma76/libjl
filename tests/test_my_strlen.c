#include <stdio.h>
#include "libjl.h"
#include "test.h"

void test_strlen(void) {
    char *str = "Hejsan!";
    size_t len = my_strlen(str);
    size_t expected = 7;
    ASSERT_EQ(len, expected);

    str = " Hello\n";
    len = my_strlen(str);
    expected = 7;
    ASSERT_EQ(len, expected);

    str = "Hellö";
    len = my_strlen(str);
    expected = 6;
    ASSERT_EQ(len, expected);
}
