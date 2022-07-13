//OM: bPick() -> 
//@author mlb - 7/18/01  15:46
If (True:C214)
	CAR_Locations("new")
Else 
	
	GOTO OBJECT:C206([QA_Corrective_Actions:105]Location:6)
	[QA_Corrective_Actions:105]Location:6:="@"
	POST KEY:C465(64)
	POST KEY:C465(9)
End if 