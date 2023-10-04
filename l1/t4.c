#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    int N = 255;
    FILE *file = fopen (argv[1], "r");

    if (file == NULL){
        printf("ERROR of inputing file");
        exit(EXIT_FAILURE);
    }
    
    while(fgets(line, N, file) != NULL) { 
        printf("%s", line); 
    }
    
    fclose(file);

    return 0;
}
