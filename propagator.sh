#! /bin/bash
# sh propagator xyzin1 xyzin2 x
# x should be 0<x<1 
IN1="$1"
IN2="$2"
XSTEP="$3"

awk 'BEGIN {

 i=1
 while (getline < "'"$IN1"'"){
  a[i,1]=$1
  a[i,2]=$2
  a[i,3]=$3
  a[i,4]=$4
  i++
 }
 
 i=1
 while (getline < "'"$IN2"'"){
  b[i,1]=$1
  b[i,2]=$2
  b[i,3]=$3
  b[i,4]=$4
  i++
 }

 imax=i

 x="'"$XSTEP"'"
 for(i=1;i<imax;i++){  
   print a[i,1]" "(1-x)*a[i,2]+x*b[i,2]" "(1-x)*a[i,3]+x*b[i,3]" "(1-x)*a[i,4]+x*b[i,4]
 }

}' 
