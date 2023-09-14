#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    char *filename = argv[1];
    char *info = argv[2];
    FILE *file = fopen(filename, "r+");
    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    fseek(file, 0, SEEK_SET);
    char *buffer = (char *) malloc(size * sizeof(char));
    fread(buffer, sizeof(char), size, file);
    fseek(file, 0, SEEK_SET);
    fwrite(info, sizeof(char), strlen(info), file);
    fwrite(buffer, sizeof(char), size, file);
    free(buffer);
    fclose(file);
    return 0;
}