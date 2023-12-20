%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
[0-9]+      { yylval.num = atoi(yytext); return NUM; }
"=="        { return EQ; }
"="         { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MULT; }
"/"         { return DIV; }
">"         { return GT; }
"<"         { return LT; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
";"         { return SEMICOLON; }
[ \t\n]     ; // пропуск пробелов и табуляций
.           { fprintf(stderr, "Unexpected character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}