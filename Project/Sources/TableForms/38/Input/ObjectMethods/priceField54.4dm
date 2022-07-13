// • mel (5/11/05, 11:57:37) use normal commission rates
C_LONGINT:C283($scale)
C_REAL:C285($targetPV)
$scale:=INV_getCommissionScale([Estimates:17]Cust_ID:2; [Estimates:17]ProjectNumber:63; [Estimates:17]Brand:3)
$markup:=[Estimates_Differentials:38]MarkupConversion:40+[Estimates_Differentials:38]MarkupMaterial:41
If ($markup>0)
	$targetPV:=($markup-1)/$markup
	[Estimates_Differentials:38]CommissionRate:42:=INV_useScale($scale; $targetPV)
Else 
	[Estimates_Differentials:38]CommissionRate:42:=0
End if 
