//%attributes = {"publishedWeb":true}
//fCalcComm06($netCartons;$yldCartons;$stdCost;$Flex2;$Flex3)
//• 4/9/98 cs nan checking/removal

C_LONGINT:C283($1; $netCartons; $2; $yldCartons)

$netCartons:=$1
$yldCartons:=$2
$stdCost:=$3
$Flex2:=$4
$Flex3:=$5

If ([Estimates_Materials:29]Real1:14=0)
	[Estimates_Materials:29]Real1:14:=uNANCheck($netCartons)
End if 
If ([Estimates_Materials:29]Real3:16=0)
	[Estimates_Materials:29]Real3:16:=uNANCheck($yldCartons)
End if 
If ([Estimates_Materials:29]Real2:15#0)  //packing qty     `3/30/95 was flex2          
	[Estimates_Materials:29]Qty:9:=uNANCheck([Estimates_Materials:29]Real1:14/[Estimates_Materials:29]Real2:15/$Flex2*$Flex3)
	[Estimates_Materials:29]Cost:11:=uNANCheck([Estimates_Materials:29]Qty:9*$stdCost)
Else   //upr 1405 1/31/95
	[Estimates_Materials:29]Qty:9:=0
	[Estimates_Materials:29]Cost:11:=0
	BEEP:C151
	BEEP:C151
	MESSAGE:C88("PACKING QUANTITY = 0, CORREGATED COSTS SET TO 0 (Zero)")
End if 
[Estimates_Materials:29]CalcDetails:24:=String:C10($Flex2)+" Cases per sheet"
[Estimates_Materials:29]WorkDetails:25:=String:C10($Flex2)+" Cases per sheet  "+String:C10([Estimates_Materials:29]Real1:14)+" Cartons "+String:C10([Estimates_Materials:29]Real2:15)+" pack count"
If ([Estimates_Materials:29]Real3:16>0)  //yield field
	If ([Estimates_Materials:29]Real1:14#[Estimates_Materials:29]Real3:16)
		$tempQty:=([Estimates_Materials:29]Real3:16-[Estimates_Materials:29]Real1:14)/[Estimates_Materials:29]Real2:15/$Flex2*$Flex3
		[Estimates_Materials:29]Matl_YieldAdds:26:=uNANCheck($tempQty*$stdCost)
		[Estimates_Materials:29]CalcDetails:24:=[Estimates_Materials:29]CalcDetails:24+" Yield adds "+String:C10($tempQty; "###,##0")+" units."
	End if 
End if 