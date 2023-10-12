#include <stdio.h>
int MAXSIZE = 8;
int stack[8];
int top = -1;

int isempty(){
   if(top == -1)
      return 1;
   else
      return 0;
}

int isfull(){
   if(top == MAXSIZE)
      return 1;
   else
      return 0;
}

int peek(){
   return stack[top];
}

int pop(){
   int data;
   if(!isempty()) {
      data = stack[top];
      top = top - 1;
      return data;
   } else {
      printf("Could not retrieve data, Stack is empty.\n");
   }
}

int push(int data){
   if(!isfull()) {
      top = top + 1;
      stack[top] = data;
   } else {
      printf("Could not insert data, Stack is full.\n");
   }
}

int main(){
   push(44);
   push(10);
   push(62);
   push(123);
   push(15);
   printf("Element at top of the stack: %d\n" ,peek());
   printf("Elements: \n");
   while(!isempty()) {
      int data = pop();
      printf("%d\n",data);
   }
   if (isfull()){
    printf("Stack is full\n");
   }
   else {
    printf("Stack isn't full\n");
   }
   if (isempty()){
    printf("Stack is empty\n");
   }
   else {
    printf("Stack isn't empty\n");
   }
   return 0;
}