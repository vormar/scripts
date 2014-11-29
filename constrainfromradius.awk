
BEGIN{
ox=12.18913
oy=7.37246
oz=3.56623
}

{
varx=$2-ox 
vary=$3-oy
varz=$4-oz
distfromo=sqrt(varx^2+vary^2+varz^2)

if (distfromo <= 4)
 print $1" "$2" "$3" "$4" "1" "1" "1 
else
 print $1" "$2" "$3" "$4" "0" "0" "0
}
