//%attributes = {"publishedWeb":true}
//fCalcComm07ED($FormSqIn;$Flex2;$stdCost)
//• 4/9/98 cs nan checking/removal

$FormSqIn:=$1
$Flex2:=$2
$stdCost:=$3

[Estimates_Materials:29]Qty:9:=uNANCheck($FormSqIn*[Estimates_Materials:29]Real1:14/100*$Flex2)
[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*$stdCost
[Estimates_Materials:29]Qty:9:=1  //upr 1456 3/21/95 chg uom's on 7 and 13laser
[Estimates_Materials:29]CalcDetails:24:="Emboss area: "+String:C10([Estimates_Materials:29]Real1:14; "###,##0%")+"SqIn: "+String:C10($FormSqIn)
[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]CalcDetails:24