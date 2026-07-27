#include <stdio.h>
#include "libjl.h"
#include "test.h"

unsigned tests_run = 0;
unsigned assertions = 0;
unsigned failures = 0;

struct test_case tests[] = {
    { "jl_atoi",    test_atoi},
    { "jl_getchar", test_getchar},
    { "jl_itoa",    test_itoa},
    { "jl_mamcpy",  test_memcpy},
    { "jl_memset",  test_memset},
    { "jl_putchar", test_putchar},
    { "jl_puts",    test_puts},
    { "jl_read",    test_read},
    { "jl_strchr",  test_strchr},
    { "jl_strcmp",  test_strcmp},
    { "jl_strcpy",  test_strcpy},
    { "jl_strlen",  test_strlen},
    { "jl_utoa",    test_utoa},
    { "jl_htoa",    test_htoa},
    { "jl_write",   test_write},
    { "jl_open",    test_open},
    { "jl_close",   test_close}
};

int main(void) {
    for (size_t i = 0; i < sizeof(tests)/sizeof(tests[0]); i++) {
        tests_run++;
        printf("Running test: %-20s", tests[i].name);
        tests[i].fn();
        printf("Done!\n");
    }

    printf("\n\n------------------------------------------\n");
    printf("Tests run: %u\n", tests_run);
    printf("Assertions run: %u\n", assertions);
    printf("Failed: %u\n", failures);
    printf("------------------------------------------\n");

    return 0;
}