#include <stdio.h>
#include <stdlib.h>

//  AST
struct ast {
    int nodetype;
    struct ast *l;
    struct ast *r;
};

struct numval {
    int nodetype; /* тип K */
    double number;
};

// types
enum {
    NODE_ADD,
    NODE_SUB,
    NODE_MUL,
    NODE_DIV,
    NODE_NUM
};

//  new ast
struct ast *newast(int nodetype, struct ast *l, struct ast *r) {
    struct ast *node = malloc(sizeof(struct ast));
    if (!node) {
        fprintf(stderr, "Memory allocation error\n");
        exit(EXIT_FAILURE);
    }

    node->nodetype = nodetype;
    node->l = l;
    node->r = r;

    return node;
}

// new ast num
struct ast *newnum(double d) {
    struct numval *node = malloc(sizeof(struct numval));
    if (!node) {
        fprintf(stderr, "Memory allocation error\n");
        exit(EXIT_FAILURE);
    }

    node->nodetype = NODE_NUM;
    node->number = d;

    return (struct ast *)node;
}

double eval(struct ast *a) {
    double v;

    if (!a) {
        fprintf(stderr, "Error: NULL AST\n");
        exit(EXIT_FAILURE);
    }

    switch (a->nodetype) {
        case NODE_NUM:
            v = ((struct numval *)a)->number;
            break;
        case NODE_ADD:
            v = eval(a->l) + eval(a->r);
            break;
        case NODE_SUB:
            v = eval(a->l) - eval(a->r);
            break;
        case NODE_MUL:
            v = eval(a->l) * eval(a->r);
            break;
        case NODE_DIV:
            v = eval(a->l) / eval(a->r);
            break;
        default:
            fprintf(stderr, "Error: Unknown nodetype %d\n", a->nodetype);
            exit(EXIT_FAILURE);
    }

    return v;
}

// delete
void treefree(struct ast *a) {
    if (!a) return;

    if (a->nodetype == NODE_NUM) {
        free((struct numval *)a);
    } else {
        treefree(a->l);
        treefree(a->r);
        free(a);
    }
}


int main() {
    struct ast *expression = newast(NODE_ADD, newnum(2), newast(NODE_MUL, newnum(3), newnum(4)));
    double result = eval(expression);
    printf("Result: %.2f\n", result);
    treefree(expression);
    return 0;
}