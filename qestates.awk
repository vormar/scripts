BEGIN{
bandflag=0
n=0
spinflag=0
downflag=0
states=1
}{
 if($4 == "states="){statenum=$5}
 if($3 == "electrons" && $4 == "=" && NF == 5){enum=$5/2}
 if($3 == "electrons" && $4 == "=" && NF == 9){
  spinflag=1
  enum=$7 
 }
 if($8 == "bands"){bandflag=1}
 if($1 == "highest" || $1 == "!"){bandflag=0}

 if(bandflag == 1){
  if($2=="SPIN"&&$3=="DOWN"){
   downflag=1
   states=1
  }
  if(n>0 && $2 != "SPIN" && $1 != "k"){
    if(downflag==0){  
      for(i=1 ; i<=NF ; i++){
        print "1 " $i 
      } 
    }else{
      for(i=1 ; i<=NF ; i++){
        print "-1 " $i 
      } 
    }

  }
  n++
 }

}END{
print "# unoc up states " statenum-enum "   # unoc down states " (statenum)-(enum-1)
}



