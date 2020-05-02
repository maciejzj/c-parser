%{
	#include <stdio.h>

	int yylex();
	void yyerror(const char* s);
%}

%token IDENTIFIER
%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS
%token CONST_UINT

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
	: type_declarator variable_identifiers_list ';'
	;

type_declarator
	: type_qualifiers_list type_specifier ptr
	;

variable_identifiers_list
	: optional_identifier
	| IDENTIFIER '[' ']'
	| IDENTIFIER '[' constant_uint ']'
	| variable_identifiers_list ',' IDENTIFIER
	| variable_identifiers_list ',' IDENTIFIER '[' ']'
	| variable_identifiers_list ',' IDENTIFIER '[' constant_uint ']'
	;

constant_uint
	: CONST_UINT
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
	: type_qualifiers_list type_qualifier
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
	: type_declarator IDENTIFIER '(' args ')' ';'
	;

args
	: arg_list ',' ELLIPSIS
	| arg_list
	|
	;

arg_list
	: type_declarator optional_identifier
	| arg_list ',' type_declarator optional_identifier
	| type_declarator optional_identifier '[' ']'
	| arg_list ',' type_declarator optional_identifier '[' ']'
	| type_declarator optional_identifier '[' constant_uint ']'
	| arg_list ',' type_declarator optional_identifier '[' constant_uint ']'
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
