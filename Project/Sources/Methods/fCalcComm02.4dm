//%attributes = {"publishedWeb":true}
//(p)fcalccomm2
//fCalcComm02($FormSqIn;$grossSheets;$Flex2;$Flex3;$Flex4;$stdCost)
//• 4/9/98 cs nan checking/removal
//• mlb - 6/5/02  09:20 add for Special Cost
// Modified by: mel (4/2/10) use SAP cost if available

$FormSqIn:=$1
$grossSheets:=$2
$Flex2:=$3
$Flex3:=$4
$Flex4:=$5
$stdCost:=$6
$costUsed:=" std"

[Estimates_Materials:29]Qty:9:=uNANCheck((((((($FormSqIn/$Flex3)*$grossSheets)/1000)*[Estimates_Materials:29]Real1:14)/100)*$Flex4)+$Flex2)  //8.1 for the fountain waste
If ([Estimates_Materials:29]Commodity_Key:6#"02-Special")  //use standards  
	$act_cost:=Ink_get_cost([Estimates_Materials:29]Raw_Matl_Code:4)
	If ($act_cost>0)
		$stdCost:=$act_cost
		$costUsed:=" sap"
	End if 
	[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*$stdCost
	[Estimates_Materials:29]CalcDetails:24:="Coverage: "+String:C10([Estimates_Materials:29]Real1:14; "###,##0%")+$costUsed+" cost: $"+String:C10($stdCost; "#,##0")
	[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]CalcDetails:24
	If ($costUsed=" sap")
		[Estimates_Materials:29]Comments:13:="SAP PRICING USED!"+Char:C90(13)+[Estimates_Materials:29]Comments:13
	End if 
Else 
	[Estimates_Materials:29]Cost:11:=[Estimates_Materials:29]Qty:9*[Estimates_Materials:29]Real3:16
	[Estimates_Materials:29]CalcDetails:24:="Coverage: "+String:C10([Estimates_Materials:29]Real1:14; "###,##0%")+" Spl Cost= "+String:C10([Estimates_Materials:29]Real3:16)
	[Estimates_Materials:29]WorkDetails:25:=[Estimates_Materials:29]CalcDetails:24
End if 