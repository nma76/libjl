#include <stdio.h>
#include <unistd.h>
#include "libjl.h"
#include "test.h"

void test_puts(void) {
    // save original stdout
    int saved_stdout = dup(1);

    // Create pipe. fda[1] = write, fds[0] = read
    int fds[2];
    pipe(fds);

    // change stdout to our pipe
    dup2(fds[1], 1);
    close(fds[1]);

    int result;

    const char *str1 = "Hello from puts\n";
    result = jl_puts(str1);
    ASSERT_EQ(result, 16);

    const char *str2 = "Hellö from puts\n";
    result = jl_puts(str2);
    ASSERT_EQ(result, 17);

    // restore stdout
    dup2(saved_stdout, 1);
    close(saved_stdout);
}