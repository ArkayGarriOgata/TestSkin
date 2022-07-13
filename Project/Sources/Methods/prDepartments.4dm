//%attributes = {"publishedWeb":true}
//(p) prDepartments
//prBudget2Front

If (Current user:C182="Designer") | (User in group:C338(Current user:C182; "Purchasing"))
	If (<>DeptProc#0)
		BRING TO FRONT:C326(<>DeptProc)
	Else 
		<>DeptProc:=uSpawnPalette("DeptPallet"; "$Department Palette")
	End if 
Else 
	uNotAuthorized
End if 