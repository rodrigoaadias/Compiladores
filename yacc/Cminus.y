/****************************************************/
/* File: Cminus.y                                     */
/* The C- Yacc/Bison specification file           */
/****************************************************/
%{
#define YYPARSER /* distinguishes Yacc output from other code files */

#include "globals.h"
#include "util.h"
#include "scan.h"
/* #include "parse.h" */

#define YYSTYPE TreeNode *
static char * savedName; /* for use in assignments */
static int savedLineNo;  /* ditto */
static TreeNode * savedTree; /* stores syntax tree for later return */

%}

%token NUM 
%token ID  
%token SOM 
%token SUB 
%token MUL 
%token DIV 
%token ASSIGN 
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
%token EQ 
%token NEQ 
%token VIRG 
%token ACOL 
%token FCOL 
%token ACH 
%token FCH 
%token OVER 
%token ENDFILE 
%token ERROR 

%%

programa :	declaracao-lista ;
declaracao-lista :	declaracao-lista declaracao 
					| declaracao ;
declaracao	:	var-declaracao 
				| fun-declaracao ;
var-declaracao : INT ID PEV
				 | tipo-especificador ID ACOL NUM FCOL PEV;
tipo-especificador	:	INT | VOID ;
fun-declaracao : tipo-especificador ID APR params FPR composto-decl ;
params : param-lista | VOID;
param-lista : param-lista VIRG param | param ;
param : tipo-especificador ID 
		| tipo-especificador ID ACOL FCOL ; 
composto-decl : { local-declaracoes statement-lista } ;
local-declaracoes : local-declaracoes var-declaracao 
					| /* VAZIO */ ;
statement-lista : statement-lista statement | /* VAZIO */ ;
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
args : arg-list | /* VAZIO */ ;
arg-list : arg-list VIRG expressao | expressao ;
%%

int yyerror(char * message)
{ fprintf(listing,"Syntax error at line %d: %s\n",lineno,message);
  fprintf(listing,"Current token: ");
  printToken(yychar,tokenString);
  Error = TRUE;
  return 0;
}

/* yylex calls getToken to make Yacc/Bison output
 * compatible with ealier versions of the TINY scanner
 */
static int yylex(void)
{ return getToken(); }

