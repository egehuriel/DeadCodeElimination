# CSE 351 – Term Project: Dead Code Elimintation


This project implements **Dead Code Elimination (DCE)** for a simplified Intermediate Language (IL) using **Lex/Flex** and **Yacc/Bison**.

The program parses IL source code, performs backward liveness analysis, eliminates dead assignments, and outputs an optimized version of the code.

---

## Project Summary

Dead Code Elimination is a compiler optimization that removes assignments whose results are never used.  
In this project, IL code is analyzed by traversing statements in reverse order and maintaining a live variable set.

---

## IL Language Definition

### Assignment Statements

Each statement contains exactly one assignment:
a = b;
a = b + c;
a = b * -3;

Rules:
- At most **two operands** on the right-hand side
- Operands are **variables** or **signed integer constants**
- Supported operators: `+`, `-`, `*`, `/`, `^`

	Invalid example:
	a = b + c * d;
---

### Final Live Variable List

The program ends with a live variable list: { r }

This list specifies which variables are considered live at explaining termination.

---

## Dead Code Elimination Algorithm

1. Reverse the list of assignment statements
2. Initialize the live set with the final live variable list
3. Traverse the statements backward:
   - If the destination variable is **not live**, remove the statement
   - If the destination **is live**:
     - Remove it from the live set
     - Add all source variables (excluding constants) to the live set
4. Reverse the remaining statements to restore original order

---

## Project Structure
    CSE351-TermProject/
    ├── build/
    │   ├── dce            # Compiled executable
    │   ├── dce.tab.c      # Bison generated parser source
    │   ├── dce.tab.h      # Bison generated parser header
    │   └── lex.yy.c       # Flex generated lexer source
    ├── src/
    │   ├── dce.l          # Lexer specification (Flex)
    │   ├── dce.y          # Parser specification (Bison)
    │   ├── ir.hpp         # Intermediate Representation (Operand & Statement)
    │   └── main.cpp       # Driver program and Dead Code Elimination logic
    ├── test/
    │   ├── test1.il       # Sample input (basic DCE case)
    │   ├── test2.il       # Sample input (extended cases)
    │   └── test3.il       # Sample input (additional tests)
    ├── out.txt            # Sample output file (optional)
    ├── README.md
    ├──CSE 351 Term Project - Report.pdf
    ├──LICENSE
    └── .gitignore



# Running the Program
## Example Usage:
	./build/dce test/test3.il

## Sample Input (test/test2.il)
	a = b + c;
	d = e * f;
	b = d;
	r = e * p;
	e = 5;
	{ r }

## Expected Optimized Output
	r = e * p;

## Tools Used
	Flex (Lexical Analysis)
	Bison (Syntax Parsing)
	C++
	
## Author
Ege Huriel

CSE 351 - Term Project



