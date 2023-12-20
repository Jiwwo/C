%{
#include <stdio.h>
#include <stdlib.h>

int reg = 0;    
%}

%%

[0-9]+ {
    int opnd = atoi(yytext); 
    reg += opnd;             
    printf("Число: %d, Текущий Результат: %d\n", opnd, reg);
}

[+*/-] {
   
    printf("Оператор: %s\n", yytext);
}

\n {
   
    printf("Конечный Результат: %d\n", reg);
    reg = 0; 
}

%%

int main() {
    yylex();
    return 0;
}
