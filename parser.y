%{
	#include <stdio.h>

	int yylex();
	void yyerror(const char* s);
%}

%token IDENTIFIER
%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS
%token NUM CONST_UINT

%left '+' '-'
%left '*' '/'

%start line

%%

line
	: line declaration
	| line type_definition
	|
	;

declaration
	: variable_declaration
	| function_declaration
	;

type_definition
	: struct_union_definition
	;

variable_declaration
	: type_declarator variable_identifiers_list ';'
	| type_declarator IDENTIFIER '=' const_expr ';'
	| type_declarator variable_identifiers_list ','
		IDENTIFIER '=' const_expr ';'
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

struct_union_definition
	: STRUCT optional_identifier compound_type
	| UNION optional_identifier compound_type
	;

compound_type
	: '{' members '}' ';'
	;

members
	: members_list
	|
	;

members_list
	: variable_declaration
	| members_list variable_declaration
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

const_expr
	: CONST_UINT
	| '+' const_expr{ $$ = -$2; }
	| const_expr '+' const_expr { $$ = $1 + $3; }
	| const_expr '-' const_expr { $$ = $1 - $3; }
	| const_expr '*' const_expr { $$ = $1 * $3 }
	| const_expr '/' const_expr {
		if ($2 == 0) {
			yyerror("Zero division");
			$$ = 1;
		} else {
			$$ = $1 / $3;
		}
	}
	| '(' const_expr ')' { $$ = $2; }
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
