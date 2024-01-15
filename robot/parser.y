%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "parser.tab.h"

int yylex(void);

extern int yylineno;
extern FILE* yyin;
extern FILE* yyout;

void yyerror(char *str);
int yywrap(){
    return 1;
} 

struct ast{
    int nodetype;
    struct ast *l;
    struct ast *r;
};

struct numval{
    int nodetype;
    int number;
};

struct flow{
    int nodetype;
    struct ast *cond;
    struct ast *tl;
    struct ast *el;
};

struct ast *newAst(int nodetype, struct ast *l, struct ast *r);
struct ast *newNum(int integer);
struct ast *newFlow(int nodetype, struct ast *cond, struct ast *tl, struct ast *el);
int evaluate(struct ast *);
void treeFree(struct ast *);
int count = 0;
int robot[2];
int area[2];
void robot_funcs(int checkOperation, int step);
int area_check(int step);
void move(int step);
int root;
void rep_colour(int checkColor);
int temp_colour = 0;
void paint(int step);
int subPaint(int x1, int y1, int x2, int y2, int x, int y);
int *paint_arr = NULL;
int paint_row;

%}

%union{
    struct ast *a;
    int ivalue;
}

%token OB CB FCB FOB COMMA SEMICOLON
%token IF ELSE WHILE
%token AREA IS TRUE
%token UP DOWN LEFT RIGHT
%token PAINT COLOUR NOTHING
%token RED GREEN BLUE
%token <ivalue> INTEGER
%type <a> command condition else action base move color operation lenth

%%

commands:
| commands command { evaluate($2); treeFree($2); }
;

command: IF OB condition CB FOB action FCB else { $$ = newFlow('I', $3, $6, $8); }
| IF OB condition CB FOB action FCB { $$ = newFlow('I', $3, $6, NULL);  }
| WHILE OB condition CB FOB action FCB { $$ = newFlow('W', $3, $6, NULL);  }
| action { $$ = newAst('a', $1, NULL); }
;

condition: AREA IS TRUE move { $$ = newAst('c', $4, NULL); }
;

action: COLOUR OB color CB SEMICOLON { $$ = newAst('o', $3, NULL); }
| move base { $$ = newAst('m', $1, $2); }
;

else: ELSE FOB action FCB { $$ = newAst('e', $3, NULL); }
;

color: RED { $$ = newAst('R', NULL, NULL); }
| GREEN { $$ = newAst('G', NULL, NULL); }
| BLUE { $$ = newAst('B', NULL, NULL); }
;

move: LEFT { $$ = newAst('l', NULL, NULL); }
| RIGHT { $$ = newAst('r', NULL, NULL); }
| UP { $$ = newAst('u', NULL, NULL); }
| DOWN { $$ = newAst('d', NULL, NULL); }
;

base: OB operation COMMA lenth CB SEMICOLON { $$ = newAst('b', $2, $4); }
;

operation: NOTHING { $$ = newAst('n', NULL, NULL);  }
| PAINT { $$ = newAst('s', NULL, NULL);  }
;

lenth: INTEGER { $$ = newNum($1); }

%%

int main(void){
    char *commandFileName = "cmd.txt";
    FILE* commandFile = fopen(commandFileName, "r");
    if (commandFile == NULL){
        fprintf(yyout, "Can't open file %s", commandFileName);
        exit(1);
    }
    char *areaFileName = "area.txt";
    FILE* areaFile = fopen(areaFileName, "r");
    if (areaFile == NULL){
        fprintf(yyout, "Can't open file %s", areaFileName);
        exit(1);
    }
    fseek(areaFile, 0, SEEK_SET);
    fscanf(areaFile, "%d ", &area[0]);
    fscanf(areaFile, "%d", &area[1]);
    fscanf(areaFile, "%d ", &robot[0]);
    fscanf(areaFile, "%d", &robot[1]);
    char *reportFileName = "result.txt";
    FILE* reportFile = fopen(reportFileName, "w");
    yyin = commandFile;
    yyout = reportFile;
    yyparse();
    fclose(yyin);
    fclose(areaFile);
    fclose(yyout);
    free(paint_arr);

    return 0;
}

void yyerror(char *str){
    count++;
    fprintf(yyout ,"error: %s in line %d\n", str, yylineno);
    exit(1);
}

struct ast *newAst(int nodetype, struct ast *l, struct ast *r){
    struct ast *a = malloc(sizeof(struct ast));

    if (!a){
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->l = l;
    a->r = r;
    return a;
}

struct ast *newNum(int i){
    struct numval *a = malloc(sizeof(struct numval));

    if (!a){
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = 'K';
    a->number = i;
    return (struct ast *)a;
}

struct ast *newFlow(int nodetype, struct ast *cond, struct ast *tl, struct ast *el){
    struct flow *a = malloc(sizeof(struct flow));

