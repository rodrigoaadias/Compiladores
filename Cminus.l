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
      case NUM:           putc(f_out, "NUM"); break;
      case ID:            putc(f_out, "ID ");  break;
      case SOM:           putc(f_out, "+ ");   break;
      case SUB:           putc(f_out, "- ");   break;
      case MUL:           putc(f_out, "* ");   break;
      case DIV:           putc(f_out, "/ ");   break;
      case IGL:           putc(f_out, " = ");  break;
      case PEV:           putc(f_out, "; \n"); break;
      case APR:           putc(f_out, "( ");   break;
      case FPR:           putc(f_out, ") ");   break;
      case ERR:           putc(f_out, "ERR "); break;
      case IF:            putc(f_out, "if"); break;
      case ELSE:          putc(f_out, "else"); break;
      case INT:           putc(f_out, "int"); break;
      case RETURN:        putc(f_out, "return"); break;
      case VOID:          putc(f_out, "void"); break;
      case WHILE:         putc(f_out, "while"); break;
      case MENOR:         putc(f_out, "<"); break;
      case MENORIGUAL:    putc(f_out, "<="); break;
      case MAIOR:         putc(f_out, ">"); break;
      case MAIORIGUAL:    putc(f_out, ">="); break;
      case EQUAL:         putc(f_out, "=="); break;
      case NOTEQUAL:      putc(f_out, "!="); break;
      case VIRG:          putc(f_out, ","); break;
      case ACOL:          putc(f_out, "["); break;
      case FCOL:          putc(f_out, "]"); break;
      case ACH:           putc(f_out, "{"); break;
      case FCH:           putc(f_out, "}"); break;
      case STARTCOMM:     putc(f_out, "/*"); break;
      case ENDCOMM:       putc(f_out, "*/"); break;
      case NEWLINE:       putc(f_out, "\n"); break;
      case SPACE:         putc(f_out, " "); break;
    }
  }
  fclose(f_out);
  return(0);
}

