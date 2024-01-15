%{
#include <stdio.h>
#include <stdlib.h>

struct ast {
    int nodetype;
    struct ast *l;
    struct ast *r;
};

struct numvalue {
    int nodetype;
    double num;
};

struct ast *newast(int nodetype, struct ast *l, struct ast *r);
struct ast *newnum(double d);
double expcheck(struct ast *);
void freeingmem(struct ast *);

%}

%union {
    struct ast *a;
    double d;
}

%token <d> NUM
%token SUM SUB MUL DIV
%left SUM SUB
%left MUL DIV

%type <a> expr

%%

program: expr { printf("Result: %lf\n", expcheck($1)); freeingmem($1); }

expr: NUM { $$ = newnum($1); }
    | expr SUM expr { $$ = newast('+', $1, $3); }
    | expr SUB expr { $$ = newast('-', $1, $3); }
    | expr MUL expr { $$ = newast('*', $1, $3); }
    | expr DIV expr { $$ = newast('/', $1, $3); }
    | '(' expr ')' { $$ = $2; }

%%

struct ast *newast(int nodetype, struct ast *l, struct ast *r) {
    struct ast *node = (struct ast *)malloc(sizeof(struct ast));
    if (!node) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    node->nodetype = nodetype;
    node->l = l;
    node->r = r;
    return node;
}

struct ast *newnum(double d) {
    struct numvalue *node = (struct numvalue *)malloc(sizeof(struct numvalue));
    if (!node) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    node->nodetype = 'Cons';
    node->num = d;
    return (struct ast *)node;
}

double expcheck(struct ast *node) {
    double result;
    if (!node) {
        fprintf(stderr, "Error in checking expression\n");
        exit(1);
    }
    switch (node->nodetype) {
        case 'Cons':
        result = ((struct numvalue *)node)->num;
        break;
    case '+':
        result = expcheck(node->l) + expcheck(node->r);
        break;
    case '-':
        result = expcheck(node->l) - expcheck(node->r);
        break;
    case '*':
        result = expcheck(node->l) * expcheck(node->r);
        break;
    case '/':
        result = expcheck(node->l) / expcheck(node->r);
        break;
    default:
        fprintf(stderr, "Unknown node type: %d\n", node->nodetype);
        exit(1);
    }
    return result;
}

void freeingmem(struct ast *node) {
    if (!node) return;
    if (node->nodetype == 'Cons') {
        free((struct numvalue *)node);
    } 
    else {
        freeingmem(node->l);
        freeingmem(node->r);
        free(node);
    }
}

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
