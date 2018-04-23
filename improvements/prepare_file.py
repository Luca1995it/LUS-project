#!/usr/bin/env python
# USAGE: ./prepare_file.py filename.data filename.feats.txt

# INPUT
# File data: token, concept
# File feats: token, pos-tag, tokenstd

# OUTPUT
# token, tokenstd, pos-tag, obi

# Basically it joins the two files on the token line per line

import sys
import numpy as np

def eprint(string1):
	print(string1,file=sys.stderr)

if len(sys.argv) is not 3:
	eprint("USAGE: ./prepare_file.py filename.data filename.feats.txt")
	exit()

data_file = open(sys.argv[1])
feats_file = open(sys.argv[2])

data = [line for line in data_file]
feats = [line for line in feats_file]

if len(data) != len(feats):
	eprint("Data and Feats file must have the same length")
	exit()

for i in range(len(data)):
	line1 = data[i].split()
	line2 = feats[i].split()

	if len(line1) == 0 or len(line2) == 0:
		print("")
	else:
		if line1[0] != line2[0]:
			eprint("Input file are not compatible - line: %d" % i)
			exit()
		token = line1[0]
		obi = line1[1]
		pos = line2[1]
		tokenstd = line2[2]

		print("%s\t%s\t%s\t%s" % (token,tokenstd,pos,obi))


data_file.close()
feats_file.close()
