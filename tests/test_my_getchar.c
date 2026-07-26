#include <stdio.h>
#include <unistd.h>
#include "libjl.h"
#include "test.h"

void test_getchar(void) {
    // Create pipe. fda[1] = write, fds[0] = read
    int fds[2];
    pipe(fds);

    // Put char A into pipe
    write(fds[1], "A", 1);
    close(fds[1]);

    // change stdinb to our pipe
    dup2(fds[0], 0);
    close(fds[0]);

    // Call getchar and evaluate the result
    int c = my_getchar();
    ASSERT_EQ(c, 'A');
}