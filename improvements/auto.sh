#!/bin/bash
# Train and test with a given model distribution pf P(concept | concept-1)

# $1 n_gram_len
# $2 n_gram_method
# $3 result file

begin=$(date +%s)

./train.sh data/NLSPARQL.train.data data/NLSPARQL.train.feats.txt out.fst $1 $2
./test.sh data/NLSPARQL.test.data data/NLSPARQL.test.feats.txt out.fst lex.syms temp.txt

end=$(date +%s)

cat temp.txt > $3

#echo "$2;$1;$(expr $end - $begin);$(cat temp.txt | ./conlleval.pl -d '\t' | grep accuracy:)" >> $3

rm out.fst lex.syms temp.txt
