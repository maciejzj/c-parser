%option noyywrap
%{
	#include <stdlib.h>
	#include "parser.tab.h"

	extern void yyerror(const char *);

	static void process_comment(void);
%}

DIGIT [0-9]
LETTER [a-zA-Z]
ALPHANUMERIC [a-zA-Z0-9]
WHITESPACE [\t\v\n\f]

%%

"/*" { process_comment(); }
"//".* { }

"auto" { return(AUTO); }
"char" { return(CHAR); }
"const" { return(CONST); }
"double" { return(DOUBLE); }
"enum" { return(ENUM); }
"extern" { return(EXTERN); }
"float" { return(FLOAT); }
"inline" { return(INLINE); }
"int" { return(INT); }
"long" { return(LONG); }
"register" { return(REGISTER); }
"restrict" { return(RESTRICT); }
"short" { return(SHORT); }
"signed" { return(SIGNED); }
"static" { return(STATIC); }
"struct" { return(STRUCT); }
"typedef" { return(TYPEDEF); }
"union" { return(UNION); }
"unsigned" { return(UNSIGNED); }
"void" { return(VOID); }
"volatile" { return(VOLATILE); }

"..." { return(ELLIPSIS); }
"(" { return '('; }
")" { return ')'; }
"," { return ','; }
";" { return ';'; }
"[" { return '['; }
"]" { return ']'; }
"{" { return '{'; }
"}" { return '}'; }

"=" { return '='; }

"*" {return '*'; }

{DIGIT}+ { yylval = atoi(yytext); return CONST_UINT; }

{LETTER}{ALPHANUMERIC}* { return(IDENTIFIER); }

{WHITESPACE}+ { } /* Whitespaces are ignored */

%%

static void process_comment(void)
{
	int c;
	do {
		c = input();
		if (c == '*') {
			try_end_comment:
			c = input();
			if (c == '*') goto try_end_comment;
			if (c == '/') return;
		}
	} while(c != 0);
	yyerror("unterminated comment");
}
