#!/bin/bash
# This script takes an xyz file and creates quantum espresso input files.
# Call the script with the xyz file:
#
# sh xyztoqe prefix.xyz
#
# You need to have the pseudopotential files in the pseudopots dir before you use the script.
# npbrawand@ucdavis.edu

#funcs
getnumbnd(){
python - <<END
print int($1*1.5)
END
}

getnumeps(){
python - <<END
print int($1*4)
END
}

addone(){
python - <<END
print int($1+1)
END
}

dtwo(){
python - <<END
if ($1 % 2 == 0): 
  print int($1/2.0)
else:
  print int(($1+1)/2.0)
END
}

ttwo(){
python - <<END
print $1*2
END
}

getsize(){
python - <<END
f=open('$1','r')
nat=float(f.readline())
f.readline()
lines=f.readlines()

cm = [0,0,0]
for line in lines:
  at,x,y,z = line.split()
  fx=float(x)
  fy=float(y)
  fz=float(z)
  cm[0] = cm[0] + fx
  cm[1] = cm[1] + fy
  cm[2] = cm[2] + fz
for i in range(0,2):
	cm[i] = cm[i] / nat

rmax = 0.0
for line in lines:
  at,x,y,z = line.split()
  fx=float(x)-cm[0]
  fy=float(y)-cm[1]
  fz=float(z)-cm[2]
  r = (fx**2+fy**2+fz**2)**0.5
  if r > rmax :
    rmax = r

diam=rmax*2.0
print int(diam*2+5)
END
}

#read in values
sysname=${1%%.xyz}
numatoms=$(head -n 1 $1)
tail -n $(($numatoms)) $1 | awk '{print $1}' | awk '!x[$0]++' | sed '/^$/d'> xyztoqetmp.txt 
numatomtyps=`wc -l xyztoqetmp.txt | awk '{print $1}'`
scrptdir=$(cd `dirname $0` && pwd)
numelec=`sh $scrptdir/ecount.sh $1`
numhomo=$(dtwo $numelec)
numbnd=$(getnumbnd $numhomo)
numeps=$(getnumeps $numhomo)
numlumo=$(addone $numhomo)
sizeofsystem=$(getsize $1)
numbndtwo=$(ttwo $numbnd)

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
#cp $scrptdir/pseudopots/*"$line."* $sysname
 echo $mass" "${pp##*/} >> $sysname/pw.in
done < xyztoqetmp.txt

#export values to new qe input files
sed -i "s/0prefix0/$sysname/g" $sysname/*.in
sed -i "s/0nat0/$numatoms/g" $sysname/*.in
sed -i "s/0ntyp0/$numatomtyps/g" $sysname/*.in
sed -i "s/0numelec0/$numelec/g" $sysname/*.in
sed -i "s/0numbnd0/$numbnd/g" $sysname/*.in
sed -i "s/0numbndtwo0/$numbndtwo/g" $sysname/*.in
sed -i "s/0numhomo0/$numhomo/g" $sysname/*.in
sed -i "s/0numlumo0/$numlumo/g" $sysname/*.in
sed -i "s/0numeps0/$numeps/g" $sysname/*.in
sed -i "s:0ppdir0:$scrptdir/pseudopots:g" $sysname/*.in
sed -i "s/0prefix0/$sysname/g" $sysname/runqe
sed -i "s/0boxsize0/$sizeofsystem/g" $sysname/pw.in

#construct ATOMIC_POSITIONS
echo 'ATOMIC_POSITIONS (angstrom)' >> $sysname/pw.in
tail -n +3 $1 >> $sysname/pw.in

#remove tmp files
rm xyztoqetmp.txt 
