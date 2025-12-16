%option noyywrap
%option nounput
%option noinput
%option yylineno

%{
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "dce.tab.h"

static char* dup_yytext() {
    return ::strdup(yytext);
}
%}

ID      [a-zA-Z_][a-zA-Z0-9_]*
INT     [0-9]+
WS      [ \t\r\n]+

%%

{WS}                { }

"//".*              { }
"#".*               { }

"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
","                 { return COMMA; }
";"                 { return SEMI; }
"="                 { return ASSIGN; }

"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return MUL; }
"/"                 { return DIV; }
"^"                 { return POW; }

{INT}               { yylval.ival = std::atoi(yytext); return INT; }

{ID}                { yylval.sval = dup_yytext(); return ID; }

.                   {
                        std::fprintf(stderr,
                                     "Lexer error at line %d: unexpected character '%s'\n",
                                     yylineno, yytext);
                        return 0;
                    }

%%