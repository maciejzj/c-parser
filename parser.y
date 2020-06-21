%{
	#include <stdio.h>

	int yylex();
	void yyerror(const char* s);
%}

%token IDENTIFIER
%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS
%token CONST_UINT<itype> CONST_INT<itype> CONST_FLOAT<dtype>

%left '+' '-'
%left '*' '/'

%type <dtype>const_expr
%type <uitype>const_uint_expr

%union {
	int itype;
	unsigned int uitype;
	double dtype;
}

%start line

%%

line
	: line declaration
	| line enum_declaration
	| line type_definition
	|
	;

declaration
	: variable_declaration
	| function_declaration
	;

enum_declaration
	: ENUM optional_identifier '{' enum_identifier_list '}' ';'
	;

enum_identifier_list
	: IDENTIFIER
	| IDENTIFIER '=' const_expr
	| enum_identifier_list ',' IDENTIFIER
	| enum_identifier_list ',' IDENTIFIER '=' const_expr
	;

type_definition
	: struct_union_definition
	;

variable_declaration
	: type_declarator variable_identifiers_list ';'
	| type_declarator IDENTIFIER '=' const_expr ';'
	| type_declarator variable_identifiers_list ','
		IDENTIFIER '=' const_expr ';'
	| type_declarator '(' ptr IDENTIFIER ')' '(' args ')' ';'
	;

type_declarator
	: type_qualifiers_list type_specifier ptr
	;

variable_identifiers_list
	: optional_identifier
	| IDENTIFIER '[' ']'
	| IDENTIFIER '[' const_uint_expr ']'
	| variable_identifiers_list ',' IDENTIFIER
	| variable_identifiers_list ',' IDENTIFIER '[' ']'
	| variable_identifiers_list ',' IDENTIFIER '[' const_uint_expr ']'
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

const_uint_expr
	: CONST_INT { $$ = $<uitype>1; };
	| const_uint_expr '+' const_uint_expr { $$ = $1 + $3; }
	| const_uint_expr '-' const_uint_expr {
		if($<itype>1 - $<itype>3 < 0){
			yyerror("Array declaed with negative number as size.");
		}
		$$ = $1 - $3;
	}
	| const_uint_expr '*' const_uint_expr { $$ = $1 * $3; }
	| const_uint_expr '/' const_uint_expr { $$ = $1 / $3; }
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
	| type_declarator optional_identifier '[' const_uint_expr ']'
	| arg_list ',' type_declarator optional_identifier '[' const_uint_expr ']'
	;

const_expr
	: CONST_INT {}
	| CONST_FLOAT {}
	| '+' const_expr { $$ = -$2; }
	| const_expr '+' const_expr { $$ = $1 + $3; }
	| const_expr '-' const_expr { $$ = $1 - $3; }
	| const_expr '*' const_expr { $$ = $1 * $3; }
	| const_expr '/' const_expr {
		if ($3 == 0.0) {
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
