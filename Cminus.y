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
declaracao-lista :	declaracao-lista declaracao 
					| declaracao ;
declaracao	:	var-declaracao 
				| fun-declaracao ;
var-declaracao : tipo-especificador ID PEV
				 | tipo-especificador ID ACOL NUM FCOL PEV;
tipo-especificador	:	INT | VOID ;
fun-declaracao : tipo-especificador ID APR params FPR composto-decl ;
params : param-lista | VOID;
param-lista : param-lista VIRG param | param ;
param : tipo-especificador ID 
		| tipo-especificador ID ACOL FCOL ; 
composto-decl : { local-declaracoes statement-lista } ;
local-declaracoes : local-declaracoes var-declaracao 
					| vazio ;
statement-lista : statement-lista statement | vazio ;
statement : expressao-decl | composto-decl | selecao-decl 
			| iteracao-decl | retorno-decl ;
expressao-decl : expressao PEV | PEV ;
selecao-decl : IF APR expressao FPR statement 
			  | IF APR expressao FPR statement ELSE statement ;
iteracao-decl : WHILE APR expressao FPR statement ;
retorno-decl : RETURN PEV | RETURN expressao PEV;
expressao : var IGL expressao | simples-expressao ;
var : ID | ID ACOL expressao FCOL ;
simples-expressao : soma-expressao relacional soma-expressao
					| soma-expressao ;
relacional : MENORIGUAL | MENOR | MAIOR | MAIORIGUAL 
			| EQUAL | NOTEQUAL ;
soma-expressao : soma-expressao soma termo | termo ;
soma : SOM | SUB ;
termo : termo mult fator | fator ;
mult : MUL | DIV ;
fator : APR expressao FPR | var | ativacao | NUM ;
ativacao : ID APR args FPR ;
args : arg-list | vazio ;
arg-list : arg-list VIRG expressao | expressao ;
vazio : SPACE | NEWLINE ;
%%

int main()
{
  extern int yydebug;
  yydebug = 0;

  printf("\nParser em execução...\n");
  abrirArq();
  return yyparse();
}

void yyerror(char * msg)
{
  extern char* yytext;
  printf("\n%s : %s %d\n", msg, yytext, yylval);
}
