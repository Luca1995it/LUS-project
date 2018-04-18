#!/bin/bash

# $1 training file.data
# $2 training file.feats
# $3 output fst
# $4 n-gram len
# $5 n-gram method


# this script will create an fst called final.fst and the lex.syms file

n_gram_len=2
n_gram_method=witten_bell

if [ ! -z $4 ]; then
	n_gram_len=$4
fi

if [ ! -z $5 ]; then
	n_gram_method=$5
fi

##### Create basic input file - token,tokenstd,pos-tag,concept-tag

# token,lemma,pos-tag,concept-tag
./prepare_file.py $1 $2 > input.txt

cat input.txt | cut -f 2,4 > last.txt
# lemma, concept-tag
cat input.txt | cut -f 1 > first.txt
# token

# Create O-mix input file
./O_parser.py last.txt | cut -f 2 > second.txt
# concept-tag-mixed

paste -d"\t" first.txt second.txt > final.txt
# token, concept-tag-mixed

rm input.txt last.txt first.txt second.txt

# Create symbols table
./createsymboltable.sh final.txt lex.syms

##### token - concept fst mix (O substituted with original words)
## P(w|m)
./find_probabilities.py final.txt > automa.txt

./createfstfromtable.sh automa.txt lex.syms tmp.fst
fstarcsort --sort_type=olabel tmp.fst > automa.fst
rm automa.txt tmp.fst

## P(m|m-1)
cat final.txt | cut -f 2 | sed "s/^ *$/#/g" | tr '\n' ' ' |\
	tr '#' '\n' | sed "s/^ *//g;s/* $//g" > tmp_parsed.data
farcompilestrings --symbols=lex.syms --unknown_symbol='<unk>' \
	tmp_parsed.data > data.far
ngramcount --order=$n_gram_len --require_symbols=false data.far > pos.cnt
ngrammake --method=$n_gram_method pos.cnt > concepts.fst
rm tmp_parsed.data pos.cnt data.far final.txt



## Combining P(w|m)*P(m|m-1)
fstcompose automa.fst concepts.fst > $3
rm concepts.fst automa.fst
