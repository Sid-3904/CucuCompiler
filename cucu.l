/* Siddharth Verma */
/* 2022CSB1126  */
/* FINAL PROJECT CS202 */
/* LEXER FILE */

%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "cucu.tab.h"

FILE *lexer;
FILE *parser;

void yyerror(char *);

%}

%%

"if"                    {fprintf(lexer, "IF : if\n"); return IF;}
"else"                  {fprintf(lexer, "ELSE : else\n"); return ELSE;}
"while"                 {fprintf(lexer, "WHILE : while\n"); return WHILE;}
"return"                {fprintf(lexer, "RETURN : return\n"); return RETURN;}



"int"                   {fprintf(lexer, "TYPE : int\n"); return INT;}
"char *"                {fprintf(lexer, "TYPE : char*\n"); return CHAR;}
[A-Za-z][A-Za-z0-9_]*   {fprintf(lexer, "ID : %s\n", yytext); yylval.str=strdup(yytext); return ID;}
\"[A-Za-z0-9_ ]*\"      {fprintf(lexer, "TYPE : string"); yylval.str=strdup(yytext); return STRING;}
([1-9][0-9]*|0)         {fprintf(lexer, "NUM : %s\n", yytext); yylval.num=atoi(yytext); return NUM;}



"+"                     {fprintf(lexer, "PLUS : +\n"); return *yytext;}
"-"                     {fprintf(lexer, "MINUS : +\n"); return *yytext;}
"*"                     {fprintf(lexer, "MUL : *\n"); return *yytext;}
"/"                     {fprintf(lexer, "DIV : /\n"); return *yytext;}
"="                     {fprintf(lexer, "ASSIGN : =\n"); return *yytext;}
">"                     {fprintf(lexer, "GREATER_THAN : >\n"); return *yytext;}
"<"                     {fprintf(lexer, "LESS_THAN : <\n"); return *yytext;}
";"                     {fprintf(lexer, "SEMI : ;\n"); return *yytext;}
","                     {fprintf(lexer, "COMMA : ,\n"); return *yytext;}
\(                      {fprintf(lexer, "LEFT_BRAC : (\n"); return *yytext;}
\)                      {fprintf(lexer, "RIGHT_BRAC : )\n"); return *yytext;}
\{                      {fprintf(lexer, "LEFT_CURLY : {\n"); return *yytext;}
\}                      {fprintf(lexer, "RIGHT_CURLY : }\n"); return *yytext;}
\[                      {fprintf(lexer, "LEFT_SQBRAC : [\n"); return *yytext;}
\]                      {fprintf(lexer, "RIGHT_SQBRAC : ]\n"); return *yytext;}



"=="                    {fprintf(lexer, "COMPARE_EQUAL : ==\n"); return EQ;}
"<="                    {fprintf(lexer, "LESS_THAN_EQUAL : <=\n"); return LTEQ;}
">="                    {fprintf(lexer, "GREATER_THAN_EQUAL : >=\n"); return GTEQ;}
"!="                    {fprintf(lexer, "COMPARE_NOT_EQUAL : !=\n"); return NEQ;}



\/\*(.|\n)*\*\/         ;   /* ignore comments */
[ \t\n]+                ;   /* ignore white spaces */



.                       {yyerror("Invalid character");}
%%

int yywrap(void){
    return 1;
}