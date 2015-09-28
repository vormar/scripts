#!/bin/bash
# This script takes an xyz file and creates quantum espresso input files.
# Call the script with the xyz file:
#
# sh xyztoqe prefix.xyz
#
# You need to have the pseudopotential files in the pseudopots dir before you use the script.
# npbrawand@ucdavis.edu


#read in values
sysname=${1%%.xyz}
numatoms=$(head -n 1 $1)
tail -n $(($numatoms)) $1 | awk '{print $1}' | awk '!x[$0]++' | sed '/^$/d'> xyztoqetmp.txt 
numatomtyps=`wc -l xyztoqetmp.txt | awk '{print $1}'`
scrptdir=$(cd `dirname $0` && pwd)


#create new dir for qe input files
mkdir $sysname

#copy files from xyztoqe dir to new input dir
cp $scrptdir/*.in $sysname
cp $scrptdir/runqe $sysname

# here the ATOMIC_SPECIES list is constructed
while read line 
do
 mass=`awk "/$line /{print}" $scrptdir/atomlist/list` 
 pp=`ls $scrptdir/pseudopots/*$line*`
#copy *UPF files
 cp $scrptdir/pseudopots/*"$line."* $sysname
 echo $mass" "${pp##*/} >> $sysname/pw.in
done < xyztoqetmp.txt

#export values to new qe input files
sed -i "s/0prefix0/$sysname/g" $sysname/*.in
sed -i "s/0nat0/$numatoms/g" $sysname/*.in
sed -i "s/0ntyp0/$numatomtyps/g" $sysname/*.in
sed -i "s/0prefix0/$sysname/g" $sysname/runqe

#construct ATOMIC_POSITIONS
echo 'ATOMIC_POSITIONS (angstrom)' >> $sysname/pw.in
tail -n +3 $1 >> $sysname/pw.in

#find size of system and create box=sizeofsystem+12ang
awk '$2{print sqrt($2*$2+$3*$3+$4*$4)}' $1 > xyztoqetmp2.txt
sizeofsystem=-1
while read line 
do
 if [ "${line%%.*}" -gt "${sizeofsystem%%.*}" ]
 then 
  sizeofsystem=$line 
 fi
done < xyztoqetmp2.txt

sed -i "s/0boxsize0/$(($((${sizeofsystem%%.*}*2))+12)).0/g" $sysname/pw.in

#remove tmp files
rm xyztoqetmp.txt 
rm xyztoqetmp2.txt
