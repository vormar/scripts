#!/bin/bash
# finds the average contribution from 1 type of atom to a given energy
# sh pdosatmavg <energy> <atom type>
totstates=`awk "/$1/{print}" ./chipBr1.pdos_atm#*$2* | awk 'BEGIN{a=0;n=0}{a=a+$2;n=n+1}END{print n}'`
tot=`awk "/$1/{print}" ./chipBr1.pdos_atm#*$2* | awk 'BEGIN{a=0;n=0}{a=a+$2;n=n+1}END{print a}'`
avg=`awk "/$1/{print}" ./chipBr1.pdos_atm#*$2* | awk 'BEGIN{a=0;n=0}{a=a+$2;n=n+1}END{print a/n}'`
echo "energy: $1    atomtype: $2    totalfiles: $totstates    avg: $avg    tot: $tot"
