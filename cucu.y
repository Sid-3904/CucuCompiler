%{
/* Siddharth Verma */
/* 2022CSB1126  */
/* FINAL PROJECT CS202 */
/* PARSER FILE */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *lexer;
extern FILE *parser;
extern FILE *yyin;

int yylex();
void yyerror(char *);

char exp[500]="";
char args[500]="";
char body[500]="";

%}

%token INT CHAR WHILE IF ELSE RETURN EQ LTEQ GTEQ NEQ

%union{
    int num;
    char *str;
}

%token <str> NUM
%token <str> ID
%token <str> STRING

%left '(' ')'
%left '+' '-'
%left '*' '/'

%%
program : construct program
        | construct
        |
        ;

construct: variable_declaration             {fprintf(parser, "\n");}
        | function_definition               {fprintf(parser, "\n");}
        | function_declaration              {fprintf(parser, "\n");}
        ;

variable_declaration: INT ID ';'                    {fprintf(parser, "VARIABLE-DECLARATION\ndtype-int\nvar-%s\n", $2);}
                    | INT ID '=' E ';'              {fprintf(parser, "VARIABLE-DECLARATION\ndtype-int\nvar-%s\nAssignment : =\n%s\n", $2, exp);strcpy(exp, "")}
                    | CHAR ID ';'                   {fprintf(parser, "VARIABLE-DECLARATION\ndtype-char*\nvar-%s\n", $2);}
                    | CHAR ID '=' STRING ';'        {fprintf(parser, "VARIABLE-DECLARATION\ndtype-char*\nvar-%s\nAssignment : =\nValue : %s\n", $2, $4);}
                    ;

function_definition : INT ID '(' function_arguments ')' function_body       {fprintf(parser, "FUNCTION-DEFINITION\ndtype-int\nvar-%s\n%s%s\n", $2, args, body);strcpy(args, "");strcpy(args, "");}
    | INT ID '(' ')' function_body                                          {fprintf(parser, "FUNCTION-DEFINITION\ndtype-int\nvar-%s\n%s\n", $2, body);strcpy(args, "");}
    | CHAR ID '(' function_arguments ')' function_body                      {fprintf(parser, "FUNCTION-DEFINITION\ndtype-char *\nvar-%s\n%s%s\n", $2, args, body);strcpy(args, "");strcpy(args, "");}
    | CHAR ID '(' ')' function_body                                         {fprintf(parser, "FUNCTION-DEFINITION\ndtype-char *\nvar-%s\n%s\n", $2, body);strcpy(args, "");}
    ;

function_declaration : INT ID '(' function_arguments ')' ';'            {fprintf(parser, "FUNCTION-DECLARATION\ndtype-int\nvar-%s\n%s", $2, args);strcpy(args, "");}
    | INT ID '(' ')' ';'                                                {fprintf(parser, "FUNCTION-DECLARATION\ndtype-int\nvar-%s\n", $2);}
    | CHAR ID '(' function_arguments ')' ';'                            {fprintf(parser, "FUNCTION-DECLARATION\ndtype-char *\nvar-%s\n%s", $2, args);strcpy(args, "");}
    | CHAR ID '(' ')' ';'                                               {fprintf(parser, "FUNCTION-DECLARATION\ndtype-char *\nvar-%s\n", $2);}
    ;

function_arguments : INT ID                     {strcat(args, "function argument(Datatype: int): ");strcat(args, $2);strcat(args, "\n");}
    | INT ID ',' function_arguments             {strcat(args, "function argument(Datatype: int): ");strcat(args, $2);strcat(args, "\n");}
    | CHAR ID                                   {strcat(args, "function argument(Datatype: char*): ");strcat(args, $2);strcat(args, "\n");}
    | CHAR ID ',' function_arguments            {strcat(args, "function argument(Datatype: char*): ");strcat(args, $2);strcat(args, "\n");}
    ;

function_body : '{' stmt_list '}'
    | stmt
    ;

stmt_list : stmt_list stmt
    | stmt
    ;

stmt : assignment_stmt
    | if_condition
    | while_loop
    | function_call
    | variable_declaration
    | return_statement
    ;

assignment_stmt : ID '=' E ';'      {strcat(body, "ASSIGNMENT\nvar-"); strcat(body, $1); strcat(body, "\n"); strcat(body, exp); strcpy(exp, "");}
    ;

return_statement : RETURN ';'       {strcat(body, "RETURN\n");}
    | RETURN E ';'                  {strcat(body, exp);strcpy(exp, "");strcat(body, "RETURN\n");}
    ;

function_call : ID '(' ')' ';'      {strcat(body, "FUNCTION-CALL\nvar-");strcat(body, $1);strcat(body, "\n");}
    | ID '(' E ')' ';'              {strcat(body, "FUNCTION-CALL\nvar-");strcat(body, $1);strcat(body, "\n");strcat(body, exp);strcpy(exp, "");}
    ;

if_condition : IF '(' BE ')' function_body              {strcat(body, "IF-CONDITION\n"); strcat(body, exp);strcpy(exp, "");}
    | IF '(' BE ')' function_body ELSE function_body    {strcat(body, "IF-ELSE CONDITION\nCondition: \n"); strcat(body, exp);strcpy(exp, "");}
    ;

while_loop: WHILE '(' BE ')' function_body              {strcat(body, "WHILE-LOOP\nCondition: \n"); strcat(body, exp);strcpy(exp, "");}
    ;

BE: BE '<' BE               {strcat(exp, "oper < \n");}
    | BE '>' BE             {strcat(exp, "oper > \n");}
    | BE EQ BE              {strcat(exp, "oper == \n");}
    | BE NEQ BE             {strcat(exp, "oper != \n");}
    | BE LTEQ BE            {strcat(exp, "oper <= \n");}
    | BE GTEQ BE            {strcat(exp, "oper >= \n");}
    | E                            
    ;

E: '(' E ')'              
    | E '+' E               {strcat(exp, "oper + \n");}
    | E '-' E               {strcat(exp, "oper - \n");}
    | E '*' E               {strcat(exp, "oper * \n");}
    | E '/' E               {strcat(exp, "oper / \n");}
    | NUM                   {strcat(exp, "const-");strcat(exp, $1);strcat(exp, "\n");}
    | ID                    {strcat(exp, "var-");strcat(exp, $1);strcat(exp, "\n");}
    ;

%%

void yyerror(char *s){
    printf("%s\n", s);
}

int main() {
    yyin = fopen("Sample1.cu","r");
    if(yyin == NULL) {
        printf("Input file not found.\n");
        return 0;
    }

    lexer = fopen("Lexer.txt", "w");
    if(lexer == NULL) {
        printf("Lexer file not found.\n");
        return 0;
    }

    parser = fopen("Parser.txt", "w");
    if(parser == NULL) {
        printf("Parser file not found.\n");
        return 0;
    }

    yyparse();
    return 0;
}