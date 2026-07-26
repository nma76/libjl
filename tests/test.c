#include <stdio.h>
#include "mylib.h"
#include "test.h"

unsigned tests_run = 0;
unsigned assertions = 0;
unsigned failures = 0;

struct test_case tests[] = {
    { "my_atoi", test_atoi},
    { "my_getchar", test_getchar},
    { "my_itoa", test_itoa},
    { "my_mamcpy", test_memcpy},
    { "my_memset", test_memset},
    { "my_putchar", test_putchar},
    { "my_puts", test_puts},
    { "my_read", test_read},
    { "my_strchr", test_strchr},
    { "my_strcmp", test_strcmp},
    { "my_strcpy", test_strcpy},
    { "my_strlen", test_strlen},
    { "my_utoa", test_utoa},
    { "my_htoa", test_htoa},
    { "my_write", test_write}
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