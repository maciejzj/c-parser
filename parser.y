%{
	#include <stdio.h>

	int yylex();
	void yyerror(const char* s);
%}

%token IDENTIFIER
%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%start line

%%

line
	: line declaration
	|
	;

declaration
	: variable_declaration
	| function_declaration
	;

variable_declaration
	: type_declarator variable_identifier ';'
	;

type_declarator
	: type_qualifiers_list type_specifier ptr 
	;

variable_identifier
	: optional_identifier
	| variable_identifiers_list
	; 

variable_identifiers_list
	: IDENTIFIER
	| IDENTIFIER ',' variable_identifiers_list
	;
	
optional_identifier
	: IDENTIFIER
	|
	;

ptr
	: '*' type_qualifiers_list ptr
	|
	;

type_qualifier
	: CONST
	| VOLATILE
	| RESTRICT
	;

type_qualifiers_list
	: type_qualifier type_qualifiers_list
	|
	;

type_specifier
	: VOID
	| CHAR
	| SHORT
	| INT
	| LONG
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	;

function_declaration
	: type_declarator IDENTIFIER '(' arg_list ')' ';'
	;

arg_list
	: type_declarator optional_identifier
	| type_declarator optional_identifier ',' arg_list
	|
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
