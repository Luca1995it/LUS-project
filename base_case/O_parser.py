#!/usr/bin/env python

# This file will substitute the O of the concept-tags with the original words.

import sys
import re

def eprint(string1):
	print(string1,file=sys.stderr)

if (len(sys.argv)) < 2 or (len(sys.argv)) > 3:
	eprint("USAGE: ./O_parser.py filename.data [-rev]")
	exit()

input_file = open(sys.argv[1])

if len(sys.argv) == 3 and sys.argv[2] == "-rev":
	for line in input_file:
		if line.strip() == "":
			print("")
		else:
			if line.strip().startswith('O-'):
				print("O")
			else:
				print(line.strip())

else:
	for line in input_file:
		if line.strip() == "":
			print("")
		else:
			token, concept_tag = line.split()
			if concept_tag == 'O':
				print("%s\tO-%s" % (token,token))
			else:
				print("%s\t%s" % (token,concept_tag))

input_file.close()
