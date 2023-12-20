%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
void yyerror(const char *s);
%}

%union {
    double number; // тип для чисел
}

%token <number> NUMBER
%token EOL

%type <number> expr term factor // Указываем тип для этих нетерминалов

%%

input:
    | input line
    ;

line:
    expr EOL { printf("\n"); }
    ;

expr:
    term { $$ = $1; }
    | expr '+' term { printf("+ "); $$ = $1 + $3; }
    | expr '-' term { printf("- "); $$ = $1 - $3; }
    ;

term:
    factor { $$ = $1; }
    | term '*' factor { printf("* "); $$ = $1 * $3; }
    | term '/' factor { printf("/ "); $$ = $1 / $3; }
    ;

factor:
    NUMBER { printf("%.2f ", $1); $$ = $1; }
    | '(' expr ')' { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}
