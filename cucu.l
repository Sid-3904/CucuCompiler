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

"if"                    {fprintf(lexer, "IF\n"); return IF;}
"else"                  {fprintf(lexer, "ELSE\n"); return ELSE;}
"while"                 {fprintf(lexer, "WHILE\n"); return WHILE;}
"return"                {fprintf(lexer, "RETURN\n"); return RETURN;}



"int"                   {fprintf(lexer, "TYPE : int\n"); return INT;}
"char *"                {fprintf(lexer, "TYPE : char *\n"); return CHAR;}
[A-Za-z][A-Za-z0-9_]*   {fprintf(lexer, "ID : %s\n", yytext); yylval.str=strdup(yytext); return ID;}
\"[A-Za-z0-9_ ]*\"      {fprintf(lexer, "TYPE : string %s\n", yytext); yylval.str=strdup(yytext); return STRING;}
([1-9][0-9]*|0)         {fprintf(lexer, "NUM : %s\n", yytext); yylval.str=strdup(yytext); return NUM;}



"+"                     {fprintf(lexer, "PLUS : +\n"); return *yytext;}
"-"                     {fprintf(lexer, "MINUS : +\n"); return *yytext;}
"*"                     {fprintf(lexer, "MUL : *\n"); return *yytext;}
"/"                     {fprintf(lexer, "DIV : /\n"); return *yytext;}
"="                     {fprintf(lexer, "ASSIGN : =\n"); return *yytext;}
">"                     {fprintf(lexer, "GTR_THAN : >\n"); return *yytext;}
"<"                     {fprintf(lexer, "LS_THAN : <\n"); return *yytext;}
";"                     {fprintf(lexer, "SEMI : ;\n"); return *yytext;}
","                     {fprintf(lexer, "COMMA : ,\n"); return *yytext;}
\(                      {fprintf(lexer, "L_RD_BRACKET : (\n"); return *yytext;}
\)                      {fprintf(lexer, "R_RD_BRACKET : )\n"); return *yytext;}
\{                      {fprintf(lexer, "L_CL_BRACKET : {\n"); return *yytext;}
\}                      {fprintf(lexer, "R_CL_BRACKET : }\n"); return *yytext;}
\[                      {fprintf(lexer, "L_SQ_BRACKET : [\n"); return *yytext;}
\]                      {fprintf(lexer, "R_SQ_BRACKET : ]\n"); return *yytext;}



"=="                    {fprintf(lexer, "EQL : ==\n"); return EQ;}
"<="                    {fprintf(lexer, "LTEQ : <=\n"); return LTEQ;}
">="                    {fprintf(lexer, "GTEQ : >=\n"); return GTEQ;}
"!="                    {fprintf(lexer, "NEQ : !=\n"); return NEQ;}



\/\*(.|\n)*\*\/         ;   /* ignore comments */
[ \t\n]+                ;   /* ignore white spaces */



.                       {yyerror("Invalid character");}
%%

int yywrap(void){
    return 1;
}