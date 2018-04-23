#!/bin/bash

# create a symbol table
# $1 input file
# $2 output file name

ngramsymbols < $1 > $2
