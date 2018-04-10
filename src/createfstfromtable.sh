#!/bin/bash
# 1. input file
# 2. symbol table
# 3. output fsa
# 4. acceptor?

if ! [ -z $4 ] && [ $4 == "-acceptor" ]; then
	fstcompile --acceptor --isymbols=$2 $1 > $3
else
	fstcompile --osymbols=$2 --isymbols=$2 $1 > $3
fi
