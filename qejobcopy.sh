#!/bin/bash
# sh qejobcopy.sh infile outfile

INFILE=$1
OUTFILE=$2

mkdir $OUTFILE

cp $INFILE/pw.in $OUTFILE/
cp $INFILE/*UPF $OUTFILE/
cp $INFILE/run* $OUTFILE/
