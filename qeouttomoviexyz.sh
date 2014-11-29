#!/bin/bash

# This script reads the output of quantum espresso and outputs an xyz movie file
#-----------------------------------------------------
# sh analyzeqe.sh qeinputfile outputxyzmoviefile
# ----------------------------------------------------

INPUT=$1
OUTPUT=$2
NUMATM=`awk '/number of atoms/{print $5}' $INPUT` 

grep -A$NUMATM ATOMIC $INPUT | grep -v ATOMIC |awk -v AWKNUMATM=$NUMATM 'BEGIN{print AWKNUMATM ; print " "}{gsub("--","REPLACEWITHATM \n");print}END{print AWKNUMATM}' > $OUTPUT 
sed -i "s/REPLACEWITHATM/$NUMATM/g" $OUTPUT
sed -i '$ d' $OUTPUT
