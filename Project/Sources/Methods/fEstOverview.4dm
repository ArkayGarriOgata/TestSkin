//%attributes = {"publishedWeb":true}
//upr 1190 9/22/94
C_LONGINT:C283($1)  //overview:=fEstOverview(records in sel(caseScen))
C_TEXT:C284($0)
ARRAY TEXT:C222($aCase; 0)
ARRAY INTEGER:C220($aForm; 0)
ARRAY LONGINT:C221($aTpieces; 0)

SELECTION TO ARRAY:C260([Estimates_Differentials:38]Id:1; $aID; [Estimates_Differentials:38]diffNum:3; $aCase; [Estimates_Differentials:38]NumForms:4; $aForm; [Estimates_Differentials:38]TotalPieces:8; $aTpieces)
SORT ARRAY:C229($aID; $aCase; $aForm; $aTpieces; >)

$0:="Job Nº: "+String:C10([Estimates:17]JobNo:50; "00000")+" Order Nº:"+String:C10([Estimates:17]OrderNo:51; "00000")+Char:C90(13)  //upr 1190

For ($i; 1; $1)  // get an overview of the report
	$0:=$0+"Differential "+$aCase{$i}+" has "
	$0:=$0+String:C10($aForm{$i})+" form"+("s"*Num:C11($aForm{$i}>1))+" and  "
	$0:=$0+String:C10($aTpieces{$i})+" pieces."+Char:C90(13)
End for 