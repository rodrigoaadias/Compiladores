/****************************************************/
/* File: Cminus.y                                     */
/* The C- Yacc/Bison specification file           */
/****************************************************/
%{
#define YYPARSER /* distinguishes Yacc output from other code files */

#include "globals.h"
#include "util.h"
#include "scan.h"
#include "parse.h"

#define YYSTYPE TreeNode *
static TreeNode * savedTree; /* stores syntax tree for later return */
static int yylex(void);

%}

%token IF ELSE WHILE INT VOID RETURN
%token NUM ID
%token ASSIGN EQ NEQ MENOR MENORIGUAL MAIOR MAIORIGUAL SOM SUB MUL DIV APR FPR ACOL FCOL ACH FCH VIRG PEV
%token ERROR ENDFILE

%%

programa 			:	declaracao_lista
						{
							savedTree = $1
						} 
					;

declaracao_lista 	:	declaracao_lista declaracao 
						{
							YYSTYPE t = $1;
                            if(t != NULL)
		   	  			    {
                                while(t->sibling != NULL)
                                    t = t->sibling;
                                t->sibling = $2;
                                $$ = $1;
                            }
                            else
                                $$ = $2;
						}
					| 	declaracao
						{
                           $$ = $1;
                        }
					;

declaracao			:	var_declaracao
						{
							$$ = $1;
						}
					| 	fun_declaracao 
						{
							$$ = $1;
						}
					;

var_declaracao 		: 	INT ident PEV
						{
							$$ = newExpNode(typeK);
                            $$->type = integerK;
                            $$->attr.name = "inteiro";
                            $$->child[0] = $2;
                            $2->nodekind = statementK;
                            $2->kind.stmt = variableK;
							$2->type = integerK;
						}
				 	| 	INT ident ACOL num FCOL PEV
						{
							$$ = newExpNode(typeK);
                            $$->type = integerK;
                            $$->attr.name = "inteiro";
                            $$->child[0] = $2;
                            $2->nodekind = statementK;
                            $2->kind.stmt = variableK;
							$2->type = integerK; 
                            $2->attr.len = $4->attr.val;
						}
					;

fun_declaracao 		: 	INT ident APR params FPR composto_decl
                        {
                        	$$ = newExpNode(typeK);
                            $$->type = integerK;
                            $$->attr.name = "inteiro";
                            $$->child[0] = $2;
                            $2->child[0] = $4;
                            $2->child[1] = $6;
                            $2->nodekind = statementK;
                            $2->kind.stmt = functionK;
							$2->type = integerK;
							$4->type = integerK;
							aggScope($2->child[0], $2->attr.name);
							aggScope($2->child[1], $2->attr.name);
                        }
                    |   VOID ident APR params FPR composto_decl
                        {
                        	$$ = newExpNode(typeK);
                            $$->type = voidK;
                            $$->attr.name = "void";
                            $$->child[0] = $2;
                            $2->child[0] = $4;
                            $2->child[1] = $6;
                            $2->nodekind = statementK;
                            $2->kind.stmt = functionK;
							aggScope($2->child[0], $2->attr.name);
							aggScope($2->child[1], $2->attr.name);
                        }
                    ;

params 				: 	param_lista
                        {
                           $$ = $1;
                        }
					| 	VOID
                        {
						  $$ = newExpNode(typeK);
           				  $$->attr.name = "void";
						}
					;

param_lista 		: 	param_lista VIRG param 
						{
                           YYSTYPE t = $1;
                           if(t != NULL)
						   {
                              while(t->sibling != NULL)
                                  t = t->sibling;
                              t->sibling = $3;
                              $$ = $1;
                            }
                            else
                              $$ = $3;
                        }
					| 	param
                        {
                            $$ = $1;
                        }
					;

