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
{WHITESPACE}+   {}
"\n"            return NEWLINE;
.		            return ERR;
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
      case NUM:           fprintf(f_out, "NUM"); break;
      case ID:            fprintf(f_out, "ID ");  break;
      case SOM:           fprintf(f_out, "+ ");   break;
      case SUB:           fprintf(f_out, "- ");   break;
      case MUL:           fprintf(f_out, "* ");   break;
      case DIV:           fprintf(f_out, "/ ");   break;
      case IGL:           fprintf(f_out, " = ");  break;
      case PEV:           fprintf(f_out, "; \n"); break;
      case APR:           fprintf(f_out, "( ");   break;
      case FPR:           fprintf(f_out, ") ");   break;
      case ERR:           fprintf(f_out, "ERR "); break;
      case IF:            fprintf(f_out, "if"); break;
      case ELSE:          fprintf(f_out, "else"); break;
      case INT:           fprintf(f_out, "int"); break;
      case RETURN:        fprintf(f_out, "return"); break;
      case VOID:          fprintf(f_out, "void"); break;
      case WHILE:         fprintf(f_out, "while"); break;
      case MENOR:         fprintf(f_out, "<"); break;
      case MENORIGUAL:    fprintf(f_out, "<="); break;
      case MAIOR:         fprintf(f_out, ">"); break;
      case MAIORIGUAL:    fprintf(f_out, ">="); break;
      case EQUAL:         fprintf(f_out, "=="); break;
      case NOTEQUAL:      fprintf(f_out, "!="); break;
      case VIRG:          fprintf(f_out, ","); break;
      case ACOL:          fprintf(f_out, "["); break;
      case FCOL:          fprintf(f_out, "]"); break;
      case ACH:           fprintf(f_out, "{"); break;
      case FCH:           fprintf(f_out, "}"); break;
      case STARTCOMM:     fprintf(f_out, "/*"); break;
      case ENDCOMM:       fprintf(f_out, "*/"); break;
      case NEWLINE:       fprintf(f_out, "\n"); break;
      case SPACE:         fprintf(f_out, " "); break;
    }
  }
  fclose(f_out);
  return(0);
}

