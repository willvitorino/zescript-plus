%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "diego.c"

/*O node type serve para indicar o tipo de nó que está na árvore. Isso serve para a função eval() entender o que realizar naquele nó*/

int yylex();
void yyerror (char *s){
	printf("%s\n", s);
}

%}

%union{
	char str[51];
	float flo;
	int fn;
	int inter;
	Ast *a;
	}

%token <flo>NUM
%token <str> DEC
%token <str> VAR
%token FIM IF ELSE WHILE PRINT SCAN
%token <fn> CMP

%right '='
%left '+' '-'
%left '*' '/'
%left '^' '@'

%type <a> exp list stmt prog

%nonassoc IFX NEG

%%

val: prog FIM
	;

prog: stmt 		{eval($1);}  /*Inicia e execução da árvore de derivação*/
	| prog stmt {eval($2);}	 /*Inicia e execução da árvore de derivação*/
	;
	
/*Funções para análise sintática e criação dos nós na AST*/	
/*Verifique q nenhuma operação é realizada na ação semântica, apenas são criados nós na árvore de derivação com suas respectivas operações*/
	
stmt: IF '(' exp ')' ':' list ':' %prec IFX {$$ = newflow('I', $3, $6, NULL);}
	| IF '(' exp ')' ':' list ':' ELSE ':' list ':' {$$ = newflow('I', $3, $6, $10);}
	| WHILE exp ':' list ':' {$$ = newflow('W', $2, $4, NULL);}
	| VAR '=' exp {$$ = newasgn($1, $3);}
	| PRINT '(' exp ')' { $$ = newast('P', $3, NULL);}
	| SCAN '(' VAR ')' { $$ = scanasgn($3);}
	;

list:	  stmt{$$ = $1;}
		| list stmt { $$ = newast('L', $1, $2);	}
		;
	
exp: 
	 exp '+' exp {$$ = newast('+', $1, $3);}		/*Expressões matemáticas*/
	|exp '-' exp {$$ = newast('-', $1, $3);}
	|exp '*' exp {$$ = newast('*', $1, $3);}
	|exp '/' exp {$$ = newast('/', $1, $3);}
	|exp '^' exp {$$ = newast('^', $1, $3);}
	|exp '@' exp {$$ = newast('@', $1, $3);}
	|exp CMP exp {$$ = newcmp($2,$1,$3);}		/*Testes condicionais*/
	|'(' exp ')' {$$ = $2;}
	|'-' exp %prec NEG {$$ = newast('M',$2,NULL);}
	|NUM {$$ = newnum($1);}						/*token de um número*/
	|VAR {$$ = newValorVal($1);}				/*token de uma variável*/
	;

%%

#include "lex.yy.c"

int main(){
	listaVariaveis = malloc(sizeof(struct Lista));
	yyin=fopen("script.ze","r");
	yyparse();
	yylex();
	fclose(yyin);
	return 0;
}

