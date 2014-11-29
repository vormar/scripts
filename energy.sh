#!/bin/bash
# sh energy.sh pw.out

cat >> feedtmp.awk << EOF
BEGIN{
bandflag=0
n=0
spinflag=0
downflag=0
states=1
}{
 if(\$4 == "states="){statenum=\$5}
 if(\$3 == "electrons" && \$4 == "=" && NF == 5){enum=\$5/2}
 if(\$3 == "electrons" && \$4 == "=" && NF == 9){
  spinflag=1
  enum=\$7 
 }
 if(\$8 == "bands"){bandflag=1}
 if(\$1 == "highest" || \$1 == "!"){bandflag=0}

 if(bandflag == 1){
  if(\$2=="SPIN"&&\$3=="DOWN"){
   downflag=1
   states=1
  }
  if(n>0 && \$2 != "SPIN" && \$1 != "k"){
    if(downflag==0){  
      for(i=1 ; i<=NF ; i++){
        print "1 " \$i 
      } 
    }else{
      for(i=1 ; i<=NF ; i++){
        print "-1 " \$i 
      } 
    }

  }
  n++
 }
}END{
print "# unoc up states " statenum-enum "   # unoc down states " (statenum)-(enum-1)
}
EOF

awk -f feedtmp.awk $1 > ${1}elev

cat >> feedtmp.m << EOF 
data = Import["${1}elev", "Table"];
upunoc = Last[data][[5]];
downunoc = Last[data][[10]];
data = Drop[data, -1];
datatable = 
  Table[{{data[[i, 1]] + 1, data[[i, 2]]}, {Abs[data[[i, 1]] + .05], 
     data[[i, 2]]}}, {i, 1, Length[data]}];

plot = ListLinePlot[datatable,
  Frame -> True,
  PlotStyle -> Directive[Thickness[.005], Darker[Blue, .4]],
  PlotRange -> {data[[Length[data] - upunoc - 4, 2]], 
    data[[Length[data], 2]] + 0.1},
  FrameStyle -> Large,
  FrameLabel -> {{"Energy eV", ""}, {"", "${1}elev"}},
  ImageSize -> 900
  ]
Export["${1}elev.png", plot]
EOF

math -script feedtmp.m
rm ./feedtmp.awk
rm ./feedtmp.m
