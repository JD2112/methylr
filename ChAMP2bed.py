#!/usr/bin/env python

import sys

input = sys.argv[1]
output = ".".join((input, "bed"))

ChAMP = open(input, "r")
next(ChAMP)

for line in ChAMP:
    l = line.split()
    chr = l[10]
    end = int(l[11])
    start = end - 1
    name = l[0]
    score = float(l[1])
    strand = "+" if l[12] == "F" else "-"
    with open(output, 'a') as out:
        out.write(f"{chr}\t{start}\t{end}\t{name}\t{score}\t{strand}\n")

#print(f"{chr}\t{start}\t{end}\t{name}\t{score}\t{strand}\n")
