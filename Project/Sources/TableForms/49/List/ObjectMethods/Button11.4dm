If (User in group:C338(Current user:C182; "RoleSuperUser"))
	uConfirm("Send inventory data to remote db?"; "Yes"; "No")
	If (ok=1)
		CUSTPORT_WMS("move")
	End if 
Else 
	BEEP:C151
	uConfirm("Access restricted at the current time."; "Ohh"; "Well then")
End if 

