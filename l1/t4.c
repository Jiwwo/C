#include <stdio.h>
#include <stdlib.h>

int main()
{
    int N = 255;
    char file_name[200], line[N];
    printf("Input filename: "); 
    scanf("%s", file_name);
    FILE *file = fopen(file_name, "r"); 
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
