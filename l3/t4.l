%{
#include <stdio.h>
#include <stdlib.h>
#include "lab3_4.tab.h"
void Errors();
%}

%%

[0-9]+(\.[0-9]+)?   { yylval.d = atof(yytext); return NUM; }
[(){}]              { return yytext[0]; }
[*]                 {return MUL; }
[/]                 {return DIV; }
[+]                 {return SUM; }
[-]                 {return SUB; }
\n                  {return yywrap(); }
[ \t]               {/* ignore whitespace */}
.                   { Errors(); }

%%

void Errors(){
    printf("Something went wrong");
}

int yywrap() {
return 0;
}
