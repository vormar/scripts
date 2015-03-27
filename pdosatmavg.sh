#!/bin/bash
# finds the average contribution from 1 type of atom to a given energy
# sh pdosatmavg <energy> <atom type>


# total files of that one atom type
totstates=`awk "/$1/{print}" ./*.pdos_atm#*$2* | awk 'BEGIN{n=0}{n=n+1}END{print n}'`


# total amount given by the one type
tot=`awk "/$1/{print}" ./*.pdos_atm#*$2* | awk 'BEGIN{a=0}{a=a+$2}END{print a}'`


# find avg given by all atoms of one type
avg=`awk "/$1/{print}" ./*.pdos_atm#*$2* | awk 'BEGIN{a=0;n=0}{a=a+$2;n=n+1}END{print a/n}'`


# find the file num that gives the most
maxflnum=`awk "/$1/{print}" ./*.pdos_atm#*$2* | awk 'BEGIN{n=0}{
  if(n=0){
  a=$2
  }else{
    if(a < $2){
      a=$2 
    }
  }
  n=n+1
  }END{print n}'`


# max amount given by the one state
max=`awk "/$1/{print}" ./*.pdos_atm#*$2* | awk 'BEGIN{n=0}{
  if(n=0){
  a=$2
  }else{
    if(a < $2){
      a=$2 
    }
  }
  n=n+1
  }END{print a}'`


# find the name of the file that gives the max amount
#maxfl=`ls ./*.pdos_atm#*$2* | awk '{ if (NR==n) print $1 }' n=${maxflnum}`
#maxfl=`grep $max ./*.pdos_atm#*$2*`

echo ""
echo "energy: $1    atomtype: $2    totalfiles: $totstates    avg: $avg    tot: $tot   max: $max"
echo ""
echo "max given from files:"
tmp="${1##-}.*$max"
grep -E "$tmp" *pdos_atm#*$2*
echo ""
