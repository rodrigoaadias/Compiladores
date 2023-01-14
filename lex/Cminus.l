%{
#include "globals.h"
#include "util.h"
#include "scan.h"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

%option noyywrap
%%
"/*"            { char c;
                  do
                  { 
                    c = input();
                    if (c == EOF) break;
                    if (c == '\n') lineno++;
  		              if (c == '*') 
                    { 
		                  if(input() == '/')
		                  break;
		                }		
                  } while (1);
                }
"if"            return IF;
"else"          return ELSE;
"int"           return INT;
"return"        return RETURN;
"void"          return VOID;
"while"         return WHILE;
"+"				      return SOM;
"-"				      return SUB;
"*"				      return MUL;
"/"				      return DIV;
"<"             return MENOR;
"<="            return MENORIGUAL;
">"             return MAIOR;
">="            return MAIORIGUAL;
"=="            return EQ;
"!="            return NEQ;
"="				      return ASSIGN;
";"				      return PEV;
","             return VIRG;
"("				      return APR;
")"				      return FPR;
"["             return ACOL;
"]"             return FCOL;
"{"             return ACH;
"}"             return FCH;
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
.               {return ERROR;}

%%

TokenType getToken(void)
{ 
      static int firstTime = TRUE;
      TokenType currentToken;
      if (firstTime)
      { 
        firstTime = FALSE;
        lineno++;
        yyin = source;
        yyout = listing;
      }
      currentToken = yylex();
      strncpy(tokenString,yytext,MAXTOKENLEN);
      if (TraceScan) 
      {
        fprintf(listing,"\t%d: ",lineno);
        printToken(currentToken,tokenString);
      }
      return currentToken;
}
