#include <stdio.h>
#include <stdlib.h>
#define MAX_NAME_LENGTH 100

typedef struct {
    char name[MAX_NAME_LENGTH];
    float price;
} Product;

int comparePrices(const void *a, const void *b) {
    const Product *productA = (const Product *)a;
    const Product *productB = (const Product *)b;

    if (productA->price < productB->price) {
        return -1;
    } else if (productA->price > productB->price) {
        return 1;
    } else {
        return 0;
    }
}
int main() {
    char *inputFile = "input.txt";
    char *outputFile = "output.txt";
    FILE *file = fopen(inputFile, "r");
    if (file == NULL) {
        printf("error\n");
        return 1;
    }
    int size;
    fscanf(file, "%d", &size);
    Product *products = (Product *)malloc(size * sizeof(Product));
    for (int i = 0; i < size; i++) {
        fscanf(file, "%s %f", products[i].name, &products[i].price);
    }
    fclose(file);
    printf("before:\n");
    for (int i = 0; i < size; i++) {
        printf("product: %s, price: %.2f\n", products[i].name, products[i].price);
    }
    qsort(products, size, sizeof(Product), comparePrices);
    printf("after:\n");
    for (int i = 0; i < size; i++) {
        printf("product: %s, price: %.2f\n", products[i].name, products[i].price);
    }
    FILE *file2 = fopen(outputFile, "w");
    if (file2 == NULL) {
        printf("error \n");
        return 1;
    }
    for (int i = 0; i < size; i++) {
        fprintf(file, "product: %s, price: %.2f\n", products[i].name, products[i].price);
    }
    fclose(file);
    printf("sorted written to '%s'.\n", outputFile);
    free(products);
    return 0;
}