//%attributes = {"publishedWeb":true}
//PM: fCalcComm12($netCartons;$yldCartons;$stdCost) -> 
//@author mlb - 8/6/02  15:43

C_LONGINT:C283($1; $netCartons; $2; $yldCartons)
C_REAL:C285($stdCost; $3)

$netCartons:=$1
$yldCartons:=$2
$stdCost:=$3

If ([Estimates_Materials:29]Real1:14=0)
	[Estimates_Materials:29]Real1:14:=uNANCheck($netCartons)
End if 
If ([Estimates_Materials:29]Real3:16=0)
	[Estimates_Materials:29]Real3:16:=uNANCheck($yldCartons)
End if 

[Estimates_Materials:29]Qty:9:=uNANCheck([Estimates_Materials:29]Real1:14)
[Estimates_Materials:29]Cost:11:=uNANCheck([Estimates_Materials:29]Qty:9*$stdCost)
[Estimates_Materials:29]CalcDetails:24:=String:C10([Estimates_Materials:29]Real1:14)+" net "+String:C10([Estimates_Materials:29]Real1:14)+" yield "
[Estimates_Materials:29]WorkDetails:25:=String:C10([Estimates_Materials:29]Real1:14)+" Labels @ "+String:C10($stdCost)+" each"
If ([Estimates_Materials:29]Real3:16>0)  //yield field
	If ([Estimates_Materials:29]Real1:14#[Estimates_Materials:29]Real3:16)
		$tempQty:=([Estimates_Materials:29]Real3:16-[Estimates_Materials:29]Real1:14)
		[Estimates_Materials:29]Matl_YieldAdds:26:=uNANCheck($tempQty*$stdCost)
		[Estimates_Materials:29]CalcDetails:24:=[Estimates_Materials:29]CalcDetails:24+" Yield adds "+String:C10($tempQty; "###,##0")+" units."
	End if 
End if 