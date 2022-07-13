//%attributes = {"publishedWeb":true}
//PM: ToDo_viaPjt() -> 

//@author mlb - 5/13/02  13:15


If (Length:C16(<>pjtId)=5)
	sCriterion1:=<>pjtId
	aComparison:=5  //is
	
	aComparison{0}:=aComparison{5}
	aSelectBy:=6
	aSelectBy{0}:=aSelectBy{aSelectBy}
	POST KEY:C465(13)
End if 