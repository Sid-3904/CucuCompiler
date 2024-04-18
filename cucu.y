%{
/* Siddharth Verma */
/* 2022CSB1126  */
/* FINAL PROJECT CS202 */
/* PARSER FILE */

#include <stdio.h>
#include <stdlib.h>

extern FILE *lexer;
extern FILE *parser;
extern FILE *yyin;

int yylex();
void yyerror(char *);

%}

%union{
    int num;
    char *str;
}

%token <num> NUM
%token <str> ID
%token <str> STRING

%token INT CHAR WHILE IF ELSE RETURN  EQ LTEQ GTEQ NEQ

%left '+' '-'
%left '*' '/'
%left '(' ')'

%%
program : construct program
        | construct
        |
        ;

construct: variable_declaration             {fprintf(parser, "\n");}
        | function_declaration              {fprintf(parser, "\n");}
        | function_definition               {fprintf(parser, "\n");}
        ;

variable_declaration: int ident ';'  
                    | int ident '=' expr ';'        {fprintf(parser, "Assignment : =\n");}
                    | char ident ';'               
                    | char ident '=' string ';'     {fprintf(parser, "Assignment : =\n");}
    ;

function_declaration : int ident '(' func_args ')' ';'           {fprintf(parser, "Function declared above\n\n");}
    | int ident '(' ')' ';'                           {fprintf(parser, "Function declared above\n\n");}
    | char ident '(' func_args ')' ';'                {fprintf(parser, "Function declared above\n\n");}
    | char ident '(' ')' ';'                          {fprintf(parser, "Function declared above\n\n");}
    ;

function_definition : int ident '(' func_args ')' func_body       {fprintf(parser, "Function Defined above\n\n");}
    | int ident '(' ')' func_body                      {fprintf(parser, "Function Defined above\n\n");}
    | char ident '(' func_args ')' func_body           {fprintf(parser, "Function Defined above\n\n");}
    | char ident '(' ')' func_body                     {fprintf(parser, "Function Defined above\n\n");}
    ;

func_args : int ident                   {fprintf(parser, "Function Arguments Passed Above\n\n");}
    | int ident ',' func_args
    | char ident                        {fprintf(parser, "Function Arguments Passed Above\n\n");}
    | char ident ',' func_args
    ;

int : INT       {fprintf(parser, "Datatype : int\n");}
    ;

char: CHAR     {fprintf(parser, "Datatype : char *\n");}
    ;

func_body : '{' stmt_list '}'
    | stmt
    ;

stmt_list : stmt_list stmt
    | stmt
    ;

stmt : assign_stmt
    | func_call             {fprintf(parser, "Function call ends \n\n");}
    | return_stmt           {fprintf(parser, "Return statement \n\n");}
    | condition             {fprintf(parser, "If Condition Ends \n\n");}
    | loop                  {fprintf(parser, "While Loop Ends \n\n");}
    | variable_declaration
    ;

assign_stmt : expr '=' expr ';'
    ;

return_stmt : RETURN ';'
    | RETURN expr ';'
    ;

func_call : ident '(' ')' ';'
    | ident '(' expr
    ;

condition : IF '(' bool ')' func_body
    | IF '(' bool ')' func_body ELSE func_body
    ;

loop: WHILE '(' bool ')' func_body
    ;

bool: bool '<' bool               {fprintf(parser, "Operator : < \n");}
    | bool '>' bool            {fprintf(parser, "Operator : > \n");}
    | bool EQ bool           {fprintf(parser, "Operator : == \n");}
    | bool NEQ bool       {fprintf(parser, "Operator : != \n");}
    | bool LTEQ bool         {fprintf(parser, "Operator : <= \n");}
    | bool GTEQ bool      {fprintf(parser, "Operator : >= \n");}
    | expr
    ;

ident : ID      {fprintf(parser, "Varibale : %s \n", $1);}
      ;

number : NUM    {fprintf(parser, "Value : %d \n", $1);}
       ;

string : STRING {fprintf(parser, "Value : %s \n", $1);}
       ;

expr: '(' expr ')'
    | expr '+' expr            {fprintf(parser, "Operator : + \n");}
    | expr '-' expr           {fprintf(parser, "Operator : - \n");}
    | expr '*' expr             {fprintf(parser, "Operator : * \n");}
    | expr '/' expr             {fprintf(parser, "Operator : / \n");}
    | number                    
    | ident
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