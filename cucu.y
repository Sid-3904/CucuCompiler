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
char exp[400];
%}

%token INT CHAR WHILE IF ELSE RETURN EQ LTEQ GTEQ NEQ

%union{
    int num;
    char *str;
}

%type <str> expression
%type <str> boolean_expr

%token <num> NUM
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
                    | INT ID '=' expression ';'        {fprintf(parser, "VARIABLE-DECLARATION\nDatatype : int\nIdentifier : %s\nAssignment : =\n%s", $2, $4);}
                    | CHAR ID ';'               {fprintf(parser, "VARIABLE-DECLARATION\nDatatype : char*\nIdentifier : %s\n", $2);}
                    | CHAR ID '=' STRING ';'     {fprintf(parser, "VARIABLE-DECLARATION\nDatatype : char*\nIdentifier : %s\nAssignment : =\nValue : %s", $2, $4);}
                    ;

function_definition : INT ID '(' func_args ')' func_body       {fprintf(parser, "FUNCTION-DEFINITION\nDatatype : int\nIdentifier : %s\n", $2);}
    | INT ID '(' ')' func_body                      {fprintf(parser, "FUNCTION-DEFINITION\nDatatype : int\nIdentifier : %s\n", $2);}
    | CHAR ID '(' func_args ')' func_body           {fprintf(parser, "FUNCTION-DEFINITION\nDatatype : char *\nIdentifier : %s\n", $2);}
    | CHAR ID '(' ')' func_body                     {fprintf(parser, "FUNCTION-DEFINITION\nDatatype : char *\nIdentifier : %s\n", $2);}
    ;

function_declaration : INT ID '(' func_args ')' ';'           {fprintf(parser, "FUNCTION-DECLARATION\nDatatype : int\n");}
    | INT ID '(' ')' ';'                           {fprintf(parser, "FUNCTION-DECLARATION\nDatatype : int\n");}
    | CHAR ID '(' func_args ')' ';'                {fprintf(parser, "FUNCTION-DECLARATION\nDatatype : char *\n");}
    | CHAR ID '(' ')' ';'                          {fprintf(parser, "FUNCTION-DECLARATION\nDatatype : char *\n");}
    ;

func_args : INT ID                   {fprintf(parser, "Datatype : int\nFunction Arguments Passed Above\n");}
    | INT ID ',' func_args
    | CHAR ID                        {fprintf(parser, "Datatype : char *\nFunction Arguments Passed Above\n");}
    | CHAR ID ',' func_args
    ;

func_body : '{' stmt_list '}'
    | stmt
    ;

stmt_list : stmt_list stmt
    | stmt
    ;

stmt : assign_stmt
    | func_call             {fprintf(parser, "Function call ends \n");}
    | return_stmt           {fprintf(parser, "Return statement \n");}
    | condition             {fprintf(parser, "If Condition Ends \n");}
    | loop                  {fprintf(parser, "While Loop Ends \n");}
    | variable_declaration
    ;

assign_stmt : expression '=' expression ';'
    ;

return_stmt : RETURN ';'
    | RETURN expression ';'
    ;

func_call : ID '(' ')' ';'
    | ID '(' expression
    ;

condition : IF '(' boolean_expr ')' func_body
    | IF '(' boolean_expr ')' func_body ELSE func_body
    ;

loop: WHILE '(' boolean_expr ')' func_body
    ;

boolean_expr: boolean_expr '<' boolean_expr               {strcat($$, $1);strcat($$, "Operator : < \n");strcat($$, $3);}
    | boolean_expr '>' boolean_expr            {strcat($$, $1);strcat($$, "Operator : > \n");strcat($$, $3);}
    | boolean_expr EQ boolean_expr           {strcat($$, $1);strcat($$, "Operator : == \n");strcat($$, $3);}
    | boolean_expr NEQ boolean_expr       {strcat($$, $1);strcat($$, "Operator : != \n");strcat($$, $3);}
    | boolean_expr LTEQ boolean_expr         {strcat($$, $1);strcat($$, "Operator : <= \n");strcat($$, $3);}
    | boolean_expr GTEQ boolean_expr      {strcat($$, $1);strcat($$, "Operator : >= \n");strcat($$, $3);}
    | expression                            {strcat($$, $1);}
    ;

expression: '(' expression ')'              {strcat($$, $2);}
    | expression '+' expression            {strcat($$, $1);strcat($$, "Operator : + \n");strcat($$, $3);}
    | expression '-' expression           {strcat($$, $1);strcat($$, "Operator : - \n");strcat($$, $3);}
    | expression '*' expression             {strcat($$, $1);strcat($$, "Operator : * \n");strcat($$, $3);}
    | expression '/' expression             {strcat($$, $1);strcat($$, "Operator : / \n");strcat($$, $3);}
    | NUM                                   {   
                                                char s[20]="";
                                                itoa($1, s, 10);
                                                if($$==NULL) strcat($$, "\nValue : ");
                                                else $$ = strdup("\nValue : ");
                                                strcat($$, s);
                                                strcat($$, "\n");
                                            }
    | ID                                    {   
                                                if($$==NULL) strcat($$, "\nIdentifier : ");
                                                else $$ = strdup("\nIdentifier : ");
                                                strcat($$, $1);
                                                strcat($$, "\n");
                                            }
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