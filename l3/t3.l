%{
#include "parser.tab.h"
%}

%%

[0-9]+(\.[0-9]+)?   { yylval.number = atof(yytext); return NUMBER; }
[+\-*/()]           { return yytext[0]; }
\n                  { return EOL; }
[ \t]               { /* игнорировать пробелы и табуляцию */ }
.                   { fprintf(stderr, "Нераспознанный символ: %s\n", yytext); }

%%
