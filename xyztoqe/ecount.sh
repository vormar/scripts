#!/bin/bash
# sh script.sh xyz.in
#

#vars
xyzfil=$1
mydir=`pwd`
ppdir="$mydir/pseudopots"
etot=0

#functions
getz(){
atomz=`awk "/z_valence/{print}" $pp` ; atomz=${atomz#*\"} ; atomz=${atomz%%\.*} 
}

#main

#remove tabs
sed -i "s/\t/ /g" $xyzfil

while read line;
do

  atom="${line%%[0-9]*}"
  atom="${atom%%\t*}"
  atom="${atom%%\ *}"

  # if atom is there get pp file name
  if [ ! -z "$atom" ]
  then
    pp=`ls $ppdir/${atom}.*UPF`
  fi

  # if pp is there add z electrons to etot
  if [ -e "$pp" ]
  then
    getz
    etot=$(($etot + $atomz))
    echo $etot
  fi

done < $xyzfil