    if(!a) {
        yyerror("out of space");
        exit(0);
    }
    a->nodetype = nodetype;
    a->cond = cond;
    a->tl = tl;
    a->el = el;
    return (struct ast *)a;
}

int evaluate(struct ast *a){
    int value;
    int checkOperation;
    int checkColor;

    switch(a->nodetype){
        case 'K': value = ((struct numval *)a)->number; break;
        case 'a':
            evaluate(a->l);
            break;
        case 'c':
            root = evaluate(a->l);
            value = area_check(1);
            break;
        case 'e':
            evaluate(a->l);
            break;
        case 'o':
            count++;
            checkColor = evaluate(a->l);
            rep_colour(checkColor);
            temp_colour = checkColor;
            break;
        case 'm':
            root = evaluate(a->l);
            evaluate(a->r);
            break;
        case 'b':
            count++;
            checkOperation = evaluate(a->l);
            value = evaluate(a->r);
            robot_funcs(checkOperation, value);
            break;    
        case 'n':
            value = 'n';
            break;
        case 's':
            value = 's';
            break;   
        case 'l':
            value = 'l';
            break;
        case 'r':
            value = 'r';
            break;                 
        case 'u':
            value = 'u';
            break;     
        case 'd':
            value = 'd';
            break;
        case 'R':
            value = 'R';
            break;                 
        case 'G':
            value = 'G';
            break;     
        case 'B':
            value = 'B';
            break; 
        case 'I':
            if(evaluate(((struct flow *)a)->cond) == 't') {
                if(((struct flow *)a)->tl) {
                    evaluate(((struct flow *)a)->tl);
                } 
                else{
                    value = 'f';
                }
            }
            else {
                if(((struct flow *)a)->el) {
                    evaluate(((struct flow *)a)->el);
                } 
                else {
                    value = 'f';
                }		
            }
            break;
        case 'W':
            value = 'f';

            if(((struct flow *)a)->tl) {
                while(evaluate(((struct flow *)a)->cond) == 't'){
                    evaluate(((struct flow *)a)->tl);
                }
            }
            break;
    }
    return value;
}

void rep_colour(int checkColor){
    if (checkColor == temp_colour){
        switch(checkColor){
            case 'R':
                fprintf(yyout, "Red color is already selected\n");
                break;
            case 'G':
                fprintf(yyout, "Green color is already selected\n");
                break;
            case 'B':
                fprintf(yyout, "Blue color is already selected\n");
                break;
        }
    }
    else{
        switch(checkColor){
            case 'R':
                fprintf(yyout, "Red color is selected\n");
                break;
            case 'G':
                fprintf(yyout, "Green color is selected\n");
                break;
            case 'B':
                fprintf(yyout, "Blue color is selected\n");
                break;
        }
    }    
}

void robot_funcs(int checkOperation, int step){
    switch(checkOperation){
        case 'n':
            move(step);
            fprintf(yyout, "Robot moved to coordinate (%d,%d)\n", robot[0], robot[1]);
            break;
        case 's':
            paint(step);
            break;   
    }
}

int area_check(int step){
    int tempArray[2] = {robot[0], robot[1]}; 
    for (int i = 0; i < step; i++){
        switch(root){
            case 'l':
                if (tempArray[0] - 1 < 0){
                    return 'f';
                }
                break;
            case 'r':
                if (tempArray[0] + 1 > area[0]){
                    return 'f';
                }
                break;
            case 'd':
                if (tempArray[1] - 1 < 0){
                    return 'f';
                }
                break;
            case 'u':
                if (tempArray[1] + 1 > area[1]){
                    return 'f';
                }
                break;
        }
        switch(root){
            case 'l':
                tempArray[0] -= 1;
                break;
            case 'r':
                tempArray[0] += 1;
                break;
            case 'd':
                tempArray[1] -= 1;
                break;
            case 'u':
                tempArray[1] += 1;
                break;
        }
    }
    return 't';
}

void move(int step){
    switch(area_check(step)){
        case 't':
            if (root == 'l'){
                robot[0] -= step;
            }    
            if (root == 'r'){
                robot[0] += step;
            }    
            if (root == 'd'){
                robot[1] -= step;
            }    
            if (root == 'u'){
                robot[1] += step;
            }
            break; 
                case 'f':
                    if (root == 'l'){
                        fprintf(yyout, "Error: Robot is trying to move to coordinate (%d,%d) beyond the field boundaries (%d,%d)\n", robot[0] - step, robot[1], area[0], area[1]);
                        exit(0);
                    }
                    if (root == 'r'){
                        fprintf(yyout, "Error: Robot is trying to move to coordinate (%d,%d) beyond the field boundaries (%d,%d)\n", robot[0] + step, robot[1], area[0], area[1]);
                        exit(0);
                    }
                    if (root == 'd'){
                        fprintf(yyout, "Error: Robot is trying to move to coordinate (%d,%d) beyond the field boundaries (%d,%d)\n", robot[0], robot[1] - step, area[0], area[1]);
                        exit(0);
                    }
                    if (root == 'u'){
                        fprintf(yyout, "Error: Robot is trying to move to coordinate (%d,%d) beyond the field boundaries (%d,%d)\n", robot[0], robot[1] + step, area[0], area[1]);
                        exit(0);
                    }
                    break;
            }
        }

