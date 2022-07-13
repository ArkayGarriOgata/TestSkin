//%attributes = {"publishedWeb":true}
//(P0 uRangeAlpha: range search on alphanumerics

C_TEXT:C284($sLo; $sHi)

$sLo:=sCriterion2
$sHi:=sCriterion3

If ($sHi="")
	$sHi:="zzz"
End if 
If ($sLo>$sHi)
	$sLo:=$sHi
	$sHi:=sCriterion2
End if 

QUERY:C277(zDefFilePtr->; aSlctField{zSelectNum}->>=$sLo+"@"; *)
QUERY:C277(zDefFilePtr->;  & ; aSlctField{zSelectNum}-><=$sHi+"@")