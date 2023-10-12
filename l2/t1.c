#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void printArray(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int size;
    printf("input array len: ");
    scanf("%d", &size);
    int *arr = (int *)malloc(size * sizeof(int));
    srand(time(0));
    for (int i = 0; i < size; i++) {
        arr[i] = rand() % 100; 
    }
    printf("original order:\n");
    printArray(arr, size);
    char *filename = "output.txt";
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("ERROR of openning input file\n");
        exit(EXIT_FAILURE);
    }

    for (int i = size - 1; i >= 0; i--) {
        fprintf(file, "%d ", arr[i]);
    }
    fclose(file);
    printf("written to  '%s' in reversed order\n", filename);
    free(arr);
    return 0;
}