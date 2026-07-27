#include <stdio.h>
#include "libjl.h"
#include "test.h"

void test_open(void) {
    // store file handle to the opened file
    int hndl;

    // filename to open
    const char *filename = "./testdata/test_read.txt";
    const char *badfilename = "./file_not_found.txt";

    // create buffer to store read content
    char buf[13];

    // the result, size of data read
    ssize_t result;

    // test success
    // open file as read-only
    hndl = jl_open(filename, 0);
    ASSERT_TRUE(hndl >= 0);
    // read the file and add null termination as last char
    result = jl_read(hndl, &buf, 12);
    buf[12] = '\0';
    ASSERT_EQ(result, 12);
    ASSERT_STR_EQ(buf, "Hello world!");

    // test file (file dont exist)
    // open file as read-only
    hndl = jl_open(badfilename, 0);
    ASSERT_TRUE(hndl < 0);
}