param 				: 	INT ident
                        {
						   	
                           $$ = newExpNode(typeK);
					       $2->nodekind = statementK;
                           $2->kind.stmt = variableK;
                           $$->type = integerK;
						   $2->type = integerK; 	
                           $$->attr.name = "inteiro";
                           $$->child[0] = $2;
                        }
					| 	INT ident ACOL FCOL
                        {
							
                            $$ = newExpNode(typeK);
							$2->nodekind = statementK;
                            $2->kind.stmt = variableK;
                            $$->type = integerK;
                            $$->attr.name = "inteiro";
                            $$->child[0] = $2;
                            $2->attr.len = 1;
						    $2->type = integerK;
                        }
					; 

composto_decl 		: 	ACH local_declaracoes statement_lista FCH
                        {
                            YYSTYPE t = $2;
                            if(t != NULL)
						    {
                               while(t->sibling != NULL)
                                  t = t->sibling;
                                t->sibling = $3;
                                $$ = $2;
                            }
                            else
                               $$ = $3;
                        }
                    |   ACH local_declaracoes FCH
                        {
                            $$ = $2;
                        }
                    |   ACH statement_lista FCH
                        {
                            $$ = $2;
                        }
                    |   ACH FCH
                        {
			   			}
					;

local_declaracoes 	: 	local_declaracoes var_declaracao
                        {
                            YYSTYPE t = $1;
                            if(t != NULL)
							{
                            	while(t->sibling != NULL)
                                	 t = t->sibling;
                             	t->sibling = $2;
                             	$$ = $1;
                            }
                            else
                               $$ = $2;
                        }
					|   var_declaracao
                        {
                            $$ = $1;
                        }
					;

statement_lista 	: 	statement_lista statement
                        {
                           YYSTYPE t = $1;
                           if(t != NULL)
						   {
                              while(t->sibling != NULL)
                                   t = t->sibling;
                              t->sibling = $2;
                              $$ = $1;
                           }
                           else
                             $$ = $2;
                        }
					|   statement
                        {
                           $$ = $1;
                        }
					;

statement 			: 	expressao_decl
                        {
                           $$ = $1;
                        }
					| 	composto_decl
                        {
                           $$ = $1;
                        }
					| 	selecao_decl 
                        {
                           $$ = $1;
                        }
					| 	iteracao_decl
                        {
                           $$ = $1;
                        }
					| 	retorno_decl
                        {
                           $$ = $1;
                        }
					;

expressao_decl 		: 	expressao PEV
                        {
                           $$ = $1;
                        }
					| 	PEV {}
					;

selecao_decl 		: 	IF APR expressao FPR statement 
                        {
                             $$ = newStmtNode(ifK);
                             $$->child[0] = $3;
                             $$->child[1] = $5;
                        } 
			  		| 	IF APR expressao FPR statement ELSE statement 
						{
							 
                             $$ = newStmtNode(ifK);
                             $$->child[0] = $3;
                             $$->child[1] = $5;
                             $$->child[2] = $7;
                        }
					;

iteracao_decl 		: 	WHILE APR expressao FPR statement 
                        {
                             $$ = newStmtNode(whileK);
                             $$->child[0] = $3;
                             $$->child[1] = $5;
                        }
					;

retorno_decl 		: 	RETURN PEV 
                       	{
                            $$ = newStmtNode(returnK);
							$$->type = voidK;
                       	}
					| 	RETURN expressao PEV
                       	{
                            $$ = newStmtNode(returnK);
                            $$->child[0] = $2;
                       	}
					;

expressao 			: 	var ASSIGN expressao 
                       	{
                            $$ = newStmtNode(assignK);
                            $$->child[0] = $1;
                            $$->child[1] = $3;
                       	}
					| 	simples_expressao
                       	{
                            $$ = $1;
                       	}
					;

var 				: 	ident
                       	{
                            $$ = $1;
                       	}
					| 	ident ACOL expressao FCOL
                       	{
                            $$ = $1;
                            $$->child[0] = $3;
                            $$->kind.exp = vectorK;
							$$->type = integerK;
                       	}
					;

