#!/bin/bash
# $1 result file

declare -a arr=("witten_bell" "absolute" "katz" "kneser_ney" "presmoothed" "unsmoothed")
declare -a arr2=("2" "3" "4" "5")

if [ -f $1 ]; then
	rm $1
fi
touch $1

for method in "${arr[@]}"
do
	for n_gram in "${arr2[@]}"
	do
		./auto.sh $n_gram $method $1
	done
done
