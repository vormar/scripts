BEGIN{
a=5.43
b=5.43
c=0
nline=1
atoms=0
}

{
if(nline > 2){
 print $1" "$2" "$3" "$4
 print $1" "$2+a" "$3" "$4
 print $1" "$2" "$3+b" "$4
 print $1" "$2" "$3" "$4+c
 print $1" "$2+a" "$3+b" "$4
 atoms=atoms+5
}
else{
 print
 nline=nline+1
}
}

END{
print ""
print atoms 
}
