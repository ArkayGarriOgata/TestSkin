If (Current user:C182="Designer") | (Current user:C182="Administrator")
	uConfirm("Recieve inventory data to remote db?"; "Yes"; "No")
	If (ok=1)
		CUSTPORT_WMS("relieve")
	End if 
Else 
	BEEP:C151
	uConfirm("Not Designer or Administrator, ehh?"; "Ohh"; "Well then")
End if 

