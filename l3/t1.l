%{
#include <stdio.h>
void exit_ctrlq();
void Errors();
%}

%%
[0-9]+         {printf("Integer number");}
[a-zA-Z]       {printf("Letter");}
[a-zA-Z]+      {printf("Words");}
[0-9]+\.[0-9]  {printf("Float/double number");}
"+"            {printf("Summ");}
"-"            {printf("Subtraction");}
"*"            {printf("Multiplication");}
"/"            {printf("Division");}
[ \t]+          ;
.              { Errors();}
":exit"        {exit_ctrlq();}
%%

void Errors(){
    printf("Something went wrong");
}

void exit_ctrlq(){
    exit(0);
}
