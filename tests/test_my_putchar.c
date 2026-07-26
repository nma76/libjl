#include <stdio.h>
#include <unistd.h>
#include "libjl.h"
#include "test.h"

void test_putchar(void) {
    // save original stdout
    int saved_stdout = dup(1);

    // Create pipe. fda[1] = write, fds[0] = read
    int fds[2];
    pipe(fds);

    // change stdout to our pipe
    dup2(fds[1], 1);
    close(fds[1]);

    char chr;
    int result;
    char buffer[8];
    ssize_t n;

    chr = ' ';
    result = my_putchar(chr);
    n = read(fds[0], buffer, sizeof(buffer));
    ASSERT_EQ(n, 1);
    ASSERT_EQ(buffer[0], chr);
    ASSERT_EQ(result, 32);

    chr = 'A';
    result = my_putchar(chr);
    ASSERT_EQ(result, 65);

    // restore stdout
    dup2(saved_stdout, 1);
    close(saved_stdout);
}






