#include <stdio.h>
#include <unistd.h>
#include "libjl.h"
#include "test.h"

void test_read(void) {
    // Create pipe. fda[1] = write, fds[0] = read
    int fds[2];
    pipe(fds);

    // Put text into pipe
    write(fds[1], "Hello world!", 12);
    close(fds[1]);

    // change stdin to our pipe
    dup2(fds[0], 0);
    close(fds[0]);

    // buffer (make room for null termination at end)
    char buf[13];
    // read from pipe and add null termination
    ssize_t result = jl_read(0, &buf, 12);
    buf[12] = '\0';
    ASSERT_EQ(result, 12);
    ASSERT_STR_EQ(buf, "Hello world!");
}