#include <stdio.h>

int main(int argc, char *argv[]) { 
    char *filename = argv[1];
    FILE *file = fopen(filename, "r");
    char ch;
    while ((ch = fgetc(file)) != EOF) {
        putchar(ch);
    }
    fclose(file);
    return 0;
}