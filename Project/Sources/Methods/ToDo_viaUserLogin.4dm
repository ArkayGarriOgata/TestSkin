//%attributes = {"publishedWeb":true}
//PM: ToDo_viaUserLogin() -> 
//@author mlb - 7/12/02  10:21

If (Length:C16(sCriterion1)=0)
	sCriterion1:=Current user:C182
	aComparison:=1
	aComparison{0}:=aComparison{aComparison}
	aSelectBy:=1
	aSelectBy{0}:=aSelectBy{aSelectBy}
	cbDone:=1
	POST KEY:C465(13)
End if 