//%attributes = {"publishedWeb":true}
//fCalcComm04 ($stdCost;$Flex2;$Flex3)
//• 4/9/98 cs nan checking/removal
//• 062300 mlb chg to plates

$stdCost:=$1
$Flex2:=$2
$Flex3:=$3

[Estimates_Materials:29]Qty:9:=uNANCheck([Estimates_Materials:29]Real1:14+[Estimates_Materials:29]Real2:15+[Estimates_Materials:29]Real3:16)
[Estimates_Materials:29]Cost:11:=uNANCheck(([Estimates_Materials:29]Real1:14*$stdCost)+([Estimates_Materials:29]Real2:15*$Flex2)+([Estimates_Materials:29]Real3:16*$Flex3))
[Estimates_Materials:29]CalcDetails:24:="Plates : "
[Estimates_Materials:29]WorkDetails:25:="Plates used: "
If ([Estimates_Materials:29]Real1:14#0)
	[Estimates_Materials:29]CalcDetails:24:=[Estimates_Materials:29]CalcDetails:24+String:C10(([Estimates_Materials:29]Real1:14*$stdCost); "$###,##0")+" for "+String:C10([Estimates_Materials:29]Real1:14; "###,##0")+" Plates."
	[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]WorkDetails:25+String:C10($stdCost; "$###,##0")+" /Film, "+String:C10([Estimates_Materials:29]Real1:14)+" plates."
End if 
If ([Estimates_Materials:29]Real2:15#0)
	[Estimates_Materials:29]CalcDetails:24:=[Estimates_Materials:29]CalcDetails:24+String:C10(([Estimates_Materials:29]Real2:15*$Flex2); "$###,##0")+" for "+String:C10([Estimates_Materials:29]Real2:15; "###,##0")+" Dycril."
	[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]WorkDetails:25+String:C10($Flex2; "$###,##0")+" /Dycril, "+String:C10([Estimates_Materials:29]Real2:15)+" Dycril."
End if 
If ([Estimates_Materials:29]Real3:16#0)
	[Estimates_Materials:29]CalcDetails:24:=[Estimates_Materials:29]CalcDetails:24+String:C10(([Estimates_Materials:29]Real3:16*$Flex3); "$###,##0")+" for "+String:C10([Estimates_Materials:29]Real3:16; "###,##0")+" Wet."
	[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]WorkDetails:25+String:C10($Flex3; "$###,##0")+" /Wet, "+String:C10([Estimates_Materials:29]Real3:16)+" Wet."
End if 