#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *inputFile = fopen(argv[1], "r");
    if (inputFile == NULL){
        printf("ERROR of openning input file\n");
        exit(EXIT_FAILURE);
    }
    const int N = 255;
    char line[N], append_text[10000];
    FILE *test_file = fopen("t1test.txt", "w");
    printf("Введите данные который хотите записать в файл:\n");
    fgets(append_text, 100, stdin);
    fputs(append_text, test_file); 
    fputs("\n", test_file);
    while(fgets(line, N, inputFile) != NULL) { 
        
        fputs(line, test_file); 
    }
    fclose(inputFile);
    fclose(test_file);
}