If (Current user:C182="Designer") | (Current user:C182="Administrator")
	uConfirm("Send inventory data to remote db?"; "Yes"; "No")
	If (ok=1)
		CUSTPORT_WMS("move")
	End if 
Else 
	BEEP:C151
	uConfirm("Not Designer or Administrator, ehh?"; "Ohh"; "Well then")
End if 

