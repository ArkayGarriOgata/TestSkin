//%attributes = {"publishedWeb":true}
//fCalcComm07($stdCost;$Flex2;$netCartons;$yldCartons)
//• 4/9/98 cs nan checking/removal

$stdCost:=$1
$Flex2:=$2
$netCartons:=$3
$yldCartons:=$4

If ([Estimates_Materials:29]Real1:14=0)
	[Estimates_Materials:29]Real1:14:=$netCartons
End if 
If ([Estimates_Materials:29]Real2:15=0)
	[Estimates_Materials:29]Real2:15:=$yldCartons
End if 
[Estimates_Materials:29]Qty:9:=uNANCheck([Estimates_Materials:29]Real1:14/1000*$Flex2)
[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*$stdCost
[Estimates_Materials:29]CalcDetails:24:=" Net Cartons: "+String:C10([Estimates_Materials:29]Real1:14/1000*$Flex2)+"M"
If ([Estimates_Materials:29]Real2:15#[Estimates_Materials:29]Real1:14)
	$tempQty:=uNANCheck(([Estimates_Materials:29]Real2:15-[Estimates_Materials:29]Real1:14)/1000*$Flex2)
	[Estimates_Materials:29]Matl_YieldAdds:26:=uNANCheck($tempQty*$stdCost)
	[Estimates_Materials:29]CalcDetails:24:=[Estimates_Materials:29]CalcDetails:24+" Yield adds "+String:C10($tempQty; "###,##0")+"M units."
End if 
[Estimates_Materials:29]Qty:9:=1  //upr 1456 3/21/95 chg uom's on 7 and 13laser     
[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]CalcDetails:24