#!/bin/bash
# sh PrintHOMOWFC.sh NS SC INFILE OUT
# NS number of spin channels (1 or 2)
# SC spin channel to print (1 or 2)

IN=$3
OUT=$4
PREFIX=`awk '/prefix/{print $3}' $IN`
PREFIX=${PREFIX##\"}
PREFIX=${PREFIX##*\'}
PREFIX=${PREFIX%%\"*}
PREFIX=${PREFIX%%\'*}
NS=$1
SC=$2

#get band number
if [ $NS == 2 ]; then
 if [ $SC == 1 ]; then
  BAND=`awk '/number of electrons       =/{print $7}' $OUT`
  BAND=${BAND%%,}
  BAND=${BAND%%.*}
 elif [ $SC == 2 ]; then
  BAND=`awk '/number of electrons       =/{print $9}' $OUT`
  BAND=${BAND%%)}
  BAND=${BAND%%.*}
 else
  echo "SC must be 1 or 2"
  exit 0
 fi

elif [ $NS == 1 ]; then
 if [ $SC == 1 ]; then
  BAND=`awk '/number of electrons       =/{print $5}' $OUT`
  BAND=${BAND%%.*}
  BAND=$((BAND / 2))
 else
  echo "SC must be 1 if NC is 1"
  exit 0
 fi

else 
 echo "NS must be 1 or 2"
 exit 0

fi

OUTPUT=${PREFIX}_${BAND}_${SC}

cat > ./${OUTPUT}.in << EOF
&INPUTPP
 prefix= 'PREFIX' 
 outdir='./out'
 filplot= 'FILPLOT' 
 plot_num=7
 kpoint=SPIN
 kband=BAND
 lsign=.TRUE.
/
&PLOT
 iflag=3
 output_format=6
 fileout= 'FILPLOT.cube' 
/
EOF

sed -i "s/PREFIX/$PREFIX/g" ${OUTPUT}.in
sed -i "s/FILPLOT/$OUTPUT/g" ${OUTPUT}.in
sed -i "s/SPIN/$SC/g" ${OUTPUT}.in
sed -i "s/BAND/$BAND/g" ${OUTPUT}.in

echo "aprun -n 240  pp.x < ${OUTPUT}.in >& ${OUTPUT}.out" >> ./runqe
