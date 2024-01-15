%{
#include <stdlib.h>
#include <stdio.h>
#include "parser.tab.h"
#include <string.h>
%}

%%
[0-9]+      { yylval.ivalue = atoi(yytext); return INTEGER; }
"("         { return OB; }
")"         { return CB; }
"{"         { return FOB; } 
"}"         { return FCB; }
","         { return COMMA; }
";"         { return SEMICOLON; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"area"      { return AREA; }
"->"        { return IS; }
"true"      { return TRUE; }
"up"        { return UP; }
"down"      { return DOWN; }
"left"      { return LEFT; }
"right"     { return RIGHT; }
"red"       { return RED; }
"green"     { return GREEN; }
"blue"      { return BLUE; }
"paint"     { return PAINT; }
"colour"    { return COLOUR; }
"nothing"   { return NOTHING; }
[ \t\n]+  { /* Ignore whitespace. */ }
.         { printf("Unrecognized character %c\n", *yytext); }
%%