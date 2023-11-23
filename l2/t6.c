#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define STACK_SIZE 100

int define(char c) {
    return (c == '+' || c == '-' || c == '*' || c == '/');
}

int prio(char op) {
    if (op == '+' || op == '-') {
        return 1;
    } else if (op == '*' || op == '/') {
        return 2;
    } else {
        return 0;
    }
}

int main() {
    char infix[STACK_SIZE];
    printf("type infix exp\n");
    scanf("%s",infix);
    char postfix[STACK_SIZE];
    char oper[STACK_SIZE];
    int top = -1;
    int i, j;
    for (i = 0, j = 0; infix[i] != '\0'; i++) {
        char c = infix[i];
        if (isdigit(c)) {
            postfix[j++] = c;
        } else if (c == '(') {
            oper[++top] = c;
        } else if (c == ')') {
            while (top >= 0 && oper[top] != '(') {
                postfix[j++] = oper[top--];
            }
            if (top >= 0 && oper[top] == '(') {
                top--;
            }
        } else if (define(c)) {
            while (top >= 0 && prio(oper[top]) >= prio(c)) {
                postfix[j++] = oper[top--];
            }
            oper[++top] = c;
        }
    }
    while (top >= 0) {
        postfix[j++] = oper[top--];
    }
    postfix[j] = '\0';
    printf("infix: %s\n", infix);
    printf("postfix: %s\n", postfix);
    return 0;
} 
//presentation 3 recursive 