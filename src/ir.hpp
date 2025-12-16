#pragma once
#include <string>
#include <vector>

struct Operand {
    enum Kind { VAR, INTCONST } kind;
    std::string name;
    int value;

    static Operand Var(const std::string& n) {
        Operand o; o.kind = VAR; 
        o.name = n;
        o.value = 0; 
        return o;
    }
    static Operand Int(int v) {
        Operand o; 
        o.kind = INTCONST; 
        o.name = ""; 
        o.value = v; 
        return o;
    }
};
struct Statement {
    std::string dest;
    bool hasOp;
    Operand src1;
    char op;
    Operand src2;
};
extern std::vector<Statement> stmts;
extern std::vector<std::string> finalLive;