        void paint(int step){
            if (area_check(step) == 'f'){
                switch(root){
                    case 'l':
                        fprintf(yyout, "Error: Robot is trying to paint (%d,%d) (%d,%d) beyond the field boundaries (%d,%d)\n", robot[0] - step, robot[1], robot[0], robot[1], area[0], area[1]);
                        exit(0);
                        break;
                    case 'r':
                        fprintf(yyout, "Error: Robot is trying to paint (%d,%d) (%d,%d) beyond the field boundaries (%d,%d)\n", robot[0], robot[1], robot[0] + step, robot[1], area[0], area[1]);
                        exit(0);
                        break;
                    case 'd':
                        fprintf(yyout, "Error: Robot is trying to paint (%d,%d) (%d,%d) beyond the field boundaries (%d,%d)\n", robot[0], robot[1] - step, robot[0], robot[1], area[0], area[1]);
                        exit(0);
                        break;
                    case 'u':
                        fprintf(yyout, "Error: Robot is trying to paint (%d,%d) (%d,%d) beyond the field boundaries (%d,%d)\n", robot[0], robot[1], robot[0], robot[1] + step, area[0], area[1]);
                        exit(0);
                        break;
                }
            }

    int resultFirstSubPaint;
    int resultSecondSubPaint;
    int x1paint_arr;
    int y1paint_arr;
    int x2paint_arr;
    int y2paint_arr;
    for (int i = 0; i < paint_row; i++){
        x1paint_arr = *(paint_arr + i*4 + 0);
        y1paint_arr = *(paint_arr + i*4 + 1);
        x2paint_arr = *(paint_arr + i*4 + 2);
        y2paint_arr = *(paint_arr + i*4 + 3);
        switch(root){
            case 'l':
                resultFirstSubPaint = subPaint(robot[0] - step, robot[1], robot[0], robot[1], x1paint_arr, y1paint_arr);
                resultSecondSubPaint = subPaint(robot[0] - step, robot[1], robot[0], robot[1], x2paint_arr, y2paint_arr);
                if (robot[1] == y1paint_arr & robot[1] == y2paint_arr & (resultFirstSubPaint == 't' | resultSecondSubPaint == 't')){
                    fprintf(yyout, "Error: Robot cannot paint (%d,%d) (%d,%d) because it is already painted (%d,%d) (%d,%d)", robot[0] - step, robot[1], robot[0], robot[1], x1paint_arr, y1paint_arr, x2paint_arr, y2paint_arr);
                    exit(0);
                }    
                break;
            case 'r':
                resultFirstSubPaint = subPaint(robot[0], robot[1], robot[0] + step, robot[1], x1paint_arr, y1paint_arr);
                resultSecondSubPaint = subPaint(robot[0], robot[1], robot[0] + step, robot[1], x2paint_arr, y2paint_arr);
                if (robot[1] == y1paint_arr & robot[1] == y2paint_arr & (resultFirstSubPaint == 't' | resultSecondSubPaint == 't')){
                    fprintf(yyout, "Error: Robot cannot paint (%d,%d) (%d,%d) because it is already painted (%d,%d) (%d,%d)", robot[0], robot[1], robot[0] + step, robot[1], x1paint_arr, y1paint_arr, x2paint_arr, y2paint_arr);
                    exit(0);
                }    
                break;
            case 'd':
                resultFirstSubPaint = subPaint(robot[0], robot[1] - step, robot[0], robot[1], x1paint_arr, y1paint_arr);
                resultSecondSubPaint = subPaint(robot[0], robot[1] - step, robot[0], robot[1], x2paint_arr, y2paint_arr);
                if (robot[0] == x1paint_arr & robot[0] == x2paint_arr & (resultFirstSubPaint == 't' | resultSecondSubPaint == 't')){
                    fprintf(yyout, "Error: Robot cannot paint (%d,%d) (%d,%d) because it is already painted (%d,%d) (%d,%d)", robot[0], robot[1] - step, robot[0], robot[1], x1paint_arr, y1paint_arr, x2paint_arr, y2paint_arr);
                    exit(0);
                }    
                break;
            case 'u':
                resultFirstSubPaint = subPaint(robot[0], robot[1], robot[0], robot[1] + step, x1paint_arr, y1paint_arr);
                resultSecondSubPaint = subPaint(robot[0], robot[1], robot[0], robot[1] + step, x2paint_arr, y2paint_arr);
                if (robot[0] == x1paint_arr & robot[0] == x2paint_arr & (resultFirstSubPaint == 't' | resultSecondSubPaint == 't')){
                    fprintf(yyout, "Error: Robot cannot paint (%d,%d) (%d,%d) because it is already painted (%d,%d) (%d,%d)", robot[0], robot[1], robot[0], robot[1] + step, x1paint_arr, y1paint_arr, x2paint_arr, y2paint_arr);
                    exit(0);
                }   
                break;
        }
    }

    paint_row++;
    int paint_rowArray = paint_row - 1;
    paint_arr = (int*) realloc(paint_arr, (paint_row + 1) * 4 * sizeof(int));
    switch(root){
        case 'l':
            *(paint_arr + paint_rowArray * 4 + 0) = robot[0] - step;
            *(paint_arr + paint_rowArray * 4 + 1) = robot[1];
            *(paint_arr + paint_rowArray * 4 + 2) = robot[0];
            *(paint_arr + paint_rowArray * 4 + 3) = robot[1];
            robot[0] -= step;
            break;
        case 'r':
            *(paint_arr + paint_rowArray * 4 + 0) = robot[0];
            *(paint_arr + paint_rowArray * 4 + 1) = robot[1];
            *(paint_arr + paint_rowArray * 4 + 2) = robot[0] + step;
            *(paint_arr + paint_rowArray * 4 + 3) = robot[1];
            robot[0] += step;
            break;
        case 'd':
            *(paint_arr + paint_rowArray * 4 + 0) = robot[0];
            *(paint_arr + paint_rowArray * 4 + 1) = robot[1] - step;
            *(paint_arr + paint_rowArray * 4 + 2) = robot[0];
            *(paint_arr + paint_rowArray * 4 + 3) = robot[1];
            robot[1] -= step;
            break;
        case 'u':
            *(paint_arr + paint_rowArray * 4 + 0) = robot[0];
            *(paint_arr + paint_rowArray * 4 + 1) = robot[1];
            *(paint_arr + paint_rowArray * 4 + 2) = robot[0];
            *(paint_arr + paint_rowArray * 4 + 3) = robot[1] + step;
            robot[0] += step;
            break;
    }
    switch(temp_colour){
            case 'R':
                fprintf(yyout, "Robot painted the row with red (%d,%d) (%d,%d)\n",*(paint_arr + paint_rowArray * 4 + 0), *(paint_arr + paint_rowArray * 4 + 1), *(paint_arr + paint_rowArray * 4 + 2), *(paint_arr + paint_rowArray * 4 + 3));
                break;
            case 'G':
                fprintf(yyout, "Robot painted the row with green (%d,%d) (%d,%d)\n",*(paint_arr + paint_rowArray * 4 + 0), *(paint_arr + paint_rowArray * 4 + 1), *(paint_arr + paint_rowArray * 4 + 2), *(paint_arr + paint_rowArray * 4 + 3));
                break;
            case 'B':
                fprintf(yyout, "Robot painted the row with blue (%d,%d) (%d,%d)\n",*(paint_arr + paint_rowArray * 4 + 0), *(paint_arr + paint_rowArray * 4 + 1), *(paint_arr + paint_rowArray * 4 + 2), *(paint_arr + paint_rowArray * 4 + 3));
                break;
            default:
                fprintf(yyout, "Robot painted the row with white (%d,%d) (%d,%d)\n",*(paint_arr + paint_rowArray * 4 + 0), *(paint_arr + paint_rowArray * 4 + 1), *(paint_arr + paint_rowArray * 4 + 2), *(paint_arr + paint_rowArray * 4 + 3));
                break;
        }
}

int subPaint(int x1, int y1, int x2, int y2, int x, int y){
    int result = (x - x1) * (y2 - y1) - (x2 - x1) * (y - y1);
    if (result == 0){
        return 't';
    }
    return 'f';
}

void treeFree(struct ast *a){
    switch(a->nodetype){
        case 'm':
        case 'b':
            treeFree(a->r);
        case 'a':
        case 'o':
        case 'e':
            treeFree(a->l);
        case 'K':
        case 'c':
        case 'R':
        case 'G':
        case 'B':
        case 'l':
        case 'r':
        case 'u':
        case 'd':
        case 'n':
        case 's':
        case 't':
        break;

        case 'I':
        case 'W':
            free( ((struct flow *)a)->cond);
            if( ((struct flow *)a)->tl) free( ((struct flow *)a)->tl);
            if( ((struct flow *)a)->el) free( ((struct flow *)a)->el);
            break;

        default: fprintf(yyout, "internal error: free bad node %c\n",a->nodetype);
    }
}