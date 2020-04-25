%{
	#include <stdio.h>

	int yylex();
	void yyerror(const char* s);
%}

%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%%

PROGRAM:
	   ;

%%

void yyerror(const char *s)
{
	fprintf(stderr, "%s\n", s);
}

int main(void)
{
	yyparse();
	return 0;
}

