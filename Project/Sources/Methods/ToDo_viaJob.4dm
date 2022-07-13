//%attributes = {"publishedWeb":true}
//PM: ToDo_viaJob() -> 

//@author mlb - 5/10/02  15:19


If (Length:C16(<>jobform)>=5)
	sCriterion1:=<>jobform
	aComparison:=1  //starts with
	
	aComparison{0}:=aComparison{aComparison}
	aSelectBy:=2
	aSelectBy{0}:=aSelectBy{aSelectBy}
	POST KEY:C465(13)
Else 
	sCriterion1:=""
End if 