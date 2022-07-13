//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceTotalCharges(controlnumber;->cost;->price) -> num priced
//@author mlb - 6/28/01  16:52
C_TEXT:C284($1)
C_LONGINT:C283($i; $0; $num)
C_REAL:C285($actual; $quoted; $revised)
C_POINTER:C301($2; $3; $4)

If ([Finished_Goods_Specifications:98]ControlNumber:2#$1)
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$1)
End if 

QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=[Finished_Goods_Specifications:98]ControlNumber:2)
ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]SortOrder:12; >)
SELECTION TO ARRAY:C260([Prep_Charges:103]PriceActual:5; $aIncurred; [Prep_Charges:103]PriceQuoted:6; $aQuoted; [Prep_Charges:103]PriceRevised:11; $aRevised)
$actual:=0
$quoted:=0
$revised:=0
$num:=0
For ($i; 1; Size of array:C274($aIncurred))
	$actual:=$actual+$aIncurred{$i}
	$quoted:=$quoted+$aQuoted{$i}
	$revised:=$revised+$aRevised{$i}
	If ($aQuoted{$i}>0)
		$num:=$num+1
	End if 
End for 

$2->:=$quoted
$3->:=$actual
$4->:=$revised
$0:=$num
//