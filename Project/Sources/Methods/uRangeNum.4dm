//%attributes = {"publishedWeb":true}
//(P) uRangeNum: search on range of numbers

C_REAL:C285($rLo; $rHi)

$rLo:=Num:C11(sCriterion2)
$rHi:=Num:C11(sCriterion3)

If ($rHi=0)
	Case of 
		: (sSlctType="I")
			$rHi:=32767
		: (sSlctType="L")
			$rHi:=2147483647
		: (sSlctType="R")
			$rHi:=1+1022
	End case 
End if 

If ($rLo>$rHi)
	$rHi:=$rLo
	$rLo:=Num:C11(sCriterion2)
End if 

QUERY:C277(zDefFilePtr->; aSlctField{zSelectNum}->>=$rLo; *)
QUERY:C277(zDefFilePtr->;  & ; aSlctField{zSelectNum}-><=$rHi)