%{
//GLC para gerar parser para linguagem C-
#include <stdio.h>
%token YYDEBUG 0    //Para exibir na tela os passos da análise sintática quando o parser é executado
void yyerror(char *);
extern "C"
{
  int yylex(void);
  void abrirArq();
}
%}

%start entrada
%token NUM 
%token ID  
%token SOM 
%token SUB 
%token MUL 
%token DIV 
%token IGL 
%token PEV 
%token APR 
%token FPR 
%token IF 
%token ELSE 
%token INT 
%token RETURN 
%token VOID 
%token WHILE 
%token MENOR 
%token MENORIGUAL 
%token MAIOR 
%token MAIORIGUAL 
%token EQUAL 
%token NOTEQUAL 
%token VIRG 
%token ACOL 
%token FCOL 
%token ACH 
%token FCH 
%token STARTCOMM 
%token ENDCOMM 
%token NEWLINE 
%token SPACE 
%token FIM 
%token ERR 

//Para mostrar o valor semântico to token quando for debugar o parser
%printer { fprintf (yyoutput, "’%d’", $$); } NUM

%%

entrada :	/* entrada vazia */
	| 	entrada programa ;
programa :	declaracao-lista ;
declaracao-lista :	declaracao-lista declaracao | declaracao ;
declaracao	:	var-declaracao | fun-declaracao ;
var-declaracao : tipo-especificador ID |
				 tipo-especificador ID [ NUM ] ;
tipo-especificador	:	INT | VOID ;
fun-declaracao : tipo-especificador ID ( params ) composto-decl ;
params : param-lista | VOID;
param-lista : param-lista,param | param ;
param : tipo-especificador ID | tipo-especificador ID [ ] ; 

%%

int main()
{
  extern int yydebug;
  yydebug = 1;

  printf("\nParser em execução...\n");
  abrirArq();
  return yyparse();
}

void yyerror(char * msg)
{
  extern char* yytext;
  printf("\n%s : %s %d\n", msg, yytext, yylval);
}