simples_expressao 	: 	soma_expressao relacional soma_expressao
                       	{
                            $$ = $2;
                            $$->child[0] = $1;
                            $$->child[1] = $3;
                       	}
					| 	soma_expressao
                       	{
                            $$ = $1;
                       	} 
					;

relacional 			: 	MENORIGUAL
                       	{
                            $$ = newExpNode(operationK);
                            $$->attr.op = LTE;                            
							$$->type = booleanK;
                       	}
					| 	MENOR
                       	{
                            $$ = newExpNode(operationK);
                            $$->attr.op = LT;                            
							$$->type = booleanK;
                       	}
					| 	MAIOR
                       	{
                            $$ = newExpNode(operationK);
                            $$->attr.op = GT;                            
							$$->type = booleanK;
                       	}
					| 	MAIORIGUAL 
                       	{
                            $$ = newExpNode(operationK);
                            $$->attr.op = GTE;                            
							$$->type = booleanK;
                       	}
					| 	EQ
                       	{
                            $$ = newExpNode(operationK);
                            $$->attr.op = EQ;  
							$$->type = booleanK;                          
                       	}
					| 	NEQ
                       	{
                            $$ = newExpNode(operationK);
                            $$->attr.op = NE;
							$$->type = booleanK;                            
                       	}
					;

soma_expressao 		: 	soma_expressao soma termo 
                       	{
                            $$ = $2;
                            $$->child[0] = $1;
                            $$->child[1] = $3;
                       	}
					| 	termo
                       	{
                            $$ = $1;
                       	}
					;

soma 				: 	SOM 
                       	{
                            $$ = newExpNode(operationK);
                            $$->attr.op = SOM;                            
                       	}
					| 	SUB
                       	{
                            $$ = newExpNode(operationK);
                            $$->attr.op = SUB;                            
                       	}
					;

termo 				: 	termo mult fator
                       	{
                            $$ = $2;
                            $$->child[0] = $1;
                            $$->child[1] = $3;
                       	}
					| 	fator
                       	{
                            $$ = $1;
                       	}
					;
mult 				: 	MUL
                        {
                            $$ = newExpNode(operationK);
                            $$->attr.op = TIMES;                            
                        }
					| 	DIV 
                       	{
                            $$ = newExpNode(operationK);
                            $$->attr.op = OVER;                            
                       	}
					;

fator 				: 	APR expressao FPR
                       	{
                            $$ = $2;
                       	}
					| 	var
                       	{
                            $$ = $1;
                       	}
					|	ativacao
                       	{
                            $$ = $1;
                       	}
					| 	num
                       	{
                            $$ = $1;
                       	}
					;

ativacao 			: 	ident APR arg_list FPR
                       	{
                            $$ = $1;
                            $$->child[0] = $3;
                            $$->nodekind = statementK;
                            $$->kind.stmt = callK;
                       	}
					|	ident APR FPR
					   	{
                            $$ = $1;
                            $$->nodekind = statementK;
                            $$->kind.stmt = callK;
                       	}
					;

arg_list 			: 	arg_list VIRG expressao
                       	{
                            YYSTYPE t = $1;
                             if(t != NULL)
							 {
                                while(t->sibling != NULL)
                                   t = t->sibling;
                                 t->sibling = $3;
                                 $$ = $1;
                             }
                             else
                                 $$ = $3;
                        }
					| 	expressao
                        {
                             $$ = $1;
                        }
					;

ident               :    identificador {$$ = $1;}
                    ;

identificador       :    ID
                         {
                             $$ = newExpNode(idK);
                             $$->attr.name = copyString(tokenString);
                         }
                    ;

num                 :    numero {$$ = $1;}
                    ;

numero              :   NUM
                        {
                             $$ = newExpNode(constantK);
                             $$->attr.val = atoi(tokenString);
							 $$->type = integerK;
						}
                    ;		
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

TreeNode * parse(void){
    yyparse();
    return savedTree;
}