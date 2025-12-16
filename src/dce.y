%code requires {
#include "ir.hpp"
}

%{
#include "ir.hpp"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>

using std::string;
using std::vector;

int yylex();
extern int yylineno;
void yyerror(const char* s);

extern vector<Statement> stmts;
extern vector<string> finalLive;

static void free_id(char* p) {
    if (p) std::free(p);
}
%}

%union {
    int ival;
    char* sval;
    Operand* opnd;
    char opchar;
}

%token <sval> ID
%token <ival> INT
%token LBRACE RBRACE COMMA SEMI ASSIGN
%token PLUS MINUS MUL DIV POW

%type <opnd> operand signed_int
%type <opchar> binop

%start program

%%

program
    : stmt_list live_block
    ;

stmt_list
    :
    | stmt_list stmt
    ;

stmt
    : ID ASSIGN operand SEMI
      {
          Statement s;
          s.dest = $1;
          free_id($1);

          s.hasOp = false;
          s.src1 = *$3;
          delete $3;

          stmts.push_back(std::move(s));
      }
    | ID ASSIGN operand binop operand SEMI
      {
          Statement s;
          s.dest = $1;
          free_id($1);

          s.hasOp = true;
          s.src1 = *$3;
          s.op = $4;
          s.src2 = *$5;

          delete $3;
          delete $5;

          stmts.push_back(std::move(s));
      }
    ;

operand
    : ID
      {
          Operand* o = new Operand(Operand::Var($1));
          free_id($1);
          $$ = o;
      }
    | signed_int
      {
          $$ = $1;
      }
    ;

signed_int
    : INT
      {
          $$ = new Operand(Operand::Int($1));
      }
    | MINUS INT
      {
          $$ = new Operand(Operand::Int(-$2));
      }
    ;

binop
    : PLUS  { $$ = '+'; }
    | MINUS { $$ = '-'; }
    | MUL   { $$ = '*'; }
    | DIV   { $$ = '/'; }
    | POW   { $$ = '^'; }
    ;

live_block
    : LBRACE id_list RBRACE
    ;

id_list
    : ID
      {
          finalLive.push_back($1);
          free_id($1);
      }
    | id_list COMMA ID
      {
          finalLive.push_back($3);
          free_id($3);
      }
    ;

%%

void yyerror(const char* s) {
    std::fprintf(stderr, "Parse error at line %d: %s\n", yylineno, s);
}