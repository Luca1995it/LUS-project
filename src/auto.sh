# $1 n_gram_len
# $2 n_gram_method

./train.sh data/NLSPARQL.train.data out.fst $1 $2
./test.sh data/NLSPARQL.test.data out.fst lex.syms temp.txt
echo "N-gram: $1 -- N-method: $2" > tmp.txt
cat temp.txt | ./conlleval.pl -d "\t" | grep "accuracy:" >> risultato.txt

rm out.fst lex.syms risultato.txt
