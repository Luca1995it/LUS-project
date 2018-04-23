#!/bin/bash

# Print an fst
# $1 fst file
# $2 symbols file

fstprint -isymbols=$2 -osymbols=$2 $1
