# Natural-Language-Understanding-Project

Project of the Natural Language Understanding Course

The base_case folder contains code example for the first algorithm described in the paper.
The improvements folder contains code example for the second algorithm described in the paper.

## How to use - Standard
## Launch a single test
	./auto.sh <distribution> <n-gram-order> <output_file>

Example

	./auto.sh witten_bell 3 res.txt

## Launch all possibile tests
	./alltest.sh <output_file>

Example

	./alltest.sh res.txt

---

## How to use - Advanced
## Train on specific input dataset
	./train.sh <train_file.data> <train_file.feats> <result_fst_filename> <n-gram-order> <method>

Example

	./train.sh train.data train.feats.txt result.fst 3 katz

## Test on specific input dataset
	./test.sh <test_file.data> <test_file.feats> <trained_fst> <symbols_file> <result_file>

Example

	./test.sh test.data test.feats.txt result.fst lex.syms final.txt
