#!/bin/bash

# $1 training file.data
# $2 output fst

# this script will create an fst called final.fst (and the lex.syms file)

n_gram_len=2
n_gram_method=witten_bell

if [ ! -z $3 ]; then
	n_gram_len=$3
fi

if [ ! -z $4 ]; then
	n_gram_method=$4
fi

##### Create basic input file - token,tokenstd,pos-tag,concept-tag

# Create general input file

./O_parser.py $1 > res.txt

# Create symbols table
./createsymboltable.sh res.txt lex.syms

##### token - concept fst mix (O substituted with original words)
## P(w|m)
./find_probabilities.py res.txt > automa.txt

./createfstfromtable.sh automa.txt lex.syms tmp.fst
fstarcsort --sort_type=olabel tmp.fst > automa.fst

## P(m|m-1)
cat res.txt | cut -f 2 | sed "s/^ *$/#/g" | tr '\n' ' ' |\
	tr '#' '\n' | sed "s/^ *//g;s/* $//g" > tmp_parsed.data
farcompilestrings --symbols=lex.syms --unknown_symbol='<unk>' \
	tmp_parsed.data > data.far
ngramcount --order=$n_gram_len --require_symbols=false data.far > pos.cnt
ngrammake --method=$n_gram_method pos.cnt > concepts.fst

## Combining P(w|m)*P(m|m-1)
fstcompose automa.fst concepts.fst > $2

# Cleaning
rm res.txt automa.txt tmp.fst
rm tmp_parsed.data pos.cnt data.far
rm concepts.fst automa.fst
