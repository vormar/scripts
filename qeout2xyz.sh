#!/bin/bash
# This script will take the final coordinates of a quantum espresso relax job
# and make an xyz file from them.
#
# The script should be called with 2 args
# sh qeout2xyz.sh qe.out qe.xyz 
#
# Note that the script makes a file called qeout2xyztmp1177 and moves it to the name of the 2nd arg

NumberOfAtoms=`awk '/number of atoms/{print $5}' $1`
sed -n '/Begin/,/End/p' $1 > $2
sed -i "s/Begin final coordinates/$NumberOfAtoms/" $2
sed -i "s/End final coordinates//" $2
sed '/ATOMIC_POSITIONS (angstrom)/d' $2 > qeout2xyztmp1177
mv qeout2xyztmp1177 $2
