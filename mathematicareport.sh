#!/bin/bash
# will report "{size, energy}," for all out files under rootdir
# sh mathematicareport.sh rootdir [u]
# last input is optional  if 'u' (uncorrected) then remove dispersion correction

if [ "$2" != "u" ]
then
  
#  echo ""
#  echo "corrected energies from $1"
  echo ""
  mathname=`echo $1 | sed "s:\./::g" | sed "s:/::g"`
  echo "$mathname = {"
  for ff in ${1}/*.out
    do 
    acell=`awk '/lattice parameter /{print $5*0.529177249}' $ff`
    energy=`awk '/!    total energy/{print $5}' $ff`
    if [ -n "$energy" ] 
    then
      echo "{$acell, $energy},"
    fi
  done
  echo "};"
  echo ""

else

#  echo ""
#  echo "UNcorrected energies from $1"
  echo ""
  mathname=`echo $1 |sed "s:./::g"`
  echo "$mathname = {"
  for ff in ${1}/*.out
    do 
    acell=`awk '/lattice parameter /{print $5*0.529177249}' $ff`
    energy=`awk '/!    total energy/{print $5}' $ff`
    corr=`awk '/Dispersion Correction     =/{print $4}' $ff`
    uncoren=`echo "($energy)-($corr)" |bc`
    if [ -n "$energy" ] 
    then
      echo "{$acell, $uncoren},"
    fi
  done
  echo "};"
  echo ""

fi
#Dispersion Correction     = 
