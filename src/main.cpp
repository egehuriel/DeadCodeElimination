#include <iostream>
#include <vector>
#include <string>
#include <cstdio>
#include <set>
#include <algorithm>
#include "ir.hpp"

std::vector<Statement> stmts;
std::vector<std::string> finalLive;

extern int yyparse();
extern FILE* yyin;

static void printOperand(const Operand& o){
    if(o.kind == Operand::VAR){
        std::cout << o.name;
    } else{
        std::cout << o.value;
    }
}
static void printStatement(const Statement& s){
    std::cout << s.dest << " = ";
    printOperand(s.src1);
    if(s.hasOp){
        std::cout << " " << s.op << " ";
        printOperand(s.src2);
    }
    std::cout << ";" << std::endl;
}

int main(int argc, char** argv) {
    if(argc > 1) {
        yyin = std::fopen(argv[1], "r");
        if(!yyin) {
            std::cerr << "Error: cannot open file " << argv[1] << std::endl;
            return 1;
        }
    }   
    if(yyparse() != 0) {
        std::cerr << "Parsing failed." << std::endl;
        return 1;
    }
    std::set<std::string> liveSet(finalLive.begin(), finalLive.end());
    std::vector<Statement> reversed;
    reversed.reserve(stmts.size());
    for(int i = stmts.size() - 1; i >=0 ; --i){
        const Statement& s = stmts[i];
        if(liveSet.find(s.dest) == liveSet.end()){
            continue;
        }
        reversed.push_back(s);
        liveSet.erase(s.dest);
        if(s.src1.kind == Operand::VAR){
            liveSet.insert(s.src1.name);
        }
        if(s.hasOp && s.src2.kind == Operand::VAR){
            liveSet.insert(s.src2.name);
        }
    }
    std::reverse(reversed.begin(), reversed.end());
    for(const auto& print1 : reversed){
        printStatement(print1);
    }
    return 0;
}