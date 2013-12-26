// PROMPT_COMMAND for z.sh

#include <linux/limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

int main(int argc __attribute__((unused)), char **argv) {

    if (argv[1] == NULL) return EXIT_FAILURE;

    static const float MULTIPLIER = 0.99;
    static const int RANK_SUM_MAX = 6000;

    char * _Z_DATA;
    char datafile[PATH_MAX];
    char tmpfile[PATH_MAX];
    char agedfile[PATH_MAX];
    FILE *read;
    FILE *write;
    FILE *aged;
    char line[PATH_MAX * 2];
    char pth[PATH_MAX];
    float rank;
    int timestamp;
    struct stat s;
    time_t epoch = time(NULL);
    int found = 0;
    float rank_sum = 0;

    // Don't track $HOME
    if (strcmp(argv[1], getenv("HOME")) == 0) return EXIT_SUCCESS;

    // TODO
    //        # don't track excluded dirs
    //        local exclude
    //        for exclude in "${_Z_EXCLUDE_DIRS[@]}"; do
    //            [ "$*" = "$exclude" ] && return
    //        done

    _Z_DATA = getenv("_Z_DATA");
    if( _Z_DATA == NULL ) {
        sprintf(datafile, "%s/.z", getenv("HOME"));
    } else {
        sprintf(datafile, "%s", _Z_DATA);
    }
    read = fopen(datafile, "r");
    if (read == NULL) return EXIT_FAILURE;

    srand(time(NULL));

    sprintf(tmpfile, "%s.%d", datafile, rand());
    write = fopen(tmpfile, "w");
    if (write == NULL) return EXIT_FAILURE;

    sprintf(agedfile, "%s.%d", datafile, rand());
    aged = fopen(agedfile, "w");
    if (aged == NULL) return EXIT_FAILURE;

    while (fgets(line, sizeof line, read) != NULL) {
        sscanf(line, "%[^|]|%f|%d\n", pth, &rank, &timestamp);
        if (stat(pth, &s) == 0 && s.st_mode & S_IFDIR ) {
            rank_sum += rank;
            if (strcmp(pth, argv[1]) == 0) {
                fprintf(write, "%s|%f|%d\n", pth, rank + 1, (int) epoch);
                fprintf(aged, "%s|%f|%d\n", pth, rank * 1, (int) epoch);
                found = 1;
            } else if (rank >= 1) {
                fprintf(write, "%s", line);
                fprintf(aged, "%s|%f|%d\n", pth, rank * MULTIPLIER, timestamp);
            }
        }
    }
    if (!found) {
        fprintf(write, "%s|1|%d\n", argv[1], (int) epoch);
        fprintf(aged, "%s|1|%d\n", argv[1], (int) epoch);
    }

    fclose(read);
    fclose(write);
    fclose(aged);

    if (rank_sum > RANK_SUM_MAX) {
        if (rename(agedfile, datafile) != 0) return EXIT_FAILURE;
        if (unlink(tmpfile) != 0) return EXIT_FAILURE;
    } else {
        if (rename(tmpfile, datafile) != 0) return EXIT_FAILURE;
        if (unlink(agedfile) != 0) return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
