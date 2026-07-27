#include <stdio.h>
#include "libjl.h"
#include "test.h"

void test_close(void) {
    // store file handle to the opened file
    int hndl;

    // filename to open
    const char *filename = "./testdata/test_read.txt";
    const char *badfilename = "./file_not_found.txt";

    // create buffer to store read content
    char buf[13];

    // the result, size of data read
    int result;

    // open file as read-only and close it
    hndl = jl_open(filename, 0);
    result = jl_close(hndl);
    ASSERT_EQ(result, 0);

    // close a file thats not open
    result = jl_close(-1);
    ASSERT_TRUE(result < 0);
}