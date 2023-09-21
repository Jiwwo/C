#include <stdio.h>

int main(int *argc, char *argv[]) {
    char *filename = argv[1];
    FILE *fptr = fopen(filename, "r");
    char myString[100];
    fgets(myString, 100, fptr);
    printf("%s", myString);
    fclose(fptr); 
}
