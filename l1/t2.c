#include "stdio.h"

int main()
{
    float a, b, c;
    printf("Please enter 3 numbers one by one : ");
    scanf("%f %f %f", &a, &b, &c);
    float x = (c-b)/a;
    printf("%.2f\n", x);
    return 0;
}
