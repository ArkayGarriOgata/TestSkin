//Script: bQuote()  062697  MLB

If (User in group:C338(Current user:C182; "WorkInProcess")) | (User in group:C338(Current user:C182; "RMReceiving"))
	uSpawnProcess("IssMsngDirctInk"; 0; "Issuing Missing Inks")
	If (False:C215)
		IssMsngDirctInk
	End if 
	
Else 
	ALERT:C41("You are not permitted to user this function.")
End if 
//