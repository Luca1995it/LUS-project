#!/bin/bash

# $1 file to test data
# $2 trained fst
# $3 symbols file
# $4 output file

# token,concept-tag

## Extracting real result and removing them from real input
cat $1 | cut -f 2 > real_results.txt

cat $1 | cut -f 1 | sed "s/^ *$/#/g" | tr '\n' ' ' | tr '#' '\n' |\
	sed "s/^ *//g;s/* $//g" > token.txt

## Only to print advancement
numfiles=$(cat token.txt | wc -l)
count=1

echo "Number of lines to test: $numfiles"

if [ -f tmp.txt ]; then
	rm tmp.txt
fi

while read line; do

	echo $line | farcompilestrings --symbols=$3 --generate_keys=1 \
		--unknown_symbol='<unk>' | farextract --filename_suffix='.fst'

	fstcompose 1.fst $2 | fstshortestpath | fstrmepsilon |\
		fsttopsort | fstproject --project_output | fstprint --isymbols=$3 --osymbols=$3 |\
		cut -f 3 -s >> tmp.txt

	echo -ne "\n" >> tmp.txt
	## Progress print
	let adv=count*100/numfiles
	echo -ne "\rAdvancement: ${adv}%"
	let count=count+1
	rm 1.fst

done < token.txt

echo -e "\nDone!"

cat -s tmp.txt > __output.txt
./O_parser.py __output.txt -rev > output.txt

paste -d"\t" real_results.txt output.txt > $4

rm real_results.txt token.txt
rm 1.fsa tmp.txt __output.txt output.txt
