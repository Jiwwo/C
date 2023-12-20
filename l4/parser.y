%{
#include <stdio.h>
%}

%token IF ELSE WHILE NUM EQ ASSIGN PLUS MINUS MULT DIV GT LT LBRACE RBRACE LPAREN RPAREN SEMICOLON

%%

program: statement
       | program statement

statement: if_statement
         | while_statement
         | assignment_statement
         | SEMICOLON

if_statement: IF LPAREN condition RPAREN LBRACE program RBRACE ELSE LBRACE program RBRACE

while_statement: WHILE LPAREN condition RPAREN LBRACE program RBRACE

assignment_statement: NUM ASSIGN NUM SEMICOLON

condition: expression EQ expression
         | expression GT expression
         | expression LT expression

expression: NUM
          | expression PLUS expression
          | expression MINUS expression
          | expression MULT expression
          | expression DIV expression
          | LPAREN expression RPAREN

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Parser error: %s\n", s);
}