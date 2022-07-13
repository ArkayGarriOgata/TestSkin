If (User in group:C338(Current user:C182; "RoleSuperUser"))
	uConfirm("Recieve inventory data to remote db?"; "Yes"; "No")
	If (ok=1)
		CUSTPORT_WMS("relieve")
	End if 
Else 
	BEEP:C151
	uConfirm("Access restricted at the current time."; "Ohh"; "Well then")
End if 

