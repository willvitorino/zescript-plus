%{
#include <stdio.h>
%}

NUM [0-9]+\.?[0-9]*
DEC "def"
FIM "FIM"
IF "zif"
ELSE "zelse"
WHILE "while"
PRINT "print"
SCAN "input"

%%

{DEC} {strcpy(yylval.str, yytext); return DEC;}

{NUM} {
	yylval.flo = atof(yytext);
	return NUM;
}

[-+()=/*^{};@:] { return *yytext; }
			

">" {yylval.fn = 1; return CMP; }
"<" {yylval.fn = 2; return CMP; }
"<>" {yylval.fn = 3; return CMP; }
"==" {yylval.fn = 4; return CMP; }
">=" {yylval.fn = 5; return CMP; }
"<=" {yylval.fn = 6; return CMP; }

{FIM} { printf("E FIM\n"); return FIM;}
{IF} {return IF;}
{ELSE} {return ELSE;}
{WHILE} {return WHILE;}
{PRINT} {return PRINT;}
{SCAN} { return SCAN; }

[A-Za-z][a-zA-Z0-9]*	{ strcpy(yylval.str, yytext); return VAR;}

[\ \n\t]*	{;}
. {printf("(%s) Ingonrado\n",yytext);}
%%