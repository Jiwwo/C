%option noyywrap
%{
#include <stdio.h>
%}

%%

[0-9]+      { printf("Token: Num - %s\n", yytext); }
[a-zA-Z]+   { printf("Token: String - %s\n", yytext); }
[+-/*]      { printf("Token: Operand - %s\n", yytext); }
.           { printf("Token: Unrecognized symbol - %s\n", yytext); }

%%

int main(void) {
    yylex();
    return 0;
}