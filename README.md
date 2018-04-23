# Natural-Language-Understanding-Project

Project of the Natural Language Understanding Course

The base_case folder contains code example for the first algorithm described in the paper.
The improvements folder contains code example for the second algorithm described in the paper.

## How to use
## Launch a single test
./auto.sh <distribution> sdfs <n-gram-order> <output_file>

Example ./auto.sh witten_bell 3 res.txt

## Launch all possibile tests
./alltest.sh <output_file>

Example ./alltest.sh res.txt

For different/special applications, take a look at the train.sh and test.sh files.
