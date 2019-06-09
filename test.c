#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <time.h>
#include "csv.h"

/* trivial test case used to check
 * CSV reader.
 */
int main(int argc, char** argv)
{
    unsigned rowcount = 0;
    unsigned colcount = 0;
    char* row = NULL;
    unsigned expRows = 0;
    unsigned expCols = 0;
    struct timespec t1, t2;
    long diff = 0;

    /* get exp rows / cols */
    if (argc < 1 + 3)
    {
        puts("Please provide expectations");
        exit(-EINVAL);
    }

    /* parse */
    const char* csvname = argv[1];
    expRows = (unsigned)atoi(argv[2]);
    expCols = (unsigned)atoi(argv[3]);
    
    CsvHandle handle = CsvOpen(csvname);
    if (!handle)
    {
        puts("can not open test.csv file");
        return -EINVAL;
    }

    /* measure */
    clock_gettime(CLOCK_REALTIME, &t1);
    while ((row = CsvReadNextRow(handle)))
    {
        const char* col = NULL;
        rowcount++;
        while ((col = CsvReadNextCol(row, handle)))
            colcount++;
    }
    
    clock_gettime(CLOCK_REALTIME, &t2);
    CsvClose(handle);

    /* analyze K={t2-t1} */
    diff = (t2.tv_nsec - t1.tv_nsec) / 1000 / 1000;
    diff += (t2.tv_sec - t1.tv_sec) * 1000;

    /* print measurement in (ms) */
    printf("time in milliseconds: %li (ms)\n", diff);

    /* expectations */
    printf("rowcount: %u/%u, colcount: %u/%u\n",
           rowcount, expRows, colcount, expCols);
    
    assert(expRows == rowcount);
    assert(expCols == colcount);
    
    return 0;
}
