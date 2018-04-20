#!/bin/bash

# $1 file to test data
# $2 file to test feats
# $3 trained fst
# $4 symbols file
# $5 output file

# token,concept-tag

## Extracting real result and removing them from real input
cat $1 | cut -f 2 > real_results.txt

cat $1 | cut -f 1 > token_vertical.txt
cat token_vertical.txt | sed "s/^ *$/#/g" | tr '\n' ' ' | tr '#' '\n' |\
	sed "s/^ *//g;s/* $//g" > token.txt

cat $2 | cut -f 2 > postags.txt

## Only to print advancement
numfiles=$(cat token.txt | wc -l)
count=1

echo "Number of lines to test: $numfiles"

if [ -f tmp.txt ]; then
	rm tmp.txt
fi

while read line; do

	echo $line | farcompilestrings --symbols=$4 --generate_keys=1 \
		--unknown_symbol='<unk>' --keep_symbols |\
		farextract --filename_suffix='.fst'

	fstcompose 1.fst $3 | fstshortestpath | fstrmepsilon | fsttopsort |\
		fstproject --project_output | fstprint --isymbols=$4 --osymbols=$4 |\
		cut -f 3 -s >> tmp.txt

	echo -ne "\n" >> tmp.txt
	## Progress print
	let adv=count*100/numfiles
	echo -ne "\rAdvancement: ${adv}%"
	let count=count+1

done < token.txt

echo -e "\nDone!"

cat -s tmp.txt > __output.txt
#./O_parser.py __output.txt -rev > output.txt
cat __output.txt > output.txt

paste -d"\t" token_vertical.txt postags.txt real_results.txt output.txt > $5

rm real_results.txt token.txt token_vertical.txt postags.txt
rm 1.fst tmp.txt __output.txt output.txt
