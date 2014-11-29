##############
# This program takes a quantum espresso file that has just the k points like:
#    k bla bla bunch o stuff
#    k1 k2 k3 .....
#    k1 k2 k3 ....
#    .
#    .
#    .
#
# and outputs a file like:
#    k# k1
#    k# k2
#    k# k3
#    .
#    .
#    .
#
# The script is called by:
# 
# awk -f qeplotbands.awk bands.file >> newbands.file
#
##############

BEGIN{
k=0
}{
 if($1=="k"){
   k=k+1 
 }else{
   if($1!=""){print k" "$1}
   if($2!=""){print k" "$2}
   if($3!=""){print k" "$3}
   if($4!=""){print k" "$4}
   if($5!=""){print k" "$5}
   if($6!=""){print k" "$6}
   if($7!=""){print k" "$7}
   if($8!=""){print k" "$8}
 }
}END{
}
