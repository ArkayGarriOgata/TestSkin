//%attributes = {"publishedWeb":true}
//fCalcComm51
//• 4/9/98 cs nan checking/removal

C_TEXT:C284($1; $thisUM)
C_LONGINT:C283($netCartons; $2; $yldCartons; $3; $matlError; $0)
C_REAL:C285($Flex2; $4; $stdCost; $5; $tempQty)

$thisUM:=$1
$netCartons:=$2
$yldCartons:=$3
$Flex2:=$4
$stdCost:=$5
$thisUM:="EACH"
[Estimates_Materials:29]Commodity_Key:6:="07-Stamping Dies"
[Estimates_Materials:29]UOM:8:="EACH"

BEEP:C151
ALERT:C41("FIX YOUR PROCESS SPEC, IT IS STILL USING COMMODIY 51 WHICH IS OBSOLETE!")

If ($thisUM="M")
	If ([Estimates_Materials:29]Real1:14=0)
		[Estimates_Materials:29]Real1:14:=$netCartons
	End if 
	If ([Estimates_Materials:29]Real2:15=0)
		[Estimates_Materials:29]Real2:15:=$yldCartons
	End if 
	[Estimates_Materials:29]Qty:9:=uNANCheck([Estimates_Materials:29]Real1:14/1000*$Flex2)
	[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*$stdCost
	If ([Estimates_Materials:29]Real2:15#[Estimates_Materials:29]Real1:14)
		$tempQty:=uNANCheck(([Estimates_Materials:29]Real2:15-[Estimates_Materials:29]Real1:14)/1000*$Flex2)
		[Estimates_Materials:29]Matl_YieldAdds:26:=$tempQty*$stdCost
		[Estimates_Materials:29]CalcDetails:24:="Yield adds "+String:C10($tempQty; "###,##0")+" units."
	End if 
Else 
	$matlError:=-5101
	$0:=$matlError
End if 

$0:=0