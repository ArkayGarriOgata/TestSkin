//%attributes = {"publishedWeb":true}
//Procedure: uAgeTallyCust($numCusts)  031496  MLB
//this is called only by rRptCustAgeInv3
//works on global arrays, sorry
C_LONGINT:C283($1; $numCusts)

$numCusts:=$1
aL6{$numCusts}:=aL6{$numCusts}+aL1{$numCusts}+aL2{$numCusts}+aL3{$numCusts}+aL4{$numCusts}+aL0{$numCusts}
rGroup5{$numCusts}:=rGroup5{$numCusts}+rGroup1{$numCusts}+rGroup2{$numCusts}+rGroup3{$numCusts}+rGroup4{$numCusts}+rGroup0{$numCusts}
//*     Calculate vertical totals          
aL7{1}:=aL7{1}+aL0{$numCusts}
aL7{2}:=aL7{2}+aL1{$numCusts}
aL7{3}:=aL7{3}+aL2{$numCusts}
aL7{4}:=aL7{4}+aL3{$numCusts}
aL7{5}:=aL7{5}+aL4{$numCusts}
aL7{6}:=aL7{6}+aL5{$numCusts}
aL7{7}:=aL7{7}+aL6{$numCusts}

rGroup6{1}:=rGroup6{1}+rGroup0{$numCusts}
rGroup6{2}:=rGroup6{2}+rGroup1{$numCusts}
rGroup6{3}:=rGroup6{3}+rGroup2{$numCusts}
rGroup6{4}:=rGroup6{4}+rGroup3{$numCusts}
rGroup6{5}:=rGroup6{5}+rGroup4{$numCusts}
rGroup6{6}:=rGroup6{6}+rGroup5{$numCusts}
//