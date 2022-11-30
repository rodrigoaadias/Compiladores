%{
#include <stdlib.h>
#include <stdio.h>

#define NUM 300
#define ID  301
#define SOM 302
#define SUB 303
#define MUL 304
#define DIV 305
#define IGL 306
#define PEV 307
#define APR 308
#define FPR 309
#define IF 310
#define ELSE 311
#define INT 312
#define RETURN 313
#define VOID 314
#define WHILE 315
#define MENOR 316
#define MENORIGUAL 317
#define MAIOR 318
#define MAIORIGUAL 319
#define EQUAL 320
#define NOTEQUAL 321
#define VIRG 322
#define ACOL 323
#define FCOL 324
#define ACH 325
#define FCH 326
#define STARTCOMM 327
#define ENDCOMM 328
#define NEWLINE 329
#define SPACE 330
#define FIM 331
#define ERR 332

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
{WHITESPACE}+   return SPACE;
"\n"            return NEWLINE;
{OUTRO}+			  return ERR;
%%

int main(int argc, char *argv[])
{
  int token;
  FILE *f_in; 

  if (argc == 2)
  {
    if(f_in = fopen(argv[1],"r"))  yyin = f_in;
    else  perror(argv[0]);
  }
  else  yyin = stdin;
  
  FILE *f_out;
  f_out = fopen("token.txt", "w");
  while ((token=yylex())!=FIM)
  {
    switch(token)
    {
      case NUM: putc(f_out, "NUM "); break;
      case ID:  printf("ID ");  break;
      case SOM: printf("+ ");   break;
      case SUB: printf("- ");   break;
      case MUL: printf("* ");   break;
      case DIV: printf("/ ");   break;
      case IGL: printf(" = ");  break;
      case PEV: printf("; \n"); break;
      case APR: printf("( ");   break;
      case FPR: printf(") ");   break;
      case ERR: printf("ERR "); break;
    }
  }

  return(0);
}

