BEGIN{

  i=0
  j=0
  n=0
  norm=0
  maxd=0

}{

  i++
  a[i,1]=$2
  a[i,2]=$3
  a[i,3]=$4

}END{

  n=i
  for(i=1;i<=n;i++){
    for(j=1;j<=n;j++){
      norm=sqrt((a[j,1]-a[i,1])**2+(a[j,2]-a[i,2])**2+(a[j,3]-a[i,3])**2)
      if(maxd<norm){
        maxd=norm
      }
    }
  }
  print ""
  print "assume input is in angs"
  print "bohr: " maxd * 1.8897161646320724
  print "ang: " maxd
  print ""

}
