// PROMPT_COMMAND for z.sh

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char **argv) {

    if (argv[1] == NULL) return EXIT_FAILURE;

    char * _Z_DATA;
    char datafile[PATH_MAX];
    char tmpfile[PATH_MAX];
    FILE *read;
    FILE *write;
    char line[LINE_MAX];
    char pth[PATH_MAX];
    float rank;
    int timestamp;
    struct stat s;
    time_t epoch = time(NULL);
    int found = 0;

    // Don't track $HOME
    if (strcmp(argv[1], getenv("HOME")) == 0) return EXIT_SUCCESS;

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

    while (fgets(line, sizeof line, read) != NULL) {
        sscanf(line, "%[^|]|%f|%d\n", pth, &rank, &timestamp);
        if (stat(pth, &s) == 0 && s.st_mode & S_IFDIR ) {
            if (strcmp(pth, argv[1]) == 0) {
                fprintf(write, "%s|%f|%d\n", pth, rank + 1, (int) epoch);
                found = 1;
            } else if (rank >= 1) fprintf(write, "%s", line);
        }
    }
    if (!found) fprintf(write, "%s|1|%d\n", argv[1], (int) epoch);

    fclose(read);
    fclose(write);

    if (rename(tmpfile, datafile) == 0) return EXIT_SUCCESS;

    return EXIT_FAILURE;
}
