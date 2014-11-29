#!/bin/bash
# sh script.sh IncompleteQEOutFile QEInputFile
# takes atomic coords from incomplete QE output file and puts them in the qe input file


pwout=$1
pwin=$2
numofatoms=`awk '/number of atoms\/cell/ {print $5}' $pwout`

cp ./$pwin ./${pwin}.backup

sed -e '/ATOMIC_POSITIONS/,$d' $pwin > ./tmppw 
echo 'ATOMIC_POSITIONS (angstrom)' >> ./tmppw
grep -A $numofatoms 'ATOMIC_POSITIONS' $pwout | tail -$numofatoms >> ./tmppw

mv ./tmppw ./$pwin
