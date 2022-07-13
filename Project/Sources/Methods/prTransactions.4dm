//%attributes = {"publishedWeb":true}
//PM: prTransactions() -> 
//@author Mel - 5/21/03  10:51
//(p) prDepartments
//prBudget2Front

If (Current user:C182="Designer") | (User in group:C338(Current user:C182; "Physical Inv"))
	$id:=uProcessID("$Transaction_Palette")
	
	If ($id#-1)
		BRING TO FRONT:C326($id)
	Else 
		$errCode:=uSpawnPalette("Trans_Palette"; "$Transaction_Palette")
	End if 
	
Else 
	uNotAuthorized
End if 