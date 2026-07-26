#include <stdio.h>
#include <unistd.h>
#include "libjl.h"
#include "test.h"

void test_write(void) {
    // save original stdout
    int saved_stdout = dup(1);

    // Create pipe. fda[1] = write, fds[0] = read
    int fds[2];
    pipe(fds);

    // change stdout to our pipe
    dup2(fds[1], 1);
    close(fds[1]);

    // message to print
    const char *message = "Hej från jl_write\n";

    // get length of text
    size_t length = jl_strlen(message);

    // write to stdout. fd = 1 is stdout
    jl_write(1, message, length);

    // Assert results
    ASSERT_EQ(length, 19);

    // restore stdout
    dup2(saved_stdout, 1);
    close(saved_stdout);
}