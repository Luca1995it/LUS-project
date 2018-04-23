#!/bin/bash

# $1 training data file
# $2 training feats file
# $3 output fst
# $4 n-gram len (optional)
# $5 n-gram method (optional)

# this script will create an fst called $3 and the lex.syms symbol file

n_gram_len=2
n_gram_method=witten_bell

if [ ! -z $4 ]; then
	n_gram_len=$4
fi

if [ ! -z $5 ]; then
	n_gram_method=$5
fi

# Create symbols table
./createsymboltable.sh $1 lex.syms

##### token - concept
## P(w|c)
./find_probabilities.py $1 > automa.txt

./createfstfromtable.sh automa.txt lex.syms tmp.fst
fstarcsort --sort_type=olabel tmp.fst > automa.fst

## P(c|c-1)
cat $1 | cut -f 2 | sed "s/^ *$/#/g" | tr '\n' ' ' |\
	tr '#' '\n' | sed "s/^ *//g;s/* $//g" > tmp_parsed.data
farcompilestrings --symbols=lex.syms --unknown_symbol='<unk>' \
	tmp_parsed.data > data.far
ngramcount --order=$n_gram_len --require_symbols=false data.far > pos.cnt
ngrammake --method=$n_gram_method pos.cnt > concepts.fst

## Combining P(w|c)*P(c|c-1)
fstcompose automa.fst concepts.fst > $3

# Cleaning
rm automa.txt tmp.fst
rm tmp_parsed.data pos.cnt data.far
rm concepts.fst automa.fst
