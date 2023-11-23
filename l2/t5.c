#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

struct Node {
    int data;
    struct Node* next;
};

struct Stack {
    struct Node* top;
};

struct Node* createNode(int data) {
    struct Node* newNode = (struct Node*)malloc(sizeof(struct Node));
    if (newNode == NULL) {
        printf("Error of getting memory for node\n");
        exit(EXIT_FAILURE);
    }
    newNode->data = data;
    newNode->next = NULL;
    return newNode;
}

struct Stack* createStack() {
    struct Stack* newStack = (struct Stack*)malloc(sizeof(struct Stack));
    if (newStack == NULL) {
        printf("Error of getting memory for \n");
        exit(EXIT_FAILURE);
    }
    newStack->top = NULL;
    return newStack;
}

void push(struct Stack* stack, int data) {
    struct Node* newNode = createNode(data);
    newNode->next = stack->top;
    stack->top = newNode;
}

int pop(struct Stack* stack) {
    if (stack->top == NULL) {
        printf("Stack is free, can't use pop\n");
        exit(EXIT_FAILURE);
    }
    struct Node* temp = stack->top;
    int data = temp->data;
    stack->top = temp->next;
    free(temp);
    return data;
}

int main(int argc, char const *argv[]) {
    FILE* file = fopen(argv[1], "r");

    if (file == NULL) {
        printf("Error of inputing file\n");
        return -1;
    }

    struct Stack* stack = createStack();

    char c;
    while ((c = fgetc(file)) != EOF) {
        if (isdigit(c)) {
            push(stack, c - '0');
        } else if (c == '+' || c == '-' || c == '*' || c == '/') {
            int operand2 = pop(stack);
            int operand1 = pop(stack);

            switch (c) {
                case '+':
                    push(stack, operand1 + operand2);
                    break;
                case '-':
                    push(stack, operand1 - operand2);
                    break;
                case '*':
                    push(stack, operand1 * operand2);
                    break;
                case '/':
                    push(stack, operand1 / operand2);
                    break;
            }
        }
    }

    fclose(file);

    if (stack->top != NULL) {
        int result = pop(stack);
        printf("Result: %d\n", result);
    } else {
        printf("Error stack is free\n");
    }

    free(stack);

    return 0;
}