#!/usr/bin/env python

# create an fst encoding the probabilities
# P(token|concept_tag) = Count(token,concept_tag) / Count(concept_tag)

import sys
import numpy as np

def eprint(string1):
	print(string1,file=sys.stderr)

if len(sys.argv) is not 2:
	eprint("USAGE: ./find_probabilities.py filename")
	exit()

data_file = open(sys.argv[1])

data = [line for line in data_file if len(line.strip()) > 0]

### Compute P(in|out) and create a text FST
### P(in|out) = C(in,out) / C(out)

c_in_out = {}	# Count C(in,out)
c_out = {}		# Count C(out)
p_in_out = {}	# Probability P(in|out)

### PHASE 1, compute counts
for line in data:
	if len(line.strip()) == 0:
		continue

	in_token, out_token = line.split()

	if not in_token in c_in_out:
		c_in_out[in_token] = {}

	if out_token in c_in_out[in_token]:
		c_in_out[in_token][out_token] += 1
	else:
		c_in_out[in_token][out_token] = 1

	if out_token in c_out:
		c_out[out_token] += 1
	else:
		c_out[out_token] = 1

### PHASE 2, compute probabilities
for in_token in c_in_out:
	p_in_out[in_token] = {}
	for out_token in c_in_out[in_token]:
		p_in_out[in_token][out_token] = c_in_out[in_token][out_token] / c_out[out_token]

### PHASE 3, print FST
main_state = 0

for in_token in c_in_out:
	for out_token in c_in_out[in_token]:
		probab = -np.log(p_in_out[in_token][out_token])
		print("%d\t%d\t%s\t%s\t%f" % (main_state,main_state,in_token,out_token,probab))

probab = 1/len(c_out)
for out_token in c_out:
	print("%d\t%d\t%s\t%s\t%f" % (main_state,main_state,'<unk>',out_token,probab))

print("%d" % main_state)

data_file.close()
