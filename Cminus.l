%{
#include "Cminus.tab.h"
extern YYSTYPE yylval;
void abrirArq();

%}

DIGITO [0-9]
LETRA [a-zA-Z]
OUTRO [^0-9a-zA-Z;/=\-"+""*""("")""[""]""{""}"<>,!]
WHITESPACE [ \t]+

%%

"if"            return IF;
"else"          return ELSE;
"int"           return INT;
"return"        return RETURN;
"void"          return VOID;
"while"         return WHILE;
{DIGITO}+			  return NUM;
{LETRA}+	      return ID;
"+"				      return SOM;
"-"				      return SUB;
"*"				      return MUL;
"/"				      return DIV;
"<"             return MENOR;
"<="            return MENORIGUAL;
">"             return MAIOR;
">="            return MAIORIGUAL;
"=="            return EQUAL;
"!="            return NOTEQUAL;
"="				      return IGL;
";"				      return PEV;
","             return VIRG;
"("				      return APR;
")"				      return FPR;
"["             return ACOL;
"]"             return FCOL;
"{"             return ACH;
"}"             return FCH;
"/*"            return STARTCOMM;
"*/"            return ENDCOMM;
<<EOF>>         return FIM;
{WHITESPACE}+   {}
"\n"            return NEWLINE;
.		            return ERR;
%%

void abrirArq()
{
  yyin = fopen("entrada.txt", "r");
}

