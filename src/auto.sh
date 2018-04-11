# $1 n_gram_len
# $2 n_gram_method

begin=$(date +%s)

./train.sh data/NLSPARQL.train.data data/NLSPARQL.train.feats.txt out.fst $1 $2
./test.sh data/NLSPARQL.test.data out.fst lex.syms temp.txt
echo "$2 $1" > risultato.txt
cat temp.txt | ./conlleval.pl -d "\t" | grep "accuracy:" >> risultato.txt

rm out.fst lex.syms temp.txt

end=$(date +%s)
echo "Total time: $(expr $end - $begin) seconds"
cat risultato.txt
