%option noyywrap
%{
	#include <stdlib.h>
	#include "parser.tab.h"
%}

VAR [a-z]

%%

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

%%

