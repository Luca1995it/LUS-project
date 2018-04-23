#!/bin/bash

# create fsa image
# $1 input fsa
# $2 symbol table
# $3 out image

fstdraw --height=40 --fontsize=40 --acceptor --isymbols=$2 --osymbols=$2 $1 |\
	dot -Tpng -Gdpi=1000 > $3
