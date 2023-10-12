#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void printArray(float *arr, int size) {
    for (int i = 0; i < size; i++) {
        printf("%f ", arr[i]);
    }
    printf("\n");
}

void writeArrayToFile(float *arr, int size, const char *filename) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("ERROR of openning input file\n");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < size; i++) {
        fprintf(file, "%f\n", arr[i]);
    }
    fclose(file);
}

int compareFloats(const void *a, const void *b) {
    float diff = *(float *)a - *(float *)b;
    if (diff > 0) return 1;
    if (diff < 0) return -1;
    return 0;
}

int main() {
    int size;
    printf("input array len: ");
    scanf("%d", &size);
    float *arr = (float *)malloc(size * sizeof(float));
    srand(time(0));
    for (int i = 0; i < size; i++) {
        arr[i] = (float)rand() / RAND_MAX;
    }
    printf("array of random nums:\n");
    printArray(arr, size);
    qsort(arr, size, sizeof(float), compareFloats);
    const char *filename = "output.txt";
    writeArrayToFile(arr, size, filename);
    printf("written to '%s' sorted\n", filename);
    free(arr);
    return 0;
}