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

variable_declaration: INT ID ';'         {fprintf(parser, "VARIABLE-DECLARATION\nDatatype : int\nIdentifier : %s\n", $2);}
                    | INT ID '=' expression ';'        {fprintf(parser, "VARIABLE-DECLARATION\nDatatype : int\nIdentifier : %s\nAssignment : =\n%s\n", $2, exp);strcpy(exp, "")}
                    | CHAR ID ';'               {fprintf(parser, "VARIABLE-DECLARATION\nDatatype : char*\nIdentifier : %s\n", $2);}
                    | CHAR ID '=' STRING ';'     {fprintf(parser, "VARIABLE-DECLARATION\nDatatype : char*\nIdentifier : %s\nAssignment : =\nValue : %s\n", $2, $4);}
                    ;

function_definition : INT ID '(' func_args ')' func_body       {fprintf(parser, "FUNCTION-DEFINITION\nDatatype : int\nIdentifier : %s\n%s%s\n", $2, args, body);strcpy(args, "");strcpy(args, "");}
    | INT ID '(' ')' func_body                      {fprintf(parser, "FUNCTION-DEFINITION\nDatatype : int\nIdentifier : %s\n%s\n", $2, body);strcpy(args, "");}
    | CHAR ID '(' func_args ')' func_body           {fprintf(parser, "FUNCTION-DEFINITION\nDatatype : char *\nIdentifier : %s\n%s%s\n", $2, args, body);strcpy(args, "");strcpy(args, "");}
    | CHAR ID '(' ')' func_body                     {fprintf(parser, "FUNCTION-DEFINITION\nDatatype : char *\nIdentifier : %s\n%s\n", $2, body);strcpy(args, "");}
    ;

function_declaration : INT ID '(' func_args ')' ';'           {fprintf(parser, "FUNCTION-DECLARATION\nDatatype : int\nIdentifier : %s\n%s", $2, args);strcpy(args, "");}
    | INT ID '(' ')' ';'                           {fprintf(parser, "FUNCTION-DECLARATION\nDatatype : int\nIdentifier : %s\n", $2);}
    | CHAR ID '(' func_args ')' ';'                {fprintf(parser, "FUNCTION-DECLARATION\nDatatype : char *\nIdentifier : %s\n%s", $2, args);strcpy(args, "");}
    | CHAR ID '(' ')' ';'                          {fprintf(parser, "FUNCTION-DECLARATION\nDatatype : char *\nIdentifier : %s\n", $2);}
    ;

func_args : INT ID                   {strcat(args, "function argument(Datatype: int): ");strcat(args, $2);strcat(args, "\n");}
    | INT ID ',' func_args          {strcat(args, "function argument(Datatype: int): ");strcat(args, $2);strcat(args, "\n");}
    | CHAR ID                        {strcat(args, "function argument(Datatype: char*): ");strcat(args, $2);strcat(args, "\n");}
    | CHAR ID ',' func_args         {strcat(args, "function argument(Datatype: char*): ");strcat(args, $2);strcat(args, "\n");}
    ;

func_body : '{' stmt_list '}'
    | stmt
    ;

stmt_list : stmt_list stmt
    | stmt
    ;

stmt : assign_stmt
    | func_call
    | return_stmt
    | condition
    | loop
    | variable_declaration
    ;

assign_stmt : ID '=' expression ';' {strcat(body, "ASSIGNMENT\nIdentifier: "); strcat(body, $1); strcat(body, "\n"); strcat(body, exp); strcpy(exp, "");}
    ;

return_stmt : RETURN ';'        {strcat(body, "RETURN\n");}
    | RETURN expression ';'     {strcat(body, exp);strcpy(exp, "");strcat(body, " AND RETURN\n");}
    ;

func_call : ID '(' ')' ';'      {strcat(body, "FUNCTION-CALL\nIdentifier: ");strcat(body, $1);strcat(body, "\n");}
    | ID '(' expression ')' ';' {strcat(body, "FUNCTION-CALL\nIdentifier: ");strcat(body, $1);strcat(body, "\n");strcat(body, exp);strcpy(exp, "");}
    ;

condition : IF '(' boolean_expr ')' func_body   {strcat(body, "IF-CONDITION\n"); strcat(body, exp);strcpy(exp, "");}
    | IF '(' boolean_expr ')' func_body ELSE func_body  {strcat(body, "IF-ELSE CONDITION\nCondition: \n"); strcat(body, exp);strcpy(exp, "");}
    ;

loop: WHILE '(' boolean_expr ')' func_body      {strcat(body, "WHILE-LOOP\nCondition: \n"); strcat(body, exp);strcpy(exp, "");}
    ;

boolean_expr: boolean_expr '<' boolean_expr               {strcat(exp, "Operator : < \n");}
    | boolean_expr '>' boolean_expr            {strcat(exp, "Operator : > \n");}
    | boolean_expr EQ boolean_expr           {strcat(exp, "Operator : == \n");}
    | boolean_expr NEQ boolean_expr       {strcat(exp, "Operator : != \n");}
    | boolean_expr LTEQ boolean_expr         {strcat(exp, "Operator : <= \n");}
    | boolean_expr GTEQ boolean_expr      {strcat(exp, "Operator : >= \n");}
    | expression                            
    ;

expression: '(' expression ')'              
    | expression '+' expression            {strcat(exp, "Operator : + \n");}
    | expression '-' expression           {strcat(exp, "Operator : - \n");}
    | expression '*' expression             {strcat(exp, "Operator : * \n");}
    | expression '/' expression             {strcat(exp, "Operator : / \n");}
    | NUM                                   {strcat(exp, "Value : ");strcat(exp, $1);strcat(exp, "\n");}
    | ID                                    {strcat(exp, "Identifier : ");strcat(exp, $1);strcat(exp, "\n");}
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