#!/bin/bash

INFILE=$2
OUTFILE=$1
sed '/ATOMIC_POSITIONS (angstrom)/,$d' $INFILE > theqereplacefile1177temp  #print everything before match and rewrite file 
cat theqereplacefile1177temp > $INFILE
rm theqereplacefile1177temp
sed -n '/Begin final coordinates/,/End final coordinates/p' $OUTFILE >> $INFILE
sed -i 's/Begin final coordinates//'  $INFILE
sed -i 's/End final coordinates//'  $INFILE
