//Script: bQuote()  062697  MLB

If (User in group:C338(Current user:C182; "RoleCostAccountant"))
	uSpawnProcess("IssMoveIssue"; 0; "Move Issues")
	If (False:C215)
		IssMoveIssue
	End if 
	
Else 
	ALERT:C41("You are not permitted to user this function.")
End if